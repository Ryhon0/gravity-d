module gravity.c.codegen;

import gravity.c.value;
import gravity.c.vm;
import gravity.c.delegate_;
import gravity.c.ast;

//
//  gravity_codegen.h
//  gravity
//
//  Created by Marco Bambini on 09/10/14.
//  Copyright (c) 2014 CreoLabs. All rights reserved.
//

extern (C):

gravity_function_t* gravity_codegen (gnode_t* node, gravity_delegate_t* delegate_, gravity_vm* vm, bool add_debug);

