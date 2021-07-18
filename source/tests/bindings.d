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

unittest
{
	import gravity;
	import gravity.c.vm;
	import gravity.c.delegate_;
	import std.stdio;
	import std.conv;

	string sourceCode = "
func sum (a, b) { 
    return a + b 
} 
func mul (a, b) {
    return a * b 
}
";

	extern (C) void report_error(gravity_vm* vm, error_type_t error_type,
			const char* message, error_desc_t error_desc, void* xdata)
	{
		printf("%s\n", message);
		//exit(0);
	}

	int main()
	{
		// setup a delegate struct
		GravityDelegate del = new GravityDelegate();
		del.errorCallback = &report_error;

		// allocate a new compiler
		GravityCompiler compiler = new GravityCompiler(del);

		// compile Gravity source code into bytecode
		GravityClosure closure = compiler.run(sourceCode, 0, true, true);

		// allocate a new Gravity VM
		GravityVM vm = new GravityVM(del);

		// transfer memory from the compiler (front-end) to the VM (back-end)
		compiler.transfer(vm);

		// once the memory has been transferred, you can get rid of the front-end
		compiler.free();

		// load closure into VM
		vm.loadClosure(closure);

		// lookup a reference to the mul closure into the Gravity VM
		GravityValue mul = vm.getValue("mul");
		if (!mul.isaClosure())
		{
			printf("Unable to find mul function into Gravity VM.\n");
			return -1;
		}

		// convert function to closure
		GravityClosure mul_closure = mul.asClosure();

		// prepare parameters
		GravityValue p1 = new GravityValue(30);
		GravityValue p2 = new GravityValue(40);
		GravityValue[] params = [p1, p2];

		// execute mul closure
		if (vm.runClosure(mul_closure, GravityValue.fromNull, params))
		{
			// retrieve returned result
			GravityValue result = vm.result;

			// dump result to a C string and print it to stdout
			// string buf = vm.valueDump(result);
			writef("RESULT: %s\n", result.asInt().to!string);
		}

		// free VM and core libraries (implicitly allocated by the VM)
		vm.free;
		Core.free();

		return 0;

	}
}