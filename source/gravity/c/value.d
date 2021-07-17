module gravity.c.value;

//
//  gravity_value.h
//  gravity
//
//  Created by Marco Bambini on 11/12/14.
//  Copyright (c) 2014 CreoLabs. All rights reserved.
//

import core.stdc.config;
import core.stdc.float_;
import core.stdc.stdint;
import gravity.c.vm;
import gravity.c.utils;
import gravity.c.json;

extern (C):

// Gravity is a dynamically typed language so a variable (gravity_value_t) can hold a value of any type.

// The representation of values in a dynamically typed language is very important since it can lead to a big
// difference in terms of performance. Such representation has several constraints:
// - fast access
// - must represent several kind of values
// - be able to cope with the garbage collector
// - low memory overhead (when allocating a lot of small values)

// In modern 64bit processor with OS that always returns aligned allocated memory blocks that means that each ptr is 8 bytes.
// That means that passing a value as an argument or storing it involves copying these bytes around (requiring 2/4 machine words).
// Values are not pointers but structures.

// The built-in types for booleans, numbers, floats, null, undefs are unboxed: their value is stored directly into gravity_value_t.
// Other types like classes, instances, functions, lists, and strings are all reference types. They are stored on the heap and
// the gravity_value_t just stores a pointer to it.

// So each value is a pointer to a FIXED size block of memory (16 bytes). Having all values of the same size greatly reduce the complexity
// of a memory pool and since allocating a large amount of values is very common is a dynamically typed language like Gravity.
// In a future update I could introduce NaN tagging and squeeze value size to 8 bytes (that would mean nearly double performance).

// Internal settings to set integer and float size.
// Default is to have both int and float as 64bit.

// In a 64bit OS:
// sizeof(float)        => 4 bytes
// sizeof(double)       => 8 bytes
// sizeof(void*)        => 8 bytes
// sizeof(int64_t)      => 8 bytes
//
// sizeof various structs in a 64bit OS:
// STRUCT                       BYTES
// ======                       =====
// gravity_function_t           104
// gravity_value_t              16
// gravity_upvalue_t            56
// gravity_closure_t            40
// gravity_list_t               48
// gravity_map_t                32
// gravity_callframe_t          48
// gravity_fiber_t              112
// gravity_class_t              88
// gravity_module_t             40
// gravity_instance_t           40
// gravity_string_t             48
// gravity_range_t              40

enum GRAVITY_VERSION = "0.8.3"; // git tag 0.8.3
enum GRAVITY_VERSION_NUMBER = 0x000803; // git push --tags
enum GRAVITY_BUILD_DATE = __DATE__;

enum GRAVITY_ENABLE_DOUBLE = 1; // if 1 enable gravity_float_t to be a double (instead of a float)

enum GRAVITY_ENABLE_INT64 = 1; // if 1 enable gravity_int_t to be a 64bit int (instead of a 32bit int)

enum GRAVITY_COMPUTED_GOTO = 1; // if 1 enable faster computed goto (instead of switch) for compilers that support it

enum GRAVITY_NULL_SILENT = 1; // if 1 then messages sent to null does not produce any runtime error

enum GRAVITY_MAP_DOTSUGAR = 1; // if 1 then map objects can be accessed with both map[key] and map.key

// MSVC does not support computed goto (supported if using clang on Windows)

enum MAIN_FUNCTION = "main";
enum ITERATOR_INIT_FUNCTION = "iterate";
enum ITERATOR_NEXT_FUNCTION = "next";
enum INITMODULE_NAME = "$moduleinit";
enum CLASS_INTERNAL_INIT_NAME = "$init";
enum CLASS_CONSTRUCTOR_NAME = "init";
enum CLASS_DESTRUCTOR_NAME = "deinit";
enum SELF_PARAMETER_NAME = "self";
enum OUTER_IVAR_NAME = "outer";
enum GETTER_FUNCTION_NAME = "get";
enum SETTER_FUNCTION_NAME = "set";
enum SETTER_PARAMETER_NAME = "value";

