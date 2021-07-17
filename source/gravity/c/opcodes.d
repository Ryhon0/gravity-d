module gravity.c.opcodes;

//
//  gravity_opcodes.h
//  gravity
//
//  Created by Marco Bambini on 24/09/14.
//  Copyright (c) 2014 CreoLabs. All rights reserved.
//

extern (C):

/*
        Big-endian vs Little-endian machines

        ARM architecture runs both little & big endianess, but the android, iOS, and windows phone platforms run little endian.
        95% of modern desktop computers are little-endian.
        All x86 desktops (which is nearly all desktops with the demise of the PowerPC-based Macs several years ago) are little-endian.
        It's probably actually a lot more than 95% nowadays. PowerPC was the only non-x86 architecture that has been popular for desktop
        computers in the last 20 years and Apple abandoned it in favor of x86.
        Sparc, Alpha, and Itanium did exist, but they were all very rare in the desktop market.
 */

/*
        Instructions are 32bit in length

        // 2 registers and 1 register/constant
        +------------------------------------+
        |  OP  |   Ax   |   Bx   |    Cx/K   |
        +------------------------------------+

        // instructions with no parameters
        +------------------------------------+
        |  OP  |0                            |
        +------------------------------------+

        // unconditional JUMP
        +------------------------------------+
        |  OP  |             N1              |
        +------------------------------------+

        // LOADI and JUMPF
        +------------------------------------+
        |  OP  |   Ax   |S|       N2         |
        +------------------------------------+

        OP   =>  6 bits
        Ax   =>  8 bits
        Bx   =>  8 bits
        Cx/K =>  8/10 bits
        S    =>  1 bit
        N1   =>  26 bits
        N2   =>  17 bits
 */

enum opcode_t
{
    //      ***********************************************************************************************************
    //      56 OPCODE INSTRUCTIONS (for a register based virtual machine)
    //      opcode is a 6 bit value so at maximum 2^6 = 64 opcodes can be declared
    //      ************************************************************************************************************
    //
    //      MNEMONIC        PARAMETERS          DESCRIPTION                                 OPERATION
    //      --------        ----------          ------------------------------------        ----------------------------
    //
    //  *** GENERAL COMMANDS (5) ***
    RET0 = 0, //  NONE            //  return nothing from a function          MUST BE THE FIRST OPCODE (because an implicit 0 is added
    //                                          as a safeguard at the end of any bytecode
    HALT = 1, //  NONE            //  stop VM execution
    NOP = 2, //  NONE            //  NOP                                     http://en.wikipedia.org/wiki/NOP
    RET = 3, //  A               //  return from a function                  R(-1) = R(A)
    CALL = 4, //  A, B, C         //  call a function                         R(A) = B(C0...Cn) B is callable object and C is num args

    //  *** LOAD/STORE OPERATIONS (11) ***
    LOAD = 5, //  A, B, C         //  load C from B and store in A            R(A) = R(B)[C]
    LOADS = 6, //  A, B, C         //  load C from B and store in A            R(A) = R(B)[C] (super variant)
    LOADAT = 7, //  A, B, C         //  load C from B and store in A            R(A) = R(B)[C]
    LOADK = 8, //  A, B            //  load constant into register             R(A) = K(B)
    LOADG = 9, //  A, B            //  load global into register               R(A) = G[K(B)]
    LOADI = 10, //  A, B            //  load integer into register              R(A) = I
    LOADU = 11, //  A, B            //  load upvalue into register              R(A) = U(B)
    MOVE = 12, //  A, B            //  move registers                          R(A) = R(B)
    STORE = 13, //  A, B, C         //  store A into R(B)[C]                    R(B)[C] = R(A)
    STOREAT = 14, //  A, B, C         //  store A into R(B)[C]                    R(B)[C] = R(A)
    STOREG = 15, //  A, B            //  store global                            G[K(B)] = R(A)
    STOREU = 16, //  A, B            //  store upvalue                           U(B) = R(A)

    //  *** JUMP OPERATIONS (3) ***
    JUMP = 17, //  A               //  unconditional jump                      PC += A
    JUMPF = 18, //  A, B            //  jump if R(A) is false                   (R(A) == 0)    ? PC += B : 0
    SWITCH = 19, //                  //  switch statement

