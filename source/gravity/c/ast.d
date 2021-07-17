module gravity.c.ast;

//
//  gravity_ast.h
//  gravity
//
//  Created by Marco Bambini on 02/09/14.
//  Copyright (c) 2014 CreoLabs. All rights reserved.
//

import core.sys.posix.unistd;
import gravity.c.token;
import gravity.c.array;

extern (C):

/*
    AST can be uniform (the same data struct is used for all expressions/statements/declarations) or
    non-uniform. I choosed a non-uniform AST node implementation with a common base struct.
    It requires more work but design and usage is much more cleaner and we benefit from static check.
 */

enum gnode_n
{
    // statements: 7
    NODE_LIST_STAT = 0,
    NODE_COMPOUND_STAT = 1,
    NODE_LABEL_STAT = 2,
    NODE_FLOW_STAT = 3,
    NODE_JUMP_STAT = 4,
    NODE_LOOP_STAT = 5,
    NODE_EMPTY_STAT = 6,

    // declarations: 6
    NODE_ENUM_DECL = 7,
    NODE_FUNCTION_DECL = 8,
    NODE_VARIABLE_DECL = 9,
    NODE_CLASS_DECL = 10,
    NODE_MODULE_DECL = 11,
    NODE_VARIABLE = 12,

    // expressions: 8
    NODE_BINARY_EXPR = 13,
    NODE_UNARY_EXPR = 14,
    NODE_FILE_EXPR = 15,
    NODE_LIST_EXPR = 16,
    NODE_LITERAL_EXPR = 17,
    NODE_IDENTIFIER_EXPR = 18,
    NODE_POSTFIX_EXPR = 19,
    NODE_KEYWORD_EXPR = 20,

    // postfix subexpression type
    NODE_CALL_EXPR = 21,
    NODE_SUBSCRIPT_EXPR = 22,
    NODE_ACCESS_EXPR = 23
}

enum gnode_location_type
{
    LOCATION_LOCAL = 0,
    LOCATION_GLOBAL = 1,
    LOCATION_UPVALUE = 2,
    LOCATION_CLASS_IVAR_SAME = 3,
    LOCATION_CLASS_IVAR_OUTER = 4
}

// BASE NODE
struct gnode_t
{
    gnode_n tag; // node type from gnode_n enum
    uint refcount; // reference count to manage duplicated nodes
    uint block_length; // total length in bytes of the block (used in autocompletion)
    gtoken_s token; // token type and location
    bool is_assignment; // flag to check if it is an assignment node
    void* decl; // enclosing declaration node
}

// UPVALUE STRUCT
struct gupvalue_t
{
    gnode_t* node; // reference to the original var node
    uint index; // can be an index in the stack or in the upvalue list (depending on the is_direct flag)
    uint selfindex; // always index inside uplist
    bool is_direct; // flag to check if var is local to the direct enclosing func
}

// shortcut for array of common structs
struct gnode_r
{
    size_t n;
    size_t m;
    gnode_t** p;
}

struct gupvalue_r
{
    size_t n;
    size_t m;
    gupvalue_t** p;
}

struct symboltable_t;

// LOCATION
struct gnode_location_t
{
    gnode_location_type type; // location type
    ushort index; // symbol index
    ushort nup; // upvalue index or outer index
}

// STATEMENTS
struct gnode_compound_stmt_t
{
    gnode_t base; // NODE_LIST_STAT | NODE_COMPOUND_STAT
    symboltable_t* symtable; // node internal symbol table
    gnode_r* stmts; // array of statements node
    uint nclose; // initialized to UINT32_MAX
}

alias gnode_list_stmt_t = gnode_compound_stmt_t;

struct gnode_label_stmt_t
{
    gnode_t base; // CASE or DEFAULT
    gnode_t* expr; // expression in case of CASE
    gnode_t* stmt; // common statement
    uint label_case; // for switch to jump
}

struct gnode_flow_stmt_t
{
    gnode_t base; // IF, SWITCH, TOK_OP_TERNARY
    gnode_t* cond; // common condition (it's an expression)
    gnode_t* stmt; // common statement
    gnode_t* elsestmt; // optional else statement in case of IF
}

struct gnode_loop_stmt_t
{
    gnode_t base; // WHILE, REPEAT or FOR
    gnode_t* cond; // used in WHILE and FOR
    gnode_t* stmt; // common statement
    gnode_t* expr; // used in REPEAT and FOR
    uint nclose; // initialized to UINT32_MAX
}

struct gnode_jump_stmt_t
{
    gnode_t base; // BREAK, CONTINUE or RETURN
    gnode_t* expr; // optional expression in case of RETURN
}

