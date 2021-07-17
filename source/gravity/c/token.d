module gravity.c.token;

//
//  gravity_token.h
//  gravity
//
//  Created by Marco Bambini on 31/08/14.
//  Copyright (c) 2014 CreoLabs. All rights reserved.
//

extern (C):

//    ================
//    PREFIX OPERATORS
//    ================
//    +         Unary PLUS
//    -         Unary MINUS
//    !         Logical NOT
//    ~         Bitwise NOT

//    ================
//    INFIX OPERATORS
//    ================
//    <<        Bitwise left shift (160)
//    >>        Bitwise right shift (160)
//    *         Multiply (150) (associativity left)
//    /         Divide (150) (associativity left)
//    %         Remainder (150) (associativity left)
//    &         Bitwise AND (150) (associativity left)
//    +         Add (140) (associativity left)
//    -         Subtract (140) (associativity left)
//    |         Bitwise OR (140) (associativity left)
//    ^         Bitwise XOR (140) (associativity left)
//    ..<       Half-open range (135)
//    ...       Closed range (135)
//    is        Type check (132)
//    <         Less than (130)
//    <=        Less than or equal (130)
//    >         Greater than (130)
//    >=        Greater than or equal (130)
//    ==        Equal (130)
//    !=        Not equal (130)
//    ===       Identical (130)
//    !==       Not identical (130)
//    ~=        Pattern match (130)
//    &&        Logical AND (120) (associativity left)
//    ||        Logical OR (110) (associativity left)
//    ?:        Ternary conditional (100) (associativity right)
//    =         Assign (90) (associativity right)
//    *=        Multiply and assign (90) (associativity right)
//    /=        Divide and assign (90) (associativity right)
//    %=        Remainder and assign (90) (associativity right)
//    +=        Add and assign (90) (associativity right)
//    -=        Subtract and assign (90) (associativity right)
//    <<=       Left bit shift and assign (90) (associativity right)
//    >>=       Right bit shift and assign (90) (associativity right)
//    &=        Bitwise AND and assign (90) (associativity right)
//    ^=        Bitwise XOR and assign (90) (associativity right)
//    |=        Bitwise OR and assign (90) (associativity right)

enum gtoken_t
{
    // General (8)
    TOK_EOF = 0,
    TOK_ERROR = 1,
    TOK_COMMENT = 2,
    TOK_STRING = 3,
    TOK_NUMBER = 4,
    TOK_IDENTIFIER = 5,
    TOK_SPECIAL = 6,
    TOK_MACRO = 7,

    // Keywords (36)
    // remember to keep in sync functions token_keywords_indexes and token_name
    TOK_KEY_FUNC = 8,
    TOK_KEY_SUPER = 9,
    TOK_KEY_DEFAULT = 10,
    TOK_KEY_TRUE = 11,
    TOK_KEY_FALSE = 12,
    TOK_KEY_IF = 13,
    TOK_KEY_ELSE = 14,
    TOK_KEY_SWITCH = 15,
    TOK_KEY_BREAK = 16,
    TOK_KEY_CONTINUE = 17,
    TOK_KEY_RETURN = 18,
    TOK_KEY_WHILE = 19,
    TOK_KEY_REPEAT = 20,
    TOK_KEY_FOR = 21,
    TOK_KEY_IN = 22,
    TOK_KEY_ENUM = 23,
    TOK_KEY_CLASS = 24,
    TOK_KEY_STRUCT = 25,
    TOK_KEY_PRIVATE = 26,
    TOK_KEY_FILE = 27,
    TOK_KEY_INTERNAL = 28,
    TOK_KEY_PUBLIC = 29,
    TOK_KEY_STATIC = 30,
    TOK_KEY_EXTERN = 31,
    TOK_KEY_LAZY = 32,
    TOK_KEY_CONST = 33,
    TOK_KEY_VAR = 34,
    TOK_KEY_MODULE = 35,
    TOK_KEY_IMPORT = 36,
    TOK_KEY_CASE = 37,
    TOK_KEY_EVENT = 38,
    TOK_KEY_NULL = 39,
    TOK_KEY_UNDEFINED = 40,
    TOK_KEY_ISA = 41,
    TOK_KEY_CURRFUNC = 42,
    TOK_KEY_CURRARGS = 43,

