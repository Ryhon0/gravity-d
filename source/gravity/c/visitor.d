module gravity.c.visitor;

import gravity.c.ast;

//
//  gravity_visitor.h
//  gravity
//
//  Created by Marco Bambini on 08/09/14.
//  Copyright (c) 2014 CreoLabs. All rights reserved.
//

extern (C):

extern (D) auto visit(T)(auto ref T node)
{
    return gvisit(self, node);
}

struct gvisitor
{
    uint nerr; // to store err counter state
    void* data; // to store a ptr state
    bool bflag; // to store a bool flag
    void* delegate_; // delegate callback

    // COMMON
    void function (gvisitor* self, gnode_t* node) visit_pre;
    void function (gvisitor* self, gnode_t* node) visit_post;

    // count must be equal to enum gnode_n defined in gravity_ast.h less 3

    // STATEMENTS: 7
    void function (gvisitor* self, gnode_compound_stmt_t* node) visit_list_stmt;
    void function (gvisitor* self, gnode_compound_stmt_t* node) visit_compound_stmt;
    void function (gvisitor* self, gnode_label_stmt_t* node) visit_label_stmt;
    void function (gvisitor* self, gnode_flow_stmt_t* node) visit_flow_stmt;
    void function (gvisitor* self, gnode_jump_stmt_t* node) visit_jump_stmt;
    void function (gvisitor* self, gnode_loop_stmt_t* node) visit_loop_stmt;
    void function (gvisitor* self, gnode_empty_stmt_t* node) visit_empty_stmt;

    // DECLARATIONS: 5+1 (NODE_VARIABLE handled by NODE_VARIABLE_DECL case)
    void function (gvisitor* self, gnode_function_decl_t* node) visit_function_decl;
    void function (gvisitor* self, gnode_variable_decl_t* node) visit_variable_decl;
    void function (gvisitor* self, gnode_enum_decl_t* node) visit_enum_decl;
    void function (gvisitor* self, gnode_class_decl_t* node) visit_class_decl;
    void function (gvisitor* self, gnode_module_decl_t* node) visit_module_decl;

    // EXPRESSIONS: 7+3 (CALL EXPRESSIONS handled by one callback)
    void function (gvisitor* self, gnode_binary_expr_t* node) visit_binary_expr;
    void function (gvisitor* self, gnode_unary_expr_t* node) visit_unary_expr;
    void function (gvisitor* self, gnode_file_expr_t* node) visit_file_expr;
    void function (gvisitor* self, gnode_literal_expr_t* node) visit_literal_expr;
    void function (gvisitor* self, gnode_identifier_expr_t* node) visit_identifier_expr;
    void function (gvisitor* self, gnode_keyword_expr_t* node) visit_keyword_expr;
    void function (gvisitor* self, gnode_list_expr_t* node) visit_list_expr;
    void function (gvisitor* self, gnode_postfix_expr_t* node) visit_postfix_expr;
}

alias gvisitor_t = gvisitor;

void gvisit (gvisitor_t* self, gnode_t* node);

