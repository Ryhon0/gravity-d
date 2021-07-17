# gravity-d
D bindings and wrapper for [gravity](https://github.com/marcobambini/gravity)

Currently the only fully wrapped classes are GravityVM, GravityCompiler, GravityCore and GravityDelegate (needs wrappers for invidual delegates)

## Generating the bindings
1. Downlaod dstep
2. Copy all the .h files from `gravity/src`
3. Edit `gravity_array.h` and `gravity_debug.h` to include `stdbool.h` and `stddef.h`
4. Run `dstep *` in the folder

## TODO
* Match wrapper module names with bindings
* Write more wrappers
	* Delegate wrappers
* Fix bindings to gravity_ast
* Versions
	* Optional classes
	* Static linking
		* Compiling gravity to .o/.lib in dub.json
	* Dynamic linking
		* Separate version for compiling .so/.dylib/.dll