enum GLOBALS_DEFAULT_SLOT = 4096;
enum CPOOL_INDEX_MAX = 4096; // 2^12
enum CPOOL_VALUE_SUPER = CPOOL_INDEX_MAX + 1;
enum CPOOL_VALUE_NULL = CPOOL_INDEX_MAX + 2;
enum CPOOL_VALUE_UNDEFINED = CPOOL_INDEX_MAX + 3;
enum CPOOL_VALUE_ARGUMENTS = CPOOL_INDEX_MAX + 4;
enum CPOOL_VALUE_TRUE = CPOOL_INDEX_MAX + 5;
enum CPOOL_VALUE_FALSE = CPOOL_INDEX_MAX + 6;
enum CPOOL_VALUE_FUNC = CPOOL_INDEX_MAX + 7;

enum MAX_INSTRUCTION_OPCODE = 64; // 2^6
enum MAX_REGISTERS = 256; // 2^8
enum MAX_LOCALS = 200; // maximum number of local variables
enum MAX_UPVALUES = 200; // maximum number of upvalues
enum MAX_INLINE_INT = 131072; // 32 - 6 (OPCODE) - 8 (register) - 1 bit sign = 17
enum MAX_FIELDSxFLUSH = 64; // used in list/map serialization
enum MAX_IVARS = 768; // 2^10 - 2^8
enum MAX_ALLOCATION = 4194304; // 1024 * 1024 * 4 (about 4 millions entry)
enum MAX_CCALLS = 100; // default maximum number of nested C calls
enum MAX_MEMORY_BLOCK = 157286400; // 150MB

enum DEFAULT_CONTEXT_SIZE = 256; // default VM context entries (can grow)
enum DEFAULT_MINSTRING_SIZE = 32; // minimum string allocation size
enum DEFAULT_MINSTACK_SIZE = 256; // sizeof(gravity_value_t) * 256     = 16 * 256 => 4 KB
enum DEFAULT_MINCFRAME_SIZE = 32; // sizeof(gravity_callframe_t) * 48  = 32 * 48 => 1.5 KB
enum DEFAULT_CG_THRESHOLD = 5 * 1024 * 1024; // 5MB
enum DEFAULT_CG_MINTHRESHOLD = 1024 * 1024; // 1MB
enum DEFAULT_CG_RATIO = 0.5; // 50%

extern (D) auto MAXNUM(T0, T1)(auto ref T0 a, auto ref T1 b)
{
    return a > b ? a : b;
}

extern (D) auto MINNUM(T0, T1)(auto ref T0 a, auto ref T1 b)
{
    return a < b ? a : b;
}

enum EPSILON = 0.000001;
enum MIN_LIST_RESIZE = 12; // value used when a List is resized

enum GRAVITY_DATA_REGISTER = UINT32_MAX;
enum GRAVITY_FIBER_REGISTER = UINT32_MAX - 1;
enum GRAVITY_MSG_REGISTER = UINT32_MAX - 2;

enum GRAVITY_BRIDGE_INDEX = UINT16_MAX;
enum GRAVITY_COMPUTED_INDEX = UINT16_MAX - 1;

//DLL export/import support for Windows

// MARK: - STRUCT -

// FLOAT_MAX_DECIMALS FROM https://stackoverflow.com/questions/13542944/how-many-significant-digits-have-floats-and-doubles-in-java
alias gravity_float_t = double;
enum GRAVITY_FLOAT_MAX = DBL_MAX;
enum GRAVITY_FLOAT_MIN = DBL_MIN;
enum FLOAT_MAX_DECIMALS = 16;
enum FLOAT_EPSILON = 0.00001;

alias gravity_int_t = c_long;
enum GRAVITY_INT_MAX = 9223372036854775807;
enum GRAVITY_INT_MIN = -9223372036854775807;

// Forward references (an object ptr is just its isa pointer)
alias gravity_class_t = gravity_class_s_;
alias gravity_object_t = gravity_class_s_;

// Everything inside Gravity VM is a gravity_value_t struct
struct gravity_value_t
{
    gravity_class_t* isa; // EVERY object must have an ISA pointer (8 bytes on a 64bit system)
    union
    {
        // union takes 8 bytes on a 64bit system
        gravity_int_t n; // integer slot
        gravity_float_t f; // float/double slot
        gravity_object_t* p; // ptr to object slot
    }
}

