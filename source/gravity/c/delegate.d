module gravity.c.delegate_;

import gravity.c.vm;
import gravity.c.value;

//
//  gravity_delegate.h
//  gravity
//
//  Created by Marco Bambini on 09/12/14.
//  Copyright (c) 2014 CreoLabs. All rights reserved.
//

extern (C):

// error type and code definitions
enum error_type_t
{
    GRAVITY_ERROR_NONE = 0,
    GRAVITY_ERROR_SYNTAX = 1,
    GRAVITY_ERROR_SEMANTIC = 2,
    GRAVITY_ERROR_RUNTIME = 3,
    GRAVITY_ERROR_IO = 4,
    GRAVITY_WARNING = 5
}

struct error_desc_t
{
    uint lineno;
    uint colno;
    uint fileid;
    uint offset;
}

alias gravity_error_callback = void function (gravity_vm* vm, error_type_t error_type, const(char)* description, error_desc_t error_desc, void* xdata);
alias gravity_log_callback = void function (gravity_vm* vm, const(char)* message, void* xdata);
alias gravity_log_clear = void function (gravity_vm* vm, void* xdata);
alias gravity_unittest_callback = void function (gravity_vm* vm, error_type_t error_type, const(char)* desc, const(char)* note, gravity_value_t value, int row, int col, void* xdata);
alias gravity_filename_callback = const(char)* function (uint fileid, void* xdata);
alias gravity_loadfile_callback = const(char)* function (const(char)* file, size_t* size, uint* fileid, void* xdata, bool* is_static);
alias gravity_optclass_callback = const(char*)* function (void* xdata);
alias gravity_parser_callback = void function (void* token, void* xdata);
alias gravity_precode_callback = const(char)* function (void* xdata);
alias gravity_type_callback = void function (void* token, const(char)* type, void* xdata);

alias gravity_bridge_blacken = void function (gravity_vm* vm, void* xdata);
alias gravity_bridge_clone = void* function (gravity_vm* vm, void* xdata);
alias gravity_bridge_equals = bool function (gravity_vm* vm, void* obj1, void* obj2);
alias gravity_bridge_execute = bool function (gravity_vm* vm, void* xdata, gravity_value_t ctx, gravity_value_t[] args, short nargs, uint vindex);
alias gravity_bridge_free = void function (gravity_vm* vm, gravity_object_t* obj);
alias gravity_bridge_getundef = bool function (gravity_vm* vm, void* xdata, gravity_value_t target, const(char)* key, uint vindex);
alias gravity_bridge_getvalue = bool function (gravity_vm* vm, void* xdata, gravity_value_t target, const(char)* key, uint vindex);
alias gravity_bridge_initinstance = bool function (gravity_vm* vm, void* xdata, gravity_value_t ctx, gravity_instance_t* instance, gravity_value_t[] args, short nargs);
alias gravity_bridge_setvalue = bool function (gravity_vm* vm, void* xdata, gravity_value_t target, const(char)* key, gravity_value_t value);
alias gravity_bridge_setundef = bool function (gravity_vm* vm, void* xdata, gravity_value_t target, const(char)* key, gravity_value_t value);
alias gravity_bridge_size = uint function (gravity_vm* vm, gravity_object_t* obj);
alias gravity_bridge_string = const(char)* function (gravity_vm* vm, void* xdata, uint* len);

struct gravity_delegate_t
{
    // user data
    void* xdata; // optional user data transparently passed between callbacks
    bool report_null_errors; // by default messages sent to null objects are silently ignored (if this flag is false)
    bool disable_gccheck_1; // memory allocations are protected so it could be useful to automatically check gc when enabled is restored

    // callbacks
    gravity_log_callback log_callback; // log reporting callback
    gravity_log_clear log_clear; // log reset callback
    gravity_error_callback error_callback; // error reporting callback
    gravity_unittest_callback unittest_callback; // special unit test callback
    gravity_parser_callback parser_callback; // lexer callback used for syntax highlight
    gravity_type_callback type_callback; // callback used to bind a token with a declared type
    gravity_precode_callback precode_callback; // called at parse time in order to give the opportunity to add custom source code
    gravity_loadfile_callback loadfile_callback; // callback to give the opportunity to load a file from an import statement
    gravity_filename_callback filename_callback; // called while reporting an error in order to be able to convert a fileid to a real filename
    gravity_optclass_callback optional_classes; // optional classes to be exposed to the semantic checker as extern (to be later registered)

    // bridge
    gravity_bridge_initinstance bridge_initinstance; // init class
    gravity_bridge_setvalue bridge_setvalue; // setter
    gravity_bridge_getvalue bridge_getvalue; // getter
    gravity_bridge_setundef bridge_setundef; // setter not found
    gravity_bridge_getundef bridge_getundef; // getter not found
    gravity_bridge_execute bridge_execute; // execute a method/function
    gravity_bridge_blacken bridge_blacken; // blacken obj to be GC friend
    gravity_bridge_string bridge_string; // instance string conversion
    gravity_bridge_equals bridge_equals; // check if two objects are equals
    gravity_bridge_clone bridge_clone; // clone
    gravity_bridge_size bridge_size; // size of obj
    gravity_bridge_free bridge_free; // free obj
}
