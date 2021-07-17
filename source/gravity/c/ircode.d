module gravity.c.ircode;

//
//  gravity_ircode.h
//  gravity
//
//  Created by Marco Bambini on 06/11/14.
//  Copyright (c) 2014 CreoLabs. All rights reserved.
//

import core.stdc.stdint;
import gravity.c.opcodes;
import gravity.c.array;

extern (C):

// References:
// https://www.usenix.org/legacy/events/vee05/full_papers/p153-yunhe.pdf
// http://www.lua.org/doc/jucs05.pdf
//
// In a stack-based VM, a local variable is accessed using an index, and the operand stack is accessed via the stack pointer.
// In a register-based VM both the local variables and operand stack can be considered as virtual registers for the method.
// There is a simple mapping from stack locations to register numbers, because the height and contents of the VM operand stack
// are known at any point in a program.
//
// All values on the operand stack can be considered as temporary variables (registers) for a method and therefore are short-lived.
// Their scope of life is between the instructions that push them onto the operand stack and the instruction that consumes
// the value on the operand stack. On the other hand, local variables (also registers) are long-lived and their life scope is
// the time of method execution.

enum REGISTER_ERROR = UINT32_MAX;

enum optag_t
{
    NO_TAG = 0,
    INT_TAG = 1,
    DOUBLE_TAG = 2,
    LABEL_TAG = 3,
    SKIP_TAG = 4,
    RANGE_INCLUDE_TAG = 5,
    RANGE_EXCLUDE_TAG = 6,
    PRAGMA_MOVE_OPTIMIZATION = 7
}

struct inst_t
{
    opcode_t op;
    optag_t tag;
    int p1;
    int p2;
    int p3;

    union
    {
        double d; //    tag is DOUBLE_TAG
        long n; //    tag is INT_TAG
    }

    uint lineno; //  debug info
}

struct ircode_t;

uint ircode_count (ircode_t* code);
ircode_t* ircode_create (ushort nlocals);
void ircode_dump (void* code);
void ircode_free (ircode_t* code);
inst_t* ircode_get (ircode_t* code, uint index);
bool ircode_iserror (ircode_t* code);
uint ircode_ntemps (ircode_t* code);
void ircode_patch_init (ircode_t* code, ushort index);
void ircode_pop_context (ircode_t* code);
void ircode_push_context (ircode_t* code);

uint ircode_getlabel_check (ircode_t* code);
uint ircode_getlabel_false (ircode_t* code);
uint ircode_getlabel_true (ircode_t* code);
void ircode_marklabel (ircode_t* code, uint nlabel, uint lineno);
uint ircode_newlabel (ircode_t* code);
void ircode_setlabel_check (ircode_t* code, uint nlabel);
void ircode_setlabel_false (ircode_t* code, uint nlabel);
void ircode_setlabel_true (ircode_t* code, uint nlabel);
void ircode_unsetlabel_check (ircode_t* code);
void ircode_unsetlabel_false (ircode_t* code);
void ircode_unsetlabel_true (ircode_t* code);

void inst_setskip (inst_t* inst);
ubyte opcode_numop (opcode_t op);

void ircode_add (ircode_t* code, opcode_t op, uint p1, uint p2, uint p3, uint lineno);
void ircode_add_array (ircode_t* code, opcode_t op, uint p1, uint p2, uint p3, uint32_r r, uint lineno);
void ircode_add_check (ircode_t* code);
void ircode_add_constant (ircode_t* code, uint index, uint lineno);
void ircode_add_double (ircode_t* code, double d, uint lineno);
void ircode_add_int (ircode_t* code, long n, uint lineno);
void ircode_add_skip (ircode_t* code, uint lineno);
void ircode_add_tag (ircode_t* code, opcode_t op, uint p1, uint p2, uint p3, optag_t tag, uint lineno);
void ircode_pragma (ircode_t* code, optag_t tag, uint value, uint lineno);
void ircode_set_index (uint index, ircode_t* code, opcode_t op, uint p1, uint p2, uint p3);

// IMPORTANT NOTE
//
// The following functions can return REGISTER_ERROR and so an error check is mandatory
// ircode_register_pop
// ircode_register_pop_context_protect
// ircode_register_last
//
// The following functions can return 0 if no temp registers are available
// ircode_register_push_temp
//

bool ircode_register_istemp (ircode_t* code, uint n);
uint ircode_register_push_temp (ircode_t* code);
uint ircode_register_push_temp_protected (ircode_t* code);
uint ircode_register_push (ircode_t* code, uint nreg);
uint ircode_register_pop (ircode_t* code);
uint ircode_register_first_temp_available (ircode_t* code);
uint ircode_register_pop_context_protect (ircode_t* code, bool protect);
bool ircode_register_protect_outside_context (ircode_t* code, uint nreg);
void ircode_register_protect_in_context (ircode_t* code, uint nreg);
uint ircode_register_last (ircode_t* code);
uint ircode_register_count (ircode_t* code);
void ircode_register_clear (ircode_t* code, uint nreg);
void ircode_register_set (ircode_t* code, uint nreg);
void ircode_register_dump (ircode_t* code);

void ircode_register_temp_protect (ircode_t* code, uint nreg);
void ircode_register_temp_unprotect (ircode_t* code, uint nreg);
void ircode_register_temps_clear (ircode_t* code);

