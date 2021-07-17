module gravity.core;

import std.string;
import gravity.c.core;
import gravity.c.value;
import gravity.value;
import gravity.vm;
import gravity.closure;

GravityClass classFromName(string name)
{
	return new GravityClass(gravity_core_class_from_name(name.toStringz));
}

void free()
{
	gravity_core_free();
}

@property const(char*)* identifiers()
{
	return gravity_core_identifiers();
}

void init()
{
	gravity_core_init();
}

void register(GravityVM vm)
{
	gravity_core_register(vm.vm);
}

bool isCoreClass(GravityClass c)
{
	return gravity_iscore_class(c.class_);
}

// Should these be moved to GravityVM?
GravityValue valueToBool(GravityVM vm, GravityValue v)
{
	return new GravityValue(convert_value2bool(vm.vm, v.value));
}

GravityValue valueToFloat(GravityVM vm, GravityValue v)
{
	return new GravityValue(convert_value2float(vm.vm, v.value));
}

GravityValue valueToInt(GravityVM vm, GravityValue v)
{
	return new GravityValue(convert_value2int(vm.vm, v.value));
}

GravityValue valueToString(GravityVM vm, GravityValue v)
{
	return new GravityValue(convert_value2string(vm.vm, v.value));
}

GravityClosure computedPropertyCreate(GravityVM vm, GravityFunction getter, GravityFunction setter)
{
	return new GravityClosure(computed_property_create(vm.vm, getter.function_, setter.function_));
}

void ComputedPropertyFree(GravityClass c, string name, bool removeFlag)
{
	computed_property_free(c.class_, name.toStringz, removeFlag);
}
