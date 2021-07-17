module gravity.c.json;
import gravity.c.config;
import core.stdc.config;

extern (C):

// MARK: JSON serializer -

enum json_opt_mask
{
    json_opt_none = 0x00,
    json_opt_need_comma = 0x01,
    json_opt_prettify = 0x02,
    json_opt_no_maptype = 0x04,
    json_opt_no_undef = 0x08,
    json_opt_unused_1 = 0x10,
    json_opt_unused_2 = 0x20,
    json_opt_unused_3 = 0x40,
    json_opt_unused_4 = 0x80,
    json_opt_unused_5 = 0x100
}

struct json_t;
void json_free (json_t* json);
json_t* json_new ();

void json_add_bool (json_t* json, const(char)* key, bool value);
void json_add_cstring (json_t* json, const(char)* key, const(char)* value);
void json_add_double (json_t* json, const(char)* key, double value);
void json_add_int (json_t* json, const(char)* key, long value);
void json_add_null (json_t* json, const(char)* key);
void json_add_string (json_t* json, const(char)* key, const(char)* value, size_t len);

void json_begin_array (json_t* json, const(char)* key);
void json_begin_object (json_t* json, const(char)* key);

void json_end_array (json_t* json);
void json_end_object (json_t* json);

const(char)* json_get_label (json_t* json, const(char)* key);
void json_set_label (json_t* json, const(char)* key);

char* json_buffer (json_t* json, size_t* len);
bool json_write_file (json_t* json, const(char)* path);

void json_clear_option (json_t* json, json_opt_mask option_value);
uint json_get_options (json_t* json);
bool json_option_isset (json_t* json, json_opt_mask option_value);
void json_set_option (json_t* json, json_opt_mask option_value);

// MARK: - JSON Parser -
/* vim: set et ts=3 sw=3 sts=3 ft=c:
 *
 * Copyright (C) 2012, 2013, 2014 James McLaughlin et al.  All rights reserved.
 * https://github.com/udp/json-parser
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

alias json_char = char;

alias json_int_t = long;

struct json_settings
{
    c_ulong max_memory;
    int settings;

    /* Custom allocator support (leave null to use malloc/free)
     */

    void* function (size_t, int zero, void* user_data) memory_alloc;
    void function (void*, void* user_data) memory_free;

    void* user_data; /* will be passed to mem_alloc and mem_free */

    size_t value_extra; /* how much extra space to allocate for values? */
}

enum json_enable_comments = 0x01;

enum json_type
{
    json_none = 0,
    json_object = 1,
    json_array = 2,
    json_integer = 3,
    json_double = 4,
    json_string = 5,
    json_boolean = 6,
    json_null = 7
}

extern __gshared const _json_value json_value_none;

struct _json_object_entry
{
    char* name;
    uint name_length;

    _json_value* value;
}

alias json_object_entry = _json_object_entry;

struct _json_value
{
    _json_value* parent;

    json_type type;

    /* null terminated */
    union _Anonymous_0
    {
        int boolean;
        long integer;
        double dbl;

        struct _Anonymous_1
        {
            uint length;
            char* ptr;
        }

        _Anonymous_1 string;

        struct _Anonymous_2
        {
            uint length;
            json_object_entry* values;
        }

        _Anonymous_2 object;

        struct _Anonymous_3
        {
            uint length;
            _json_value** values;
        }

        _Anonymous_3 array;
    }

    _Anonymous_0 u;

    union _Anonymous_4
    {
        _json_value* next_alloc;
        void* object_mem;
    }

    _Anonymous_4 _reserved;

    /* Location of the value in the source JSON
     */

    /* Some C++ operator sugar */
}

alias json_value = _json_value;

json_value* json_parse (const(char)* json, size_t length);

enum json_error_max = 128;
json_value* json_parse_ex (
    json_settings* settings,
    const(char)* json,
    size_t length,
    char* error);

void json_value_free (json_value*);

/* Not usually necessary, unless you used a custom mem_alloc and now want to
 * use a custom mem_free.
 */
void json_value_free_ex (json_settings* settings, json_value*);

/* extern "C" */