// DECLARATIONS
struct gnode_function_decl_t
{
    gnode_t base; // FUNCTION_DECL or FUNCTION_EXPR
    gnode_t* env; // shortcut to node where function is declared
    gtoken_t access; // TOK_KEY_PRIVATE | TOK_KEY_INTERNAL | TOK_KEY_PUBLIC
    gtoken_t storage; // TOK_KEY_STATIC | TOK_KEY_EXTERN
    symboltable_t* symtable; // function internal symbol table
    const(char)* identifier; // function name
    gnode_r* params; // function params
    gnode_compound_stmt_t* block; // internal function statements
    ushort nlocals; // locals counter
    ushort nparams; // formal parameters counter
    bool has_defaults; // flag set if parmas has default values
    bool is_closure; // flag to check if function is a closure
    gupvalue_r* uplist; // list of upvalues used in function (can be empty)
}

alias gnode_function_expr_t = gnode_function_decl_t;

struct gnode_variable_decl_t
{
    gnode_t base; // VARIABLE_DECL
    gtoken_t type; // TOK_KEY_VAR | TOK_KEY_CONST
    gtoken_t access; // TOK_KEY_PRIVATE | TOK_KEY_INTERNAL | TOK_KEY_PUBLIC
    gtoken_t storage; // TOK_KEY_STATIC | TOK_KEY_EXTERN
    gnode_r* decls; // variable declarations list (gnode_var_t)
}

struct gnode_var_t
{
    gnode_t base; // VARIABLE
    gnode_t* env; // shortcut to node where variable is declared
    const(char)* identifier; // variable name
    const(char)* annotation_type; // optional annotation type
    gnode_t* expr; // optional assignment expression/declaration
    gtoken_t access; // optional access token (duplicated value from its gnode_variable_decl_t)
    ushort index; // local variable index (if local)
    bool upvalue; // flag set if this variable is used as an upvalue
    bool iscomputed; // flag set is variable must not be backed
    gnode_variable_decl_t* vdecl; // reference to enclosing variable declaration (in order to be able to have access to storage and access fields)
}

struct gnode_enum_decl_t
{
    gnode_t base; // ENUM_DECL
    gnode_t* env; // shortcut to node where enum is declared
    gtoken_t access; // TOK_KEY_PRIVATE | TOK_KEY_INTERNAL | TOK_KEY_PUBLIC
    gtoken_t storage; // TOK_KEY_STATIC | TOK_KEY_EXTERN
    symboltable_t* symtable; // enum internal hash table
    const(char)* identifier; // enum name
}

struct gnode_class_decl_t
{
    gnode_t base; // CLASS_DECL
    bool bridge; // flag to check of a bridged class
    bool is_struct; // flag to mark the class as a struct
    gnode_t* env; // shortcut to node where class is declared
    gtoken_t access; // TOK_KEY_PRIVATE | TOK_KEY_INTERNAL | TOK_KEY_PUBLIC
    gtoken_t storage; // TOK_KEY_STATIC | TOK_KEY_EXTERN
    const(char)* identifier; // class name
    gnode_t* superclass; // super class ptr
    bool super_extern; // flag set when a superclass is declared as extern
    gnode_r* protocols; // array of protocols (currently unused)
    gnode_r* decls; // class declarations list
    symboltable_t* symtable; // class internal symbol table
    void* data; // used to keep track of super classes
    uint nivar; // instance variables counter
    uint nsvar; // static variables counter
}

struct gnode_module_decl_t
{
    gnode_t base; // MODULE_DECL
    gnode_t* env; // shortcut to node where module is declared
    gtoken_t access; // TOK_KEY_PRIVATE | TOK_KEY_INTERNAL | TOK_KEY_PUBLIC
    gtoken_t storage; // TOK_KEY_STATIC | TOK_KEY_EXTERN
    const(char)* identifier; // module name
    gnode_r* decls; // module declarations list
    symboltable_t* symtable; // module internal symbol table
}

// EXPRESSIONS
struct gnode_binary_expr_t
{
    gnode_t base; // BINARY_EXPR
    gtoken_t op; // operation
    gnode_t* left; // left node
    gnode_t* right; // right node
}

struct gnode_unary_expr_t
{
    gnode_t base; // UNARY_EXPR
    gtoken_t op; // operation
    gnode_t* expr; // node
}

struct gnode_file_expr_t
{
    gnode_t base; // FILE
    cstring_r* identifiers; // identifier name
    gnode_location_t location; // identifier location
}

struct gnode_literal_expr_t
{
    gnode_t base; // LITERAL
    gliteral_t type; // LITERAL_STRING, LITERAL_FLOAT, LITERAL_INT, LITERAL_BOOL, LITERAL_INTERPOLATION
    uint len; // used only for TYPE_STRING