    //  *** MATH OPERATIONS (19) ***
    ADD = 20, //  A, B, C         //  add operation                           R(A) = R(B) + R(C)
    SUB = 21, //  A, B, C         //  sub operation                           R(A) = R(B) - R(C)
    DIV = 22, //  A, B, C         //  div operation                           R(A) = R(B) / R(C)
    MUL = 23, //  A, B, C         //  mul operation                           R(A) = R(B) * R(C)
    REM = 24, //  A, B, C         //  rem operation                           R(A) = R(B) % R(C)
    AND = 25, //  A, B, C         //  and operation                           R(A) = R(B) && R(C)
    OR = 26, //  A, B, C         //  or operation                            R(A) = R(B) || R(C)
    LT = 27, //  A, B, C         //  < comparison                            R(A) = R(B) < R(C)
    GT = 28, //  A, B, C         //  > comparison                            R(A) = R(B) > R(C)
    EQ = 29, //  A, B, C         //  == comparison                           R(A) = R(B) == R(C)
    LEQ = 30, //  A, B, C         //  <= comparison                           R(A) = R(B) <= R(C)
    GEQ = 31, //  A, B, C         //  >= comparison                           R(A) = R(B) >= R(C)
    NEQ = 32, //  A, B, C         //  != comparison                           R(A) = R(B) != R(C)
    EQQ = 33, //  A, B, C         //  === comparison                          R(A) = R(B) === R(C)
    NEQQ = 34, //  A, B, C         //  !== comparison                          R(A) = R(B) !== R(C)
    ISA = 35, //  A, B, C         //  isa comparison                          R(A) = R(A).class == R(B).class
    MATCH = 36, //  A, B, C         //  =~ pattern match                        R(A) = R(B) =~ R(C)
    NEG = 37, //  A, B            //  neg operation                           R(A) = -R(B)
    NOT = 38, //  A, B            //  not operation                           R(A) = !R(B)

    //  *** BIT OPERATIONS (6) ***
    LSHIFT = 39, //  A, B, C         //  shift left                              R(A) = R(B) << R(C)
    RSHIFT = 40, //  A, B, C         //  shift right                             R(A) = R(B) >> R(C)
    BAND = 41, //  A, B, C         //  bit and                                 R(A) = R(B) & R(C)
    BOR = 42, //  A, B, C         //  bit or                                  R(A) = R(B) | R(C)
    BXOR = 43, //  A, B, C         //  bit xor                                 R(A) = R(B) ^ R(C)
    BNOT = 44, //  A, B            //  bit not                                 R(A) = ~R(B)

    //  *** ARRAY/MAP/RANGE OPERATIONS (4) ***
    MAPNEW = 45, //  A, B            //  create a new map                        R(A) = Alloc a MAP(B)
    LISTNEW = 46, //  A, B            //  create a new array                      R(A) = Alloc a LIST(B)
    RANGENEW = 47, //  A, B, C, f      //  create a new range                      R(A) = Alloc a RANGE(B,C) f flag tells if B inclusive or exclusive
    SETLIST = 48, //  A, B, C         //  set list/map items

    //  *** CLOSURES (2) ***
    CLOSURE = 49, //  A, B            //  create a new closure                    R(A) = closure(K(B))
    CLOSE = 50, //  A               //  close all upvalues from R(A)

    //  *** UNUSED (6) ***
    CHECK = 51, //  A               //  checkpoint for structs                  R(A) = R(A).clone (if A is a struct)
    RESERVED2 = 52, //                  //  reserved for future use
    RESERVED3 = 53, //                  //  reserved for future use
    RESERVED4 = 54, //                  //  reserved for future use
    RESERVED5 = 55, //                  //  reserved for future use
    RESERVED6 = 56 //                  //  reserved for future use
}

enum GRAVITY_LATEST_OPCODE = opcode_t.RESERVED6; // used in some debug code so it is very useful to define the latest opcode here

enum GRAVITY_VTABLE_INDEX
{
    GRAVITY_NOTFOUND_INDEX = 0,
    GRAVITY_ADD_INDEX = 1,
    GRAVITY_SUB_INDEX = 2,
    GRAVITY_DIV_INDEX = 3,
    GRAVITY_MUL_INDEX = 4,
    GRAVITY_REM_INDEX = 5,
    GRAVITY_AND_INDEX = 6,
    GRAVITY_OR_INDEX = 7,
    GRAVITY_CMP_INDEX = 8,
    GRAVITY_EQQ_INDEX = 9,
    GRAVITY_IS_INDEX = 10,
    GRAVITY_MATCH_INDEX = 11,
    GRAVITY_NEG_INDEX = 12,
    GRAVITY_NOT_INDEX = 13,
    GRAVITY_LSHIFT_INDEX = 14,
    GRAVITY_RSHIFT_INDEX = 15,
    GRAVITY_BAND_INDEX = 16,
    GRAVITY_BOR_INDEX = 17,
    GRAVITY_BXOR_INDEX = 18,
    GRAVITY_BNOT_INDEX = 19,
    GRAVITY_LOAD_INDEX = 20,
    GRAVITY_LOADS_INDEX = 21,
    GRAVITY_LOADAT_INDEX = 22,
    GRAVITY_STORE_INDEX = 23,
    GRAVITY_STOREAT_INDEX = 24,
    GRAVITY_INT_INDEX = 25,
    GRAVITY_FLOAT_INDEX = 26,
    GRAVITY_BOOL_INDEX = 27,
    GRAVITY_STRING_INDEX = 28,
    GRAVITY_EXEC_INDEX = 29,
    GRAVITY_VTABLE_SIZE = 30 // MUST BE LAST ENTRY IN THIS ENUM
}

