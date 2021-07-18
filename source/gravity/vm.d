module gravity.vm;

import gravity.c.vm;
import gravity.value;
import gravity.delegate_;
import gravity.fiber;
import gravity.closure;
import gravity.callbacks;
import gravity.c.value;

import std.string;
import gravity.utils;

public class GravityVM 
{	
	gravity_vm* vm;

	this(gravity_vm *v)
	{
		vm = v;
	}

	this()
	{
		this(gravity_vm_newmini());
	}

	this(GravityDelegate del)
	{
		this(gravity_vm_new(del.del));
	}

	@property GravityDelegate delegate_()
	{
		return new GravityDelegate(gravity_vm_delegate(vm));
	}

	@property GravityFiber fiber()
	{
		return new GravityFiber(gravity_vm_fiber(vm));
	}

	@property void fiber(GravityFiber value)
	{
		gravity_vm_setfiber(vm, value.fiber);
	}

	void free()
	{
		gravity_vm_free(vm);
	}

	@property GravityClosure closure()
	{
		return new GravityClosure(gravity_vm_getclosure(vm));
	}

	GravityValue getValue(string key)
	{
		return new GravityValue(gravity_vm_getvalue(vm, key.ptr, cast(uint)key.length));
	}

	GravityValue keyIndex(uint index)
	{
		return new GravityValue(gravity_vm_keyindex(vm, index));
	}

	@property bool isMini()
	{
		return gravity_vm_ismini(vm);
	}

	@property bool isAborted()
	{
		return gravity_vm_isaborted(vm);
	}

	void loadClosure(GravityClosure closure)
	{
		gravity_vm_loadclosure(vm, closure.closure);
	}

	GravityValue lookup(GravityValue key)
	{
		return new GravityValue(gravity_vm_lookup(vm, key.value));
	}

	void reset()
	{
		gravity_vm_reset(vm);
	}

	@property GravityValue result()
	{
		return new GravityValue(gravity_vm_result(vm));
	}

	bool runClosure(GravityClosure closure, GravityValue sender, GravityValue[] params)
	{
		return gravity_vm_runclosure(vm, closure.closure, sender.value, params.select!(p=>p.value, gravity_value_t).ptr, cast(ushort)params.length);
	}

	bool runMain(GravityClosure closure)
	{
		return gravity_vm_runmain(vm, closure.closure);
	}

	void setCallbacks(TransferCB transfer, CleanupCB cleanup)
	{
		gravity_vm_set_callbacks(vm, transfer.transfer_cb, cleanup.cleanup_cb);
	}

	void setAborted()
	{
		gravity_vm_setaborted(vm);
	}

	/*
	void setError(string format, ...)
	{
		gravity_vm_seterror(vm, format.ptr, format.length);
	}
	*/

	void setErrorString(string str)
	{
		gravity_vm_seterror_string(vm, str.toStringz);
	}

	void setValue(string key, GravityValue value)
	{
		gravity_vm_setvalue(vm, key.toStringz, value.value);
	}

	@property double time()
	{
		return gravity_vm_time(vm);
	}

	void grayObject(GravityClass c)
	{
		gravity_gray_object(vm, c.class_);
	}

	void grayValue(GravityValue obj)
	{
		gravity_gray_value(vm, obj.value);
	}

	void GCSetEnabled(bool enabled)
	{
		gravity_gc_setenabled(vm, enabled);
	}

	void GCSetValues(gravity_int_t threshold, gravity_int_t minthreshold, gravity_float_t ratio)
	{
		gravity_gc_setvalues(vm, threshold, minthreshold, ratio);
	}

	void GCStart()
	{
		gravity_gc_start(vm);
	}

	void GCTempNull(GravityObject obj)
	{
		gravity_gc_tempnull(vm, obj.object);
	}

	void GCTempPop()
	{
		gravity_gc_temppop(vm);
	}

	void GCTempPush(GravityObject obj)
	{
		gravity_gc_temppush(vm, obj.object);
	}

	void cleanup()
	{
		gravity_vm_cleanup(vm);
	}

	void filter(FilterCB cleanupFilter)
	{
		gravity_vm_filter(vm, cleanupFilter.filter_cb);
	}

	void transfer(GravityObject obj)
	{
		gravity_vm_transfer(vm, obj.object);
	}

	void initModule(GravityFunction func)
	{
		gravity_vm_initmodule(vm, func.function_);
	}

	GravityClosure loadBuffer(string buffer)
	{
		return new GravityClosure(gravity_vm_loadbuffer(vm, buffer.ptr, buffer.length));
	}

	GravityClosure loadFile(string path)
	{
		return new GravityClosure(gravity_vm_loadfile(vm, path.toStringz));
	}

	GravityClosure fastLookup(GravityClass c, int index)
	{
		return new GravityClosure(gravity_vm_fastlookup(vm, c.class_, index));
	}

	@property void* data()
	{
		return gravity_vm_getdata(vm);
	}

	GravityValue getSlot(uint index)
	{
		return new GravityValue(gravity_vm_getslot(vm, index));
	}

	void setData(void* data)
	{
		gravity_vm_setdata(vm, data);
	}

	void setSlot(GravityValue value, uint index)
	{
		gravity_vm_setslot(vm, value.value, index);
	}

	@property gravity_int_t maxMemBlock()
	{
		return gravity_vm_maxmemblock(vm);
	}

	void memUpdate(gravity_int_t size)
	{
		gravity_vm_memupdate(vm, size);
	}

	@property char* anonymous()
	{
		return gravity_vm_anonymous(vm);
	}

	GravityValue get(string key)
	{
		return new GravityValue(gravity_vm_get(vm, key.toStringz));
	}

	bool set(string key, GravityValue value)
	{
		return gravity_vm_set(vm, key.toStringz, value.value);
	}

	static bool isOptClass(GravityClass c)
	{
		return gravity_isopt_class(c.class_);
	}

	static void optFree()
	{
		gravity_opt_free();
	}

	void optRegister()
	{
		gravity_opt_register(vm);
	}
}