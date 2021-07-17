module gravity.c.array;

//
//  gravity_array.h
//  gravity
//
//  Created by Marco Bambini on 31/07/14.
//  Copyright (c) 2014 CreoLabs. All rights reserved.
//

extern (C):

// Inspired by https://github.com/attractivechaos/klib/blob/master/kvec.h

enum MARRAY_DEFAULT_SIZE = 8;

extern (D) auto marray_get(T0, T1)(auto ref T0 v, auto ref T1 i)
{
    return v.p[i];
}

extern (D) auto marray_pop(T)(auto ref T v)
{
    return v.p[--v.n];
}

extern (D) auto marray_last(T)(auto ref T v)
{
    return v.p[v.n - 1];
}

extern (D) auto marray_size(T)(auto ref T v)
{
    return v.n;
}

extern (D) auto marray_max(T)(auto ref T v)
{
    return v.m;
}

extern (D) auto marray_inc(T)(auto ref T v)
{
    return ++v.n;
}

extern (D) auto marray_dec(T)(auto ref T v)
{
    return --v.n;
}

extern (D) auto marray_reset0(T)(auto ref T v)
{
    return marray_reset(v, 0);
}

// commonly used arrays
struct uint16_r
{
    size_t n;
    size_t m;
    ushort* p;
}

struct uint32_r
{
    size_t n;
    size_t m;
    uint* p;
}

struct void_r
{
    size_t n;
    size_t m;
    void** p;
}

struct cstring_r
{
    size_t n;
    size_t m;
    const(char*)* p;
}
