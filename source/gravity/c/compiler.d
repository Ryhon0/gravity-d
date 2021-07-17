module gravity.c.compiler;

import gravity.c.value;
import gravity.c.vm;
import gravity.c.json;
import gravity.c.delegate_;
import gravity.c.compiler;
import gravity.c.ast;

//
//  gravity_compiler.h
//  gravity
//
//  Created by Marco Bambini on 29/08/14.
//  Copyright (c) 2014 CreoLabs. All rights reserved.
//

extern (C):

// opaque compiler data type
struct gravity_compiler_t;

gravity_compiler_t* gravity_compiler_create (gravity_delegate_t* delegate_);
gravity_closure_t* gravity_compiler_run (gravity_compiler_t* compiler, const(char)* source, size_t len, uint fileid, bool is_static, bool add_debug);

gnode_t* gravity_compiler_ast (gravity_compiler_t* compiler);
void gravity_compiler_free (gravity_compiler_t* compiler);
json_t* gravity_compiler_serialize (gravity_compiler_t* compiler, gravity_closure_t* closure);
bool gravity_compiler_serialize_infile (gravity_compiler_t* compiler, gravity_closure_t* closure, const(char)* path);
void gravity_compiler_transfer (gravity_compiler_t* compiler, gravity_vm* vm);