    // LITERAL_STRING
    // LITERAL_FLOAT
    // LITERAL_INT or LITERAL_BOOL
    // LITERAL_STRING_INTERPOLATED
    union _Anonymous_0
    {
        char* str;
        double d;
        long n64;
        gnode_r* r;
    }

    _Anonymous_0 value;
}

struct gnode_identifier_expr_t
{
    gnode_t base; // IDENTIFIER or ID
    const(char)* value; // identifier name
    const(char)* value2; // NULL for IDENTIFIER (check if just one value or an array)
    gnode_t* symbol; // pointer to identifier declaration (if any)
    gnode_location_t location; // location coordinates
    gupvalue_t* upvalue; // upvalue location reference
}

struct gnode_keyword_expr_t
{
    gnode_t base; // KEYWORD token
}

alias gnode_empty_stmt_t = gnode_keyword_expr_t;
alias gnode_base_t = gnode_keyword_expr_t;

struct gnode_postfix_expr_t
{
    gnode_t base; // NODE_CALLFUNC_EXPR, NODE_SUBSCRIPT_EXPR, NODE_ACCESS_EXPR
    gnode_t* id; // id(...) or id[...] or id.
    gnode_r* list; // list of postfix_subexpr
}

struct gnode_postfix_subexpr_t
{
    gnode_t base; // NODE_CALLFUNC_EXPR, NODE_SUBSCRIPT_EXPR, NODE_ACCESS_EXPR
    union
    {
        gnode_t* expr; // used in case of NODE_SUBSCRIPT_EXPR or NODE_ACCESS_EXPR
        gnode_r* args; // used in case of NODE_CALLFUNC_EXPR
    }
}

struct gnode_list_expr_t
{
    gnode_t base; // LIST_EXPR
    bool ismap; // flag to check if the node represents a map (otherwise it is a list)
    gnode_r* list1; // node items (cannot use a symtable here because order is mandatory in array)
    gnode_r* list2; // used only in case of map
}

gnode_t* gnode_block_stat_create (gnode_n type, gtoken_s token, gnode_r* stmts, gnode_t* decl, uint block_length);
gnode_t* gnode_empty_stat_create (gtoken_s token, gnode_t* decl);
gnode_t* gnode_flow_stat_create (gtoken_s token, gnode_t* cond, gnode_t* stmt1, gnode_t* stmt2, gnode_t* decl, uint block_length);
gnode_t* gnode_jump_stat_create (gtoken_s token, gnode_t* expr, gnode_t* decl);
gnode_t* gnode_label_stat_create (gtoken_s token, gnode_t* expr, gnode_t* stmt, gnode_t* decl);
gnode_t* gnode_loop_stat_create (gtoken_s token, gnode_t* cond, gnode_t* stmt, gnode_t* expr, gnode_t* decl, uint block_length);

gnode_t* gnode_class_decl_create (gtoken_s token, const(char)* identifier, gtoken_t access_specifier, gtoken_t storage_specifier, gnode_t* superclass, gnode_r* protocols, gnode_r* declarations, bool is_struct, gnode_t* decl);
gnode_t* gnode_enum_decl_create (gtoken_s token, const(char)* identifier, gtoken_t access_specifier, gtoken_t storage_specifier, symboltable_t* symtable, gnode_t* decl);
gnode_t* gnode_module_decl_create (gtoken_s token, const(char)* identifier, gtoken_t access_specifier, gtoken_t storage_specifier, gnode_r* declarations, gnode_t* decl);
gnode_t* gnode_variable_create (gtoken_s token, const(char)* identifier, const(char)* annotation_type, gnode_t* expr, gnode_t* decl, gnode_variable_decl_t* vdecl);
gnode_t* gnode_variable_decl_create (gtoken_s token, gtoken_t type, gtoken_t access_specifier, gtoken_t storage_specifier, gnode_r* declarations, gnode_t* decl);

gnode_t* gnode_function_decl_create (gtoken_s token, const(char)* identifier, gtoken_t access_specifier, gtoken_t storage_specifier, gnode_r* params, gnode_compound_stmt_t* block, gnode_t* decl);

