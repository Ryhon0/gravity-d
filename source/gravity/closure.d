module gravity.closure;

import gravity.c.value;

class GravityClosure
{
	gravity_closure_t* closure;
	this (gravity_closure_t* c)
	{
		closure = c;
	}
}