// All VM shares the same foundation classes
extern __gshared gravity_class_t* gravity_class_object;
extern __gshared gravity_class_t* gravity_class_bool;
extern __gshared gravity_class_t* gravity_class_null;
extern __gshared gravity_class_t* gravity_class_int;
extern __gshared gravity_class_t* gravity_class_float;
extern __gshared gravity_class_t* gravity_class_function;
extern __gshared gravity_class_t* gravity_class_closure;
extern __gshared gravity_class_t* gravity_class_fiber;
extern __gshared gravity_class_t* gravity_class_class;
extern __gshared gravity_class_t* gravity_class_string;
extern __gshared gravity_class_t* gravity_class_instance;
extern __gshared gravity_class_t* gravity_class_list;
extern __gshared gravity_class_t* gravity_class_map;
extern __gshared gravity_class_t* gravity_class_module;
extern __gshared gravity_class_t* gravity_class_range;
extern __gshared gravity_class_t* gravity_class_upvalue;

struct gravity_value_r
{
    size_t n;
    size_t m;
    gravity_value_t* p;
} // array of values

struct gravity_hash_t; // forward declaration

// vm is an opaque data type

alias gravity_c_internal = bool function (gravity_vm* vm, gravity_value_t* args, ushort nargs, uint rindex);
alias gravity_gc_callback = uint function (gravity_vm* vm, gravity_object_t* obj);

enum gravity_special_index
{
    EXEC_TYPE_SPECIAL_GETTER = 0, // index inside special gravity_function_t union to represent getter func
    EXEC_TYPE_SPECIAL_SETTER = 1 // index inside special gravity_function_t union to represent setter func
}

enum gravity_exec_type
{
    EXEC_TYPE_NATIVE = 0, // native gravity code (can change stack)
    EXEC_TYPE_INTERNAL = 1, // c internal code (can change stack)
    EXEC_TYPE_BRIDGED = 2, // external code to be executed by delegate (can change stack)
    EXEC_TYPE_SPECIAL = 3 // special execution like getter and setter (can be NATIVE, INTERNAL)
}

struct gravity_gc_s
{
    bool isdark; // flag to check if object is reachable
    bool visited; // flag to check if object has already been counted in memory size
    gravity_gc_callback free; // free callback
    gravity_gc_callback size; // size callback
    gravity_gc_callback blacken; // blacken callback
    gravity_object_t* next; // to track next object in the linked list
}

alias gravity_gc_t = gravity_gc_s;

struct gravity_function_t
{
    gravity_class_t* isa; // to be an object
    gravity_gc_t gc; // to be collectable by the garbage collector

    void* xdata; // extra bridged data
    const(char)* identifier; // function name
    ushort nparams; // number of formal parameters
    ushort nlocals; // number of local variables
    ushort ntemps; // number of temporary values used
    ushort nupvalues; // number of up values (if any)
    gravity_exec_type tag; // can be EXEC_TYPE_NATIVE (default), EXEC_TYPE_INTERNAL, EXEC_TYPE_BRIDGED or EXEC_TYPE_SPECIAL
    union
    {
        // tag == EXEC_TYPE_NATIVE
        struct
        {
            gravity_value_r cpool; // constant pool
            gravity_value_r pvalue; // default param value
            gravity_value_r pname; // param names
            uint ninsts; // number of instructions in the bytecode
            uint* bytecode; // bytecode as array of 32bit values
            uint* lineno; // debug: line number <-> current instruction relation
            float purity; // experimental value
            bool useargs; // flag set by the compiler to optimize the creation of the arguments array only if needed
        }

        // tag == EXEC_TYPE_INTERNAL
        gravity_c_internal internal; // function callback

        // tag == EXEC_TYPE_SPECIAL
        struct
        {
            ushort index; // property index to speed-up default getter and setter
            void*[2] special; // getter/setter functions
        }
    }
}

struct upvalue_s
{
    gravity_class_t* isa; // to be an object
    gravity_gc_t gc; // to be collectable by the garbage collector

