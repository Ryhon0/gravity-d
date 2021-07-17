module gravity.fiber;

import gravity.c.value;

class GravityFiber
{
	gravity_fiber_t* fiber;
	this(gravity_fiber_t* f)
	{
		fiber = f;
	}
}