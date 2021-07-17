module gravity.c.core;

import gravity.c.vm;
import gravity.c.value;

//
//  gravity_core.h
//  gravity
//
//  Created by Marco Bambini on 10/01/15.
//  Copyright (c) 2015 CreoLabs. All rights reserved.
//

extern (C):

// core functions
gravity_class_t* gravity_core_class_from_name (const(char)* name);
void gravity_core_free ();
const(char*)* gravity_core_identifiers ();
void gravity_core_init ();
void gravity_core_register (gravity_vm* vm);
bool gravity_iscore_class (gravity_class_t* c);

// conversion functions
gravity_value_t convert_value2bool (gravity_vm* vm, gravity_value_t v);
gravity_value_t convert_value2float (gravity_vm* vm, gravity_value_t v);
gravity_value_t convert_value2int (gravity_vm* vm, gravity_value_t v);
gravity_value_t convert_value2string (gravity_vm* vm, gravity_value_t v);

// internal functions
gravity_closure_t* computed_property_create (gravity_vm* vm, gravity_function_t* getter_func, gravity_function_t* setter_func);
void computed_property_free (gravity_class_t* c, const(char)* name, bool remove_flag);

