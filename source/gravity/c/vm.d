module gravity.c.vm;

import gravity.c.value;
import gravity.c.delegate_;

//
//  gravity_vm.h
//  gravity
//
//  Created by Marco Bambini on 11/11/14.
//  Copyright (c) 2014 CreoLabs. All rights reserved.
//

extern (C):

struct gravity_vm;

enum GRAVITY_VM_GCENABLED = "gcEnabled";
enum GRAVITY_VM_GCMINTHRESHOLD = "gcMinThreshold";
enum GRAVITY_VM_GCTHRESHOLD = "gcThreshold";
enum GRAVITY_VM_GCRATIO = "gcRatio";
enum GRAVITY_VM_MAXCALLS = "maxCCalls";
enum GRAVITY_VM_MAXBLOCK = "maxBlock";
enum GRAVITY_VM_MAXRECURSION = "maxRecursionDepth";

alias vm_cleanup_cb = void function (gravity_vm* vm);
alias vm_filter_cb = bool function (gravity_object_t* obj);
alias vm_transfer_cb = void function (gravity_vm* vm, gravity_object_t* obj);

gravity_delegate_t* gravity_vm_delegate (gravity_vm* vm);
gravity_fiber_t* gravity_vm_fiber (gravity_vm* vm);
void gravity_vm_free (gravity_vm* vm);
gravity_closure_t* gravity_vm_getclosure (gravity_vm* vm);
gravity_value_t gravity_vm_getvalue (gravity_vm* vm, const(char)* key, uint keylen);
gravity_value_t gravity_vm_keyindex (gravity_vm* vm, uint index);
bool gravity_vm_ismini (gravity_vm* vm);
bool gravity_vm_isaborted (gravity_vm* vm);
void gravity_vm_loadclosure (gravity_vm* vm, gravity_closure_t* closure);
gravity_value_t gravity_vm_lookup (gravity_vm* vm, gravity_value_t key);
gravity_vm* gravity_vm_new (gravity_delegate_t* delegate_);
gravity_vm* gravity_vm_newmini ();
void gravity_vm_reset (gravity_vm* vm);
gravity_value_t gravity_vm_result (gravity_vm* vm);
bool gravity_vm_runclosure (gravity_vm* vm, gravity_closure_t* closure, gravity_value_t sender, gravity_value_t* params, ushort nparams);
bool gravity_vm_runmain (gravity_vm* vm, gravity_closure_t* closure);
void gravity_vm_set_callbacks (gravity_vm* vm, vm_transfer_cb vm_transfer, vm_cleanup_cb vm_cleanup);
void gravity_vm_setaborted (gravity_vm* vm);
void gravity_vm_seterror (gravity_vm* vm, const(char)* format, ...);
void gravity_vm_seterror_string (gravity_vm* vm, const(char)* s);
void gravity_vm_setfiber (gravity_vm* vm, gravity_fiber_t* fiber);
void gravity_vm_setvalue (gravity_vm* vm, const(char)* key, gravity_value_t value);
double gravity_vm_time (gravity_vm* vm);

void gravity_gray_object (gravity_vm* vm, gravity_object_t* obj);
void gravity_gray_value (gravity_vm* vm, gravity_value_t v);
void gravity_gc_setenabled (gravity_vm* vm, bool enabled);
void gravity_gc_setvalues (gravity_vm* vm, gravity_int_t threshold, gravity_int_t minthreshold, gravity_float_t ratio);
void gravity_gc_start (gravity_vm* vm);
void gravity_gc_tempnull (gravity_vm* vm, gravity_object_t* obj);
void gravity_gc_temppop (gravity_vm* vm);
void gravity_gc_temppush (gravity_vm* vm, gravity_object_t* obj);

void gravity_vm_cleanup (gravity_vm* vm);
void gravity_vm_filter (gravity_vm* vm, vm_filter_cb cleanup_filter);
void gravity_vm_transfer (gravity_vm* vm, gravity_object_t* obj);

void gravity_vm_initmodule (gravity_vm* vm, gravity_function_t* f);
gravity_closure_t* gravity_vm_loadbuffer (gravity_vm* vm, const(char)* buffer, size_t len);
gravity_closure_t* gravity_vm_loadfile (gravity_vm* vm, const(char)* path);

gravity_closure_t* gravity_vm_fastlookup (gravity_vm* vm, gravity_class_t* c, int index);
void* gravity_vm_getdata (gravity_vm* vm);
gravity_value_t gravity_vm_getslot (gravity_vm* vm, uint index);
void gravity_vm_setdata (gravity_vm* vm, void* data);
void gravity_vm_setslot (gravity_vm* vm, gravity_value_t value, uint index);
gravity_int_t gravity_vm_maxmemblock (gravity_vm* vm);
void gravity_vm_memupdate (gravity_vm* vm, gravity_int_t value);

char* gravity_vm_anonymous (gravity_vm* vm);
gravity_value_t gravity_vm_get (gravity_vm* vm, const(char)* key);
bool gravity_vm_set (gravity_vm* vm, const(char)* key, gravity_value_t value);

bool gravity_isopt_class (gravity_class_t* c);
void gravity_opt_free ();
void gravity_opt_register (gravity_vm* vm);

