module gravity.object;

import gravity.c.value;

class GravityObject
{
	gravity_object_t* object;
	this(gravity_object_t* obj)
	{
		this.object = obj;
	}
}