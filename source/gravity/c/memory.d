module gravity.c.memory;

//
//  gravity_memory.h
//    gravity
//
//  Created by Marco Bambini on 20/03/16.
//  Copyright © 2016 Creolabs. All rights reserved.
//

import core.stdc.stdlib;

import gravity.c.vm;
extern (C):

// memory debugger must be turned on ONLY with Xcode GuardMalloc ON
enum GRAVITY_MEMORY_DEBUG = 0;

extern (D) auto mem_alloc(T0, T1)(auto ref T0 _vm, auto ref T1 _size)
{
    return gravity_calloc(_vm, 1, _size);
}

alias mem_calloc = gravity_calloc;
alias mem_realloc = gravity_realloc;

extern (D) auto mem_free(T)(auto ref T v)
{
    return free(cast(void*) v);
}

extern (D) int mem_status()
{
    return 0;
}

extern (D) int mem_leaks()
{
    return 0;
}

void* gravity_calloc (gravity_vm* vm, size_t count, size_t size);
void* gravity_realloc (gravity_vm* vm, void* ptr, size_t new_size);