    // Operators (36)
    TOK_OP_SHIFT_LEFT = 44,
    TOK_OP_SHIFT_RIGHT = 45,
    TOK_OP_MUL = 46,
    TOK_OP_DIV = 47,
    TOK_OP_REM = 48,
    TOK_OP_BIT_AND = 49,
    TOK_OP_ADD = 50,
    TOK_OP_SUB = 51,
    TOK_OP_BIT_OR = 52,
    TOK_OP_BIT_XOR = 53,
    TOK_OP_BIT_NOT = 54,
    TOK_OP_RANGE_EXCLUDED = 55,
    TOK_OP_RANGE_INCLUDED = 56,
    TOK_OP_LESS = 57,
    TOK_OP_LESS_EQUAL = 58,
    TOK_OP_GREATER = 59,
    TOK_OP_GREATER_EQUAL = 60,
    TOK_OP_ISEQUAL = 61,
    TOK_OP_ISNOTEQUAL = 62,
    TOK_OP_ISIDENTICAL = 63,
    TOK_OP_ISNOTIDENTICAL = 64,
    TOK_OP_PATTERN_MATCH = 65,
    TOK_OP_AND = 66,
    TOK_OP_OR = 67,
    TOK_OP_TERNARY = 68,
    TOK_OP_ASSIGN = 69,
    TOK_OP_MUL_ASSIGN = 70,
    TOK_OP_DIV_ASSIGN = 71,
    TOK_OP_REM_ASSIGN = 72,
    TOK_OP_ADD_ASSIGN = 73,
    TOK_OP_SUB_ASSIGN = 74,
    TOK_OP_SHIFT_LEFT_ASSIGN = 75,
    TOK_OP_SHIFT_RIGHT_ASSIGN = 76,
    TOK_OP_BIT_AND_ASSIGN = 77,
    TOK_OP_BIT_OR_ASSIGN = 78,
    TOK_OP_BIT_XOR_ASSIGN = 79,
    TOK_OP_NOT = 80,

    // Punctuators (10)
    TOK_OP_SEMICOLON = 81,
    TOK_OP_OPEN_PARENTHESIS = 82,
    TOK_OP_COLON = 83,
    TOK_OP_COMMA = 84,
    TOK_OP_DOT = 85,
    TOK_OP_CLOSED_PARENTHESIS = 86,
    TOK_OP_OPEN_SQUAREBRACKET = 87,
    TOK_OP_CLOSED_SQUAREBRACKET = 88,
    TOK_OP_OPEN_CURLYBRACE = 89,
    TOK_OP_CLOSED_CURLYBRACE = 90,

    // Mark end of tokens (1)
    TOK_END = 91
}

enum gliteral_t
{
    LITERAL_STRING = 0,
    LITERAL_FLOAT = 1,
    LITERAL_INT = 2,
    LITERAL_BOOL = 3,
    LITERAL_STRING_INTERPOLATED = 4
}

enum gbuiltin_t
{
    BUILTIN_NONE = 0,
    BUILTIN_LINE = 1,
    BUILTIN_COLUMN = 2,
    BUILTIN_FILE = 3,
    BUILTIN_FUNC = 4,
    BUILTIN_CLASS = 5
}

struct gtoken_s
{
    gtoken_t type; // enum based token type
    uint lineno; // token line number (1-based)
    uint colno; // token column number (0-based) at the end of the token
    uint position; // offset of the first character of the token
    uint bytes; // token length in bytes
    uint length; // token length (UTF-8)
    uint fileid; // token file id
    gbuiltin_t builtin; // builtin special identifier flag
    const(char)* value; // token value (not null terminated)
}

extern (D) auto TOKEN_BYTES(T)(auto ref T _tok)
{
    return _tok.bytes;
}

extern (D) auto TOKEN_VALUE(T)(auto ref T _tok)
{
    return _tok.value;
}

gtoken_t token_keyword (const(char)* buffer, int len);
void token_keywords_indexes (uint* idx_start, uint* idx_end);
const(char)* token_literal_name (gliteral_t value);
const(char)* token_name (gtoken_t token);
gtoken_t token_special_builtin (gtoken_s* token);
const(char)* token_string (gtoken_s token, uint* len);

bool token_isassignment (gtoken_t token);
bool token_isaccess_specifier (gtoken_t token);
bool token_iscompound_statement (gtoken_t token);
bool token_isdeclaration_statement (gtoken_t token);
bool token_iseof (gtoken_t token);
bool token_isempty_statement (gtoken_t token);
bool token_iserror (gtoken_t token);
bool token_isexpression_statement (gtoken_t token);
bool token_isflow_statement (gtoken_t token);
bool token_isjump_statement (gtoken_t token);
bool token_islabel_statement (gtoken_t token);
bool token_isloop_statement (gtoken_t token);
bool token_isidentifier (gtoken_t token);
bool token_isimport_statement (gtoken_t token);
bool token_ismacro (gtoken_t token);
bool token_isoperator (gtoken_t token);
bool token_isprimary_expression (gtoken_t token);
bool token_isspecial_statement (gtoken_t token);
bool token_isstatement (gtoken_t token);
bool token_isstorage_specifier (gtoken_t token);
bool token_isvariable_assignment (gtoken_t token);
bool token_isvariable_declaration (gtoken_t token);