    gravity_value_t* value; // ptr to open value on the stack or to closed value on this struct
    gravity_value_t closed; // copy of the value once has been closed
    upvalue_s* next; // ptr to the next open upvalue
}

alias gravity_upvalue_t = upvalue_s;

struct gravity_closure_s
{
    gravity_class_t* isa; // to be an object
    gravity_gc_t gc; // to be collectable by the garbage collector

    gravity_vm* vm; // vm bound to this closure (useful when executed from a bridge)
    gravity_function_t* f; // function prototype
    gravity_object_t* context; // context where the closure has been created (or object bound by the user)
    gravity_upvalue_t** upvalue; // upvalue array
    uint refcount; // bridge language sometimes needs to protect closures from GC
}

alias gravity_closure_t = gravity_closure_s;

struct gravity_list_t
{
    gravity_class_t* isa; // to be an object
    gravity_gc_t gc; // to be collectable by the garbage collector

    gravity_value_r array; // dynamic array of values
}

struct gravity_map_t
{
    gravity_class_t* isa; // to be an object
    gravity_gc_t gc; // to be collectable by the garbage collector

    gravity_hash_t* hash; // hash table
}

// Call frame used for function call
struct gravity_callframe_t
{
    uint* ip; // instruction pointer
    uint dest; // destination register that will receive result
    ushort nargs; // number of effective arguments passed to the function
    gravity_list_t* args; // implicit special _args array
    gravity_closure_t* closure; // closure being executed
    gravity_value_t* stackstart; // first stack slot used by this call frame (receiver, plus parameters, locals and temporaries)
    bool outloop; // special case for events or native code executed from C that must be executed separately
}

enum gravity_fiber_status
{
    FIBER_NEVER_EXECUTED = 0,
    FIBER_ABORTED_WITH_ERROR = 1,
    FIBER_TERMINATED = 2,
    FIBER_RUNNING = 3,
    FIBER_TRYING = 4
}

// Fiber is the core executable model
struct fiber_s
{
    gravity_class_t* isa; // to be an object
    gravity_gc_t gc; // to be collectable by the garbage collector

    gravity_value_t* stack; // stack buffer (grown as needed and it holds locals and temps)
    gravity_value_t* stacktop; // current stack ptr
    uint stackalloc; // number of allocated values

    gravity_callframe_t* frames; // callframes buffer (grown as needed but never shrinks)
    uint nframes; // number of frames currently in use
    uint framesalloc; // number of allocated frames

    gravity_upvalue_t* upvalues; // linked list used to keep track of open upvalues

    char* error; // runtime error message
    bool trying; // set when the try flag is set by the user
    fiber_s* caller; // optional caller fiber
    gravity_value_t result; // end result of the fiber

    gravity_fiber_status status; // Fiber status (see enum)
    nanotime_t lasttime; // last time Fiber has been called
    gravity_float_t timewait; // used in yieldTime
    gravity_float_t elapsedtime; // time passed since last execution
}

alias gravity_fiber_t = fiber_s;

struct gravity_class_s_
{
    gravity_class_t* isa; // to be an object
    gravity_gc_t gc; // to be collectable by the garbage collector

    gravity_class_t* objclass; // meta class
    const(char)* identifier; // class name
    bool has_outer; // flag used to automatically set ivar 0 to outer class (if any)
    bool is_struct; // flag to mark class as a struct
    bool is_inited; // flag used to mark already init meta-classes (to be improved)
    bool unused; // unused padding byte
    void* xdata; // extra bridged data
    gravity_class_s_* superclass; // reference to the super class
    const(char)* superlook; // when a superclass is set to extern a runtime lookup must be performed
    gravity_hash_t* htable; // hash table
    uint nivars; // number of instance variables
    //gravity_value_r			inames;			    // ivar names
    gravity_value_t* ivars; // static variables
}

alias gravity_class_s = gravity_class_s_;

struct gravity_module_t
{
    gravity_class_t* isa; // to be an object
    gravity_gc_t gc; // to be collectable by the garbage collector

    const(char)* identifier; // module name
    gravity_hash_t* htable; // hash table
}

