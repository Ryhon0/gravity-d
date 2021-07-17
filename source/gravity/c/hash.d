module gravity.c.hash;

import gravity.c.value;

//
//  gravity_hash.h
//  gravity
//
//  Created by Marco Bambini on 23/04/15.
//  Copyright (c) 2015 CreoLabs. All rights reserved.
//

extern (C):

enum GRAVITYHASH_ENABLE_STATS = 1; // if 0 then stats are not enabled
enum GRAVITYHASH_DEFAULT_SIZE = 32; // default hash table size (used if 0 is passed in gravity_hash_create)
enum GRAVITYHASH_THRESHOLD = 0.75; // threshold used to decide when re-hash the table
enum GRAVITYHASH_MAXENTRIES = 1073741824; // please don't put more than 1 billion values in my hash table (2^30)

// opaque hash table struct

// CALLBACK functions
alias gravity_hash_compare_fn = bool function (gravity_value_t value1, gravity_value_t value2, void* data);
alias gravity_hash_compute_fn = uint function (gravity_value_t key);
alias gravity_hash_isequal_fn = bool function (gravity_value_t v1, gravity_value_t v2);
alias gravity_hash_iterate_fn = void function (gravity_hash_t* hashtable, gravity_value_t key, gravity_value_t value, void* data);
alias gravity_hash_iterate2_fn = void function (gravity_hash_t* hashtable, gravity_value_t key, gravity_value_t value, void* data1, void* data2);
alias gravity_hash_iterate3_fn = void function (gravity_hash_t* hashtable, gravity_value_t key, gravity_value_t value, void* data1, void* data2, void* data3);
alias gravity_hash_transform_fn = void function (gravity_hash_t* hashtable, gravity_value_t key, gravity_value_t* value, void* data);

// PUBLIC functions
gravity_hash_t* gravity_hash_create (uint size, gravity_hash_compute_fn compute, gravity_hash_isequal_fn isequal, gravity_hash_iterate_fn free, void* data);
void gravity_hash_free (gravity_hash_t* hashtable);
bool gravity_hash_insert (gravity_hash_t* hashtable, gravity_value_t key, gravity_value_t value);
bool gravity_hash_isempty (gravity_hash_t* hashtable);
gravity_value_t* gravity_hash_lookup (gravity_hash_t* hashtable, gravity_value_t key);
gravity_value_t* gravity_hash_lookup_cstring (gravity_hash_t* hashtable, const(char)* key);
bool gravity_hash_remove (gravity_hash_t* hashtable, gravity_value_t key);

void gravity_hash_append (gravity_hash_t* hashtable1, gravity_hash_t* hashtable2);
uint gravity_hash_compute_buffer (const(char)* key, uint len);
uint gravity_hash_compute_float (gravity_float_t f);
uint gravity_hash_compute_int (gravity_int_t n);
uint gravity_hash_count (gravity_hash_t* hashtable);
void gravity_hash_dump (gravity_hash_t* hashtable);
void gravity_hash_iterate (gravity_hash_t* hashtable, gravity_hash_iterate_fn iterate, void* data);
void gravity_hash_iterate2 (gravity_hash_t* hashtable, gravity_hash_iterate2_fn iterate, void* data1, void* data2);
void gravity_hash_iterate3 (gravity_hash_t* hashtable, gravity_hash_iterate3_fn iterate, void* data1, void* data2, void* data3);
uint gravity_hash_memsize (gravity_hash_t* hashtable);
void gravity_hash_resetfree (gravity_hash_t* hashtable);
void gravity_hash_stat (gravity_hash_t* hashtable);
void gravity_hash_transform (gravity_hash_t* hashtable, gravity_hash_transform_fn iterate, void* data);

bool gravity_hash_compare (gravity_hash_t* hashtable1, gravity_hash_t* hashtable2, gravity_hash_compare_fn compare, void* data);

// MARK: - CALLBACKS -
// HASH FREE CALLBACK FUNCTION
void gravity_hash_interalfree (gravity_hash_t* table, gravity_value_t key, gravity_value_t value, void* data);
void gravity_hash_keyfree (gravity_hash_t* table, gravity_value_t key, gravity_value_t value, void* data);
void gravity_hash_keyvaluefree (gravity_hash_t* table, gravity_value_t key, gravity_value_t value, void* data);
void gravity_hash_valuefree (gravity_hash_t* table, gravity_value_t key, gravity_value_t value, void* data);

