module gravity.value;
import gravity.c.value;
import std.string;
import gravity.fiber;
import gravity.closure;
import std.conv;
import gravity.vm;

class GravityValue
{
	gravity_value_t value;
	this(gravity_value_t v)
	{
		value = v;
	}

	this(bool b)
	{
		this(gravity_value_from_bool(b));
	}

	static GravityValue fromString(GravityVM vm, string s)
	{
		return new GravityValue(gravity_string_to_value(vm.vm, s.toStringz, uint.max));
	}

	static GravityValue fromCString(GravityVM vm, string s)
	{
		return new GravityValue(gravity_string_to_value(vm.vm, s.ptr, cast(uint) s.length));
	}

	static GravityValue fromError(string s)
	{
		return new GravityValue(gravity_value_from_error(s.toStringz));
	}

	this(float f)
	{
		this(gravity_value_from_float(f));
	}

	this(int i)
	{
		this(gravity_value_from_int(i));
	}

	this(void* obj)
	{
		this(gravity_value_from_object(obj));
	}

	static GravityValue fromNull()
	{
		return new GravityValue(gravity_value_from_null());
	}

	static GravityValue fromUndefined()
	{
		return new GravityValue(gravity_value_from_undefined());
	}

	void* asObject()
	{
		return value.p;
	}

	GravityString asString()
	{
		return new GravityString(cast(gravity_string_t*) asObject());
	}

	GravityFiber asFiber()
	{
		return new GravityFiber(cast(gravity_fiber_t*) asObject());
	}

	GravityFunction asFunction()
	{
		return new GravityFunction(cast(gravity_function_t*) asObject());
	}

	/*
	GravityProperty asProperty()
	{
		return new GravityProperty(cast(gravity_property_t*)asObject());
	}
	*/

	GravityClosure asClosure()
	{
		return new GravityClosure(cast(gravity_closure_t*) asObject());
	}

	GravityClass asClass()
	{
		return new GravityClass(cast(gravity_class_t*) asObject());
	}

	GravityInstance asInstance()
	{
		return new GravityInstance(cast(gravity_instance_t*) asObject());
	}

	GravityList asList()
	{
		return new GravityList(cast(gravity_list_t*) asObject());
	}

	GravityMap asMap()
	{
		return new GravityMap(cast(gravity_map_t*) asObject());
	}

	GravityRange asRange()
	{
		return new GravityRange(cast(gravity_range_t*) asObject());
	}

	string asError()
	{
		return (cast(const(char*)) value.p).to!string;
	}

	float asFloat()
	{
		return value.f;
	}

	long asInt()
	{
		return value.n;
	}

	bool asBool()
	{
		return cast(bool) value.n;
	}

	bool isaFunction()
	{
		return value.isa == gravity_class_function;
	}

	bool isaInstance()
	{
		return value.isa == gravity_class_instance;
	}

	bool isaClosure()
	{
		return value.isa == gravity_class_closure;
	}

	bool isaFiber()
	{
		return value.isa == gravity_class_fiber;
	}

	bool isaString()
	{
		return value.isa == gravity_class_string;
	}

	bool isaInt()
	{
		return value.isa == gravity_class_int;
	}

	bool isaFloat()
	{
		return value.isa == gravity_class_float;
	}

	bool isaBool()
	{
		return value.isa == gravity_class_bool;
	}

	bool isaList()
	{
		return value.isa == gravity_class_list;
	}

	bool isaMap()
	{
		return value.isa == gravity_class_map;
	}

	bool isaRange()
	{
		return value.isa == gravity_class_range;
	}

	bool isaBasicType()
	{
		return isaString() || isaInt() || isaFloat() || isaBool();
	}

	bool isaNullClass()
	{
		return value.isa == gravity_class_null;
	}

	bool isaNull()
	{
		return value.isa == gravity_class_null || value.n == 0;
	}

	bool isaUndefined()
	{
		return value.isa == gravity_class_null || value.n == 1;
	}

	bool isaClass()
	{
		return value.isa == gravity_class_class;
	}

	bool isaCallable()
	{
		return isaFunction() || isaClass() || isaFiber();
	}

	bool isaValid()
	{
		return value.isa != null;
	}

	bool isaNotValid()
	{
		return value.isa == null;
	}

	bool isaError()
	{
		return isaNotValid();
	}
}

class GravityObject
{
	gravity_object_t* object;
	this(gravity_object_t* obj)
	{
		this.object = obj;
	}

	bool isaInt()
	{
		return object.isa == gravity_class_int;
	}

	bool isaFloat()
	{
		return (*object).isa == gravity_class_float;
	}

	bool isaBool()
	{
		return (*object).isa == gravity_class_bool;
	}

	bool isaNull()
	{
		return (*object).isa == gravity_class_null;
	}

	bool isaClass()
	{
		return (*object).isa == gravity_class_class;
	}

	bool isaFunction()
	{
		return (*object).isa == gravity_class_function;
	}

	bool isaClosure()
	{
		return (*object).isa == gravity_class_closure;
	}

	bool isaInstance()
	{
		return (*object).isa == gravity_class_instance;
	}

	bool isaList()
	{
		return (*object).isa == gravity_class_list;
	}

	bool isaMap()
	{
		return (*object).isa == gravity_class_map;
	}

	bool isaString()
	{
		return (*object).isa == gravity_class_string;
	}

	bool isaUpValue()
	{
		return (*object).isa == gravity_class_upvalue;
	}

	bool isaFiber()
	{
		return (*object).isa == gravity_class_fiber;
	}

	bool isaRange()
	{
		return (*object).isa == gravity_class_range;
	}

	bool isaModule()
	{
		return (*object).isa == gravity_class_module;
	}

	bool isValid()
	{
		return (*object).isa != null;
	}
}

class GravityString
{
	gravity_string_t* str;
	this(gravity_string_t* s)
	{
		str = s;
	}

	override string toString()
	{
		return str.s.to!string;
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

/*
class GravityProperty
{
	gravity_property_t* property_;
	this(gravity_property_t* p)
	{
		property_ = p;
	}
}
*/

class GravityInstance
{
	gravity_instance_t* instance_;
	this(gravity_instance_t* i)
	{
		instance_ = i;
	}
}

class GravityList
{
	gravity_list_t* list_;
	this(gravity_list_t* l)
	{
		list_ = l;
	}
}

class GravityMap
{
	gravity_map_t* map_;
	this(gravity_map_t* m)
	{
		map_ = m;
	}
}

class GravityRange
{
	gravity_range_t* range_;
	this(gravity_range_t* r)
	{
		range_ = r;
	}
}
