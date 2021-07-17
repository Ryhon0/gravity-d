unittest
{
	import gravity;
	import std.stdio;

	string source = "func main() {var a = 10; var b=20; return a + b}";

	import gravity.c.vm;
	import gravity.c.delegate_;
	import gravity.c.value;

	extern (C) void report_error(gravity_vm* vm, error_type_t error_type,
			const char* description, error_desc_t error_desc, void* xdata)
	{
		printf("%s\n", description);
		//exit(0);
	}

	int main()
	{
		// configure a VM delegate
		GravityDelegate del = new GravityDelegate();
		del.errorCallback = &report_error;

		// compile Gravity source code into bytecode
		GravityCompiler compiler = new GravityCompiler(del);
		GravityClosure closure = compiler.run(source, 0, true, true);

		// sanity check on compiled source
		if (!closure)
		{
			// an error occurred while compiling source code and it has already been reported by the report_error callback
			compiler.free();
			return 1;
		}

		// create a new VM
		GravityVM vm = new GravityVM(del);

		// transfer objects owned by the compiler to the VM (so they can be part of the GC)
		compiler.transfer(vm);

		// compiler can now be freed
		compiler.free();

		// run main closure inside Gravity bytecode
		if (vm.runMain(closure))
		{
			// print result (INT) 30 in this simple example
			GravityValue result = vm.result;
			gravity_value_dump(vm.vm, result.value, null, 0);
		}

		// free VM memory and core libraries
		vm.free();
		Core.free();

		return 0;
	}
}