struct gravity_instance_t
{
    gravity_class_t* isa; // to be an object
    gravity_gc_t gc; // to be collectable by the garbage collector

    gravity_class_t* objclass; // real instance class
    void* xdata; // extra bridged data
    gravity_value_t* ivars; // instance variables
}

struct gravity_string_t
{
    gravity_class_t* isa; // to be an object
    gravity_gc_t gc; // to be collectable by the garbage collector

    char* s; // pointer to NULL terminated string
    uint hash; // string hash (type to be keept in sync with gravity_hash_size_t)
    uint len; // actual string length
    uint alloc; // bytes allocated for string
}

struct gravity_range_t
{
    gravity_class_t* isa; // to be an object
    gravity_gc_t gc; // to be collectable by the garbage collector

    gravity_int_t from; // range start
    gravity_int_t to; // range end
}

alias code_dump_function = void function (void* code);

struct gravity_function_r
{
    size_t n;
    size_t m;
    gravity_function_t** p;
} // array of functions
struct gravity_class_r
{
    size_t n;
    size_t m;
    gravity_class_t** p;
} // array of classes
struct gravity_object_r
{
    size_t n;
    size_t m;
    gravity_object_t** p;
} // array of objects

// MARK: - MODULE -
gravity_module_t* gravity_module_new (gravity_vm* vm, const(char)* identifier);
void gravity_module_free (gravity_vm* vm, gravity_module_t* m);
void gravity_module_blacken (gravity_vm* vm, gravity_module_t* m);
uint gravity_module_size (gravity_vm* vm, gravity_module_t* m);

// MARK: - FUNCTION -
uint* gravity_bytecode_deserialize (const(char)* buffer, size_t len, uint* ninst);
void gravity_function_blacken (gravity_vm* vm, gravity_function_t* f);
ushort gravity_function_cpool_add (gravity_vm* vm, gravity_function_t* f, gravity_value_t v);
gravity_value_t gravity_function_cpool_get (gravity_function_t* f, ushort i);
gravity_function_t* gravity_function_deserialize (gravity_vm* vm, json_value* json);
void gravity_function_dump (gravity_function_t* f, code_dump_function codef);
void gravity_function_free (gravity_vm* vm, gravity_function_t* f);
gravity_function_t* gravity_function_new (gravity_vm* vm, const(char)* identifier, ushort nparams, ushort nlocals, ushort ntemps, void* code);
gravity_function_t* gravity_function_new_bridged (gravity_vm* vm, const(char)* identifier, void* xdata);
gravity_function_t* gravity_function_new_internal (gravity_vm* vm, const(char)* identifier, gravity_c_internal exec, ushort nparams);
gravity_function_t* gravity_function_new_special (gravity_vm* vm, const(char)* identifier, ushort index, void* getter, void* setter);
gravity_list_t* gravity_function_params_get (gravity_vm* vm, gravity_function_t* f);
void gravity_function_serialize (gravity_function_t* f, json_t* json);
void gravity_function_setouter (gravity_function_t* f, gravity_object_t* outer);
void gravity_function_setxdata (gravity_function_t* f, void* xdata);
uint gravity_function_size (gravity_vm* vm, gravity_function_t* f);

// MARK: - CLOSURE -
void gravity_closure_blacken (gravity_vm* vm, gravity_closure_t* closure);
void gravity_closure_dec_refcount (gravity_vm* vm, gravity_closure_t* closure);
void gravity_closure_inc_refcount (gravity_vm* vm, gravity_closure_t* closure);
void gravity_closure_free (gravity_vm* vm, gravity_closure_t* closure);
uint gravity_closure_size (gravity_vm* vm, gravity_closure_t* closure);
gravity_closure_t* gravity_closure_new (gravity_vm* vm, gravity_function_t* f);

// MARK: - UPVALUE -
void gravity_upvalue_blacken (gravity_vm* vm, gravity_upvalue_t* upvalue);
void gravity_upvalue_free (gravity_vm* vm, gravity_upvalue_t* upvalue);
gravity_upvalue_t* gravity_upvalue_new (gravity_vm* vm, gravity_value_t* value);
uint gravity_upvalue_size (gravity_vm* vm, gravity_upvalue_t* upvalue);