gnode_t* gnode_binary_expr_create (gtoken_t op, gnode_t* left, gnode_t* right, gnode_t* decl);
gnode_t* gnode_file_expr_create (gtoken_s token, cstring_r* list, gnode_t* decl);
gnode_t* gnode_identifier_expr_create (gtoken_s token, const(char)* identifier, const(char)* identifier2, gnode_t* decl);
gnode_t* gnode_keyword_expr_create (gtoken_s token, gnode_t* decl);
gnode_t* gnode_list_expr_create (gtoken_s token, gnode_r* list1, gnode_r* list2, bool ismap, gnode_t* decl);
gnode_t* gnode_literal_bool_expr_create (gtoken_s token, int n, gnode_t* decl);
gnode_t* gnode_literal_float_expr_create (gtoken_s token, double f, gnode_t* decl);
gnode_t* gnode_literal_int_expr_create (gtoken_s token, long n, gnode_t* decl);
gnode_t* gnode_literal_string_expr_create (gtoken_s token, char* s, uint len, bool allocated, gnode_t* decl);
gnode_t* gnode_postfix_expr_create (gtoken_s token, gnode_t* id, gnode_r* list, gnode_t* decl);
gnode_t* gnode_postfix_subexpr_create (gtoken_s token, gnode_n type, gnode_t* expr, gnode_r* list, gnode_t* decl);
gnode_t* gnode_string_interpolation_create (gtoken_s token, gnode_r* r, gnode_t* decl);
gnode_t* gnode_unary_expr_create (gtoken_t op, gnode_t* expr, gnode_t* decl);

gnode_t* gnode_duplicate (gnode_t* node, bool deep);
const(char)* gnode_identifier (gnode_t* node);

gnode_r* gnode_array_create ();
gnode_r* gnode_array_remove_byindex (gnode_r* list, size_t index);
void gnode_array_sethead (gnode_r* list, gnode_t* node);
gupvalue_t* gnode_function_add_upvalue (gnode_function_decl_t* f, gnode_var_t* symbol, ushort n);
gnode_t* gnode2class (gnode_t* node, bool* isextern);
cstring_r* cstring_array_create ();
void_r* void_array_create ();

void gnode_free (gnode_t* node);
bool gnode_is_equal (gnode_t* node1, gnode_t* node2);
bool gnode_is_expression (gnode_t* node);
bool gnode_is_literal (gnode_t* node);
bool gnode_is_literal_int (gnode_t* node);
bool gnode_is_literal_number (gnode_t* node);
bool gnode_is_literal_string (gnode_t* node);
void gnode_literal_dump (gnode_literal_expr_t* node, char* buffer, int buffersize);

// MARK: -
/*
extern (D) auto gnode_array_init(T)(auto ref T r)
{
    return marray_init(*r);
}

extern (D) auto gnode_array_size(T)(auto ref T r)
{
    return r ? marray_size(*r) : 0;
}

extern (D) auto gnode_array_push(T0, T1)(auto ref T0 r, auto ref T1 node)
{
    return marray_push(node, *r, node);
}

extern (D) auto gnode_array_pop(T)(auto ref T r)
{
    return marray_size(*r) ? marray_pop(*r) : NULL;
}

extern (D) auto gnode_array_get(T0, T1)(auto ref T0 r, auto ref T1 i)
{
    return (i >= 0 && i < marray_size(*r)) ? marray_get(*r, i) : NULL;
}

extern (D) auto gnode_array_each(T0, T1)(auto ref T0 r, auto ref T1 block)
{
    return gtype_array_each(r, block, gnode_t*);
}

extern (D) auto gnode_array_eachbase(T0, T1)(auto ref T0 r, auto ref T1 block)
{
    return gtype_array_each(r, block, gnode_base_t*);
}

extern (D) auto cstring_array_free(T)(auto ref T r)
{
    return marray_destroy(*r);
}

extern (D) auto cstring_array_push(T0, T1)(auto ref T0 r, auto ref T1 s)
{
    return marray_push(const(char)*, *r, s);
}

extern (D) auto cstring_array_each(T0, T1)(auto ref T0 r, auto ref T1 block)
{
    return gtype_array_each(r, block, const(char)*);
}

extern (D) auto NODE_TOKEN_TYPE(T)(auto ref T _node)
{
    return _node.base.token.type;
}

extern (D) auto NODE_TAG(T)(auto ref T _node)
{
    return (cast(gnode_base_t*) _node).base.tag;
}

extern (D) auto NODE_ISA(T0, T1)(auto ref T0 _node, auto ref T1 _tag)
{
    return _node && NODE_TAG(_node) == _tag;
}

extern (D) auto NODE_ISA_FUNCTION(T)(auto ref T _node)
{
    return NODE_ISA(_node, gnode_n.NODE_FUNCTION_DECL);
}

extern (D) auto NODE_ISA_CLASS(T)(auto ref T _node)
{
    return NODE_ISA(_node, gnode_n.NODE_CLASS_DECL);
}

extern (D) auto NODE_GET_ENCLOSING(T)(auto ref T _node)
{
    return (cast(gnode_base_t*) _node).base.enclosing;
}
*/