enum GRAVITY_OPERATOR_ADD_NAME = "+";
enum GRAVITY_OPERATOR_SUB_NAME = "-";
enum GRAVITY_OPERATOR_DIV_NAME = "/";
enum GRAVITY_OPERATOR_MUL_NAME = "*";
enum GRAVITY_OPERATOR_REM_NAME = "%";
enum GRAVITY_OPERATOR_AND_NAME = "&&";
enum GRAVITY_OPERATOR_OR_NAME = "||";
enum GRAVITY_OPERATOR_CMP_NAME = "==";
enum GRAVITY_OPERATOR_EQQ_NAME = "===";
enum GRAVITY_OPERATOR_NEQQ_NAME = "!==";
enum GRAVITY_OPERATOR_IS_NAME = "is";
enum GRAVITY_OPERATOR_MATCH_NAME = "=~";
enum GRAVITY_OPERATOR_NEG_NAME = "neg";
enum GRAVITY_OPERATOR_NOT_NAME = "!";
enum GRAVITY_OPERATOR_LSHIFT_NAME = "<<";
enum GRAVITY_OPERATOR_RSHIFT_NAME = ">>";
enum GRAVITY_OPERATOR_BAND_NAME = "&";
enum GRAVITY_OPERATOR_BOR_NAME = "|";
enum GRAVITY_OPERATOR_BXOR_NAME = "^";
enum GRAVITY_OPERATOR_BNOT_NAME = "~";
enum GRAVITY_INTERNAL_LOAD_NAME = "load";
enum GRAVITY_INTERNAL_LOADS_NAME = "loads";
enum GRAVITY_INTERNAL_STORE_NAME = "store";
enum GRAVITY_INTERNAL_LOADAT_NAME = "loadat";
enum GRAVITY_INTERNAL_STOREAT_NAME = "storeat";
enum GRAVITY_INTERNAL_NOTFOUND_NAME = "notfound";
enum GRAVITY_INTERNAL_EXEC_NAME = "exec";
enum GRAVITY_INTERNAL_LOOP_NAME = "loop";

enum GRAVITY_CLASS_INT_NAME = "Int";
enum GRAVITY_CLASS_FLOAT_NAME = "Float";
enum GRAVITY_CLASS_BOOL_NAME = "Bool";
enum GRAVITY_CLASS_STRING_NAME = "String";
enum GRAVITY_CLASS_OBJECT_NAME = "Object";
enum GRAVITY_CLASS_CLASS_NAME = "Class";
enum GRAVITY_CLASS_NULL_NAME = "Null";
enum GRAVITY_CLASS_FUNCTION_NAME = "Func";
enum GRAVITY_CLASS_FIBER_NAME = "Fiber";
enum GRAVITY_CLASS_INSTANCE_NAME = "Instance";
enum GRAVITY_CLASS_CLOSURE_NAME = "Closure";
enum GRAVITY_CLASS_LIST_NAME = "List";
enum GRAVITY_CLASS_MAP_NAME = "Map";
enum GRAVITY_CLASS_RANGE_NAME = "Range";
enum GRAVITY_CLASS_UPVALUE_NAME = "Upvalue";

enum GRAVITY_CLASS_SYSTEM_NAME = "System";
enum GRAVITY_SYSTEM_PRINT_NAME = "print";
enum GRAVITY_SYSTEM_PUT_NAME = "put";
enum GRAVITY_SYSTEM_INPUT_NAME = "input";
enum GRAVITY_SYSTEM_NANOTIME_NAME = "nanotime";

enum GRAVITY_TOCLASS_NAME = "toClass";
enum GRAVITY_TOSTRING_NAME = "toString";
enum GRAVITY_TOINT_NAME = "toInt";
enum GRAVITY_TOFLOAT_NAME = "toFloat";
enum GRAVITY_TOBOOL_NAME = "toBool";