// MARK: - CLASS -
void gravity_class_blacken (gravity_vm* vm, gravity_class_t* c);
short gravity_class_add_ivar (gravity_class_t* c, const(char)* identifier);
void gravity_class_bind (gravity_class_t* c, const(char)* key, gravity_value_t value);
uint gravity_class_count_ivars (gravity_class_t* c);
gravity_class_t* gravity_class_deserialize (gravity_vm* vm, json_value* json);
void gravity_class_dump (gravity_class_t* c);
void gravity_class_free (gravity_vm* vm, gravity_class_t* c);
void gravity_class_free_core (gravity_vm* vm, gravity_class_t* c);
gravity_class_t* gravity_class_get_meta (gravity_class_t* c);
gravity_class_t* gravity_class_getsuper (gravity_class_t* c);
bool gravity_class_grow (gravity_class_t* c, uint n);
bool gravity_class_is_anon (gravity_class_t* c);
bool gravity_class_is_meta (gravity_class_t* c);
gravity_object_t* gravity_class_lookup (gravity_class_t* c, gravity_value_t key);
gravity_closure_t* gravity_class_lookup_closure (gravity_class_t* c, gravity_value_t key);
gravity_closure_t* gravity_class_lookup_constructor (gravity_class_t* c, uint nparams);
gravity_class_t* gravity_class_lookup_class_identifier (gravity_class_t* c, const(char)* identifier);
gravity_class_t* gravity_class_new_pair (gravity_vm* vm, const(char)* identifier, gravity_class_t* superclass, uint nivar, uint nsvar);
gravity_class_t* gravity_class_new_single (gravity_vm* vm, const(char)* identifier, uint nfields);
void gravity_class_serialize (gravity_class_t* c, json_t* json);
bool gravity_class_setsuper (gravity_class_t* subclass, gravity_class_t* superclass);
bool gravity_class_setsuper_extern (gravity_class_t* baseclass, const(char)* identifier);
void gravity_class_setxdata (gravity_class_t* c, void* xdata);
uint gravity_class_size (gravity_vm* vm, gravity_class_t* c);

// MARK: - FIBER -
void gravity_fiber_blacken (gravity_vm* vm, gravity_fiber_t* fiber);
void gravity_fiber_free (gravity_vm* vm, gravity_fiber_t* fiber);
gravity_fiber_t* gravity_fiber_new (gravity_vm* vm, gravity_closure_t* closure, uint nstack, uint nframes);
void gravity_fiber_reassign (gravity_fiber_t* fiber, gravity_closure_t* closure, ushort nargs);
void gravity_fiber_reset (gravity_fiber_t* fiber);
void gravity_fiber_seterror (gravity_fiber_t* fiber, const(char)* error);
uint gravity_fiber_size (gravity_vm* vm, gravity_fiber_t* fiber);

// MARK: - INSTANCE -
void gravity_instance_blacken (gravity_vm* vm, gravity_instance_t* i);
gravity_instance_t* gravity_instance_clone (gravity_vm* vm, gravity_instance_t* src_instance);
void gravity_instance_deinit (gravity_vm* vm, gravity_instance_t* i);
void gravity_instance_free (gravity_vm* vm, gravity_instance_t* i);
bool gravity_instance_isstruct (gravity_instance_t* i);
gravity_closure_t* gravity_instance_lookup_event (gravity_instance_t* i, const(char)* name);
gravity_value_t gravity_instance_lookup_property (gravity_vm* vm, gravity_instance_t* i, gravity_value_t key);
gravity_instance_t* gravity_instance_new (gravity_vm* vm, gravity_class_t* c);
void gravity_instance_serialize (gravity_instance_t* i, json_t* json);
void gravity_instance_setivar (gravity_instance_t* instance, uint idx, gravity_value_t value);
void gravity_instance_setxdata (gravity_instance_t* i, void* xdata);
uint gravity_instance_size (gravity_vm* vm, gravity_instance_t* i);

