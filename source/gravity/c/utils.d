module gravity.c.utils;

//
//  gravity_utils.h
//  gravity
//
//  Created by Marco Bambini on 29/08/14.
//  Copyright (c) 2014 CreoLabs. All rights reserved.
//

import core.stdc.config;
import core.sys.posix.dirent;

extern (C):

alias nanotime_t = c_ulong;
alias DIRREF = DIR*;

// TIMER
nanotime_t nanotime ();
double microtime (nanotime_t tstart, nanotime_t tend);
double millitime (nanotime_t tstart, nanotime_t tend);

// FILE
char* file_buildpath (const(char)* filename, const(char)* dirpath);
bool file_delete (const(char)* path);
bool file_exists (const(char)* path);
char* file_name_frompath (const(char)* path);
char* file_read (const(char)* path, size_t* len);
long file_size (const(char)* path);
bool file_write (const(char)* path, const(char)* buffer, size_t len);

// DIRECTORY
bool directory_create (const(char)* path);
DIR* directory_init (const(char)* path);
// On Windows, you are expected to provied a win32buffer buffer of at least MAX_PATH in length
char* directory_read (DIR* ref_, char* win32buffer);
char* directory_read_extend (DIR* ref_, char* win32buffer);
bool is_directory (const(char)* path);

// STRING
int string_casencmp (const(char)* s1, const(char)* s2, size_t n);
int string_cmp (const(char)* s1, const(char)* s2);
char* string_dup (const(char)* s1);
char* string_ndup (const(char)* s1, size_t n);
int string_nocasencmp (const(char)* s1, const(char)* s2, size_t n);
uint string_size (const(char)* p);
char* string_strnstr (const(char)* s, const(char)* find, size_t slen);
char* string_replace (const(char)* str, const(char)* from, const(char)* to, size_t* rlen);
void string_reverse (char* p);

// UTF-8
uint utf8_charbytes (const(char)* s, uint i);
uint utf8_encode (char* buffer, uint value);
uint utf8_len (const(char)* s, uint nbytes);
uint utf8_nbytes (uint n);
bool utf8_reverse (char* p);

// MATH and NUMBERS
long number_from_bin (const(char)* s, uint len);
long number_from_hex (const(char)* s, uint len);
long number_from_oct (const(char)* s, uint len);
uint power_of2_ceil (uint n);

