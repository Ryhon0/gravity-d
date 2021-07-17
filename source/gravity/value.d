module gravity.value;
import gravity.c.value;

class GravityValue
{
	gravity_value_t value;
	this(gravity_value_t v)
	{
		value = v;
	}
}

class GravityClass
{
	gravity_class_t* class_;
	this(gravity_class_t* c)
	{
		class_ = c;
	}
}

class GravityFunction
{
	gravity_function_t* function_;
	this(gravity_function_t* f)
	{
		function_ = f;
	}
}