// MARK: - VALUE -
void gravity_value_blacken (gravity_vm* vm, gravity_value_t v);
void gravity_value_dump (gravity_vm* vm, gravity_value_t v, char* buffer, ushort len);
bool gravity_value_equals (gravity_value_t v1, gravity_value_t v2);
void gravity_value_free (gravity_vm* vm, gravity_value_t v);
gravity_class_t* gravity_value_getclass (gravity_value_t v);
gravity_class_t* gravity_value_getsuper (gravity_value_t v);
uint gravity_value_hash (gravity_value_t value);
bool gravity_value_isobject (gravity_value_t v);
const(char)* gravity_value_name (gravity_value_t value);
void gravity_value_serialize (const(char)* key, gravity_value_t v, json_t* json);
uint gravity_value_size (gravity_vm* vm, gravity_value_t v);
bool gravity_value_vm_equals (gravity_vm* vm, gravity_value_t v1, gravity_value_t v2);
void* gravity_value_xdata (gravity_value_t value);

gravity_value_t gravity_value_from_bool (bool b);
gravity_value_t gravity_value_from_error (const(char)* msg);
gravity_value_t gravity_value_from_float (gravity_float_t f);
gravity_value_t gravity_value_from_int (gravity_int_t n);
gravity_value_t gravity_value_from_null ();
gravity_value_t gravity_value_from_object (void* obj);
gravity_value_t gravity_value_from_undefined ();

// MARK: - OBJECT -
void gravity_object_blacken (gravity_vm* vm, gravity_object_t* obj);
const(char)* gravity_object_debug (gravity_object_t* obj, bool is_free);
gravity_object_t* gravity_object_deserialize (gravity_vm* vm, json_value* entry);
void gravity_object_free (gravity_vm* vm, gravity_object_t* obj);
void gravity_object_serialize (gravity_object_t* obj, json_t* json);
uint gravity_object_size (gravity_vm* vm, gravity_object_t* obj);

// MARK: - LIST -
void gravity_list_append_list (gravity_vm* vm, gravity_list_t* list1, gravity_list_t* list2);
void gravity_list_blacken (gravity_vm* vm, gravity_list_t* list);
void gravity_list_free (gravity_vm* vm, gravity_list_t* list);
gravity_list_t* gravity_list_from_array (gravity_vm* vm, uint n, gravity_value_t* p);
gravity_list_t* gravity_list_new (gravity_vm* vm, uint n);
uint gravity_list_size (gravity_vm* vm, gravity_list_t* list);

// MARK: - MAP -
void gravity_map_blacken (gravity_vm* vm, gravity_map_t* map);
void gravity_map_append_map (gravity_vm* vm, gravity_map_t* map1, gravity_map_t* map2);
void gravity_map_free (gravity_vm* vm, gravity_map_t* map);
void gravity_map_insert (gravity_vm* vm, gravity_map_t* map, gravity_value_t key, gravity_value_t value);
gravity_map_t* gravity_map_new (gravity_vm* vm, uint n);
uint gravity_map_size (gravity_vm* vm, gravity_map_t* map);

// MARK: - RANGE -
void gravity_range_blacken (gravity_vm* vm, gravity_range_t* range);
gravity_range_t* gravity_range_deserialize (gravity_vm* vm, json_value* json);
void gravity_range_free (gravity_vm* vm, gravity_range_t* range);
gravity_range_t* gravity_range_new (gravity_vm* vm, gravity_int_t from, gravity_int_t to, bool inclusive);
void gravity_range_serialize (gravity_range_t* r, json_t* json);
uint gravity_range_size (gravity_vm* vm, gravity_range_t* range);

/// MARK: - STRING -
void gravity_string_blacken (gravity_vm* vm, gravity_string_t* string);
void gravity_string_free (gravity_vm* vm, gravity_string_t* value);
gravity_string_t* gravity_string_new (gravity_vm* vm, char* s, uint len, uint alloc);
void gravity_string_set (gravity_string_t* obj, char* s, uint len);
uint gravity_string_size (gravity_vm* vm, gravity_string_t* string);
gravity_value_t gravity_string_to_value (gravity_vm* vm, const(char)* s, uint len);

