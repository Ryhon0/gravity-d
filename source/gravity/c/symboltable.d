module gravity.c.symboltable;

import gravity.c.ast;

//
//  gravity_symboltable.h
//  gravity
//
//  Created by Marco Bambini on 12/09/14.
//  Copyright (c) 2014 CreoLabs. All rights reserved.
//

extern (C):

enum symtable_tag
{
    SYMTABLE_TAG_GLOBAL = 0,
    SYMTABLE_TAG_FUNC = 1,
    SYMTABLE_TAG_CLASS = 2,
    SYMTABLE_TAG_MODULE = 3,
    SYMTABLE_TAG_ENUM = 4
}

uint symboltable_count (symboltable_t* table, uint index);
symboltable_t* symboltable_create (symtable_tag tag);
gnode_t* symboltable_global_lookup (symboltable_t* table, const(char)* identifier);
bool symboltable_insert (symboltable_t* table, const(char)* identifier, gnode_t* node);
gnode_t* symboltable_lookup (symboltable_t* table, const(char)* identifier);
ushort symboltable_setivar (symboltable_t* table, bool is_static);
symtable_tag symboltable_tag (symboltable_t* table);

void symboltable_dump (symboltable_t* table);
void symboltable_enter_scope (symboltable_t* table);
uint symboltable_exit_scope (symboltable_t* table, uint* nlevel);
void symboltable_free (symboltable_t* table);
uint symboltable_local_index (symboltable_t* table);

void* symboltable_hash_atindex (symboltable_t* table, size_t n);

