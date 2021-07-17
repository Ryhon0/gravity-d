module gravity.compiler;

import gravity.c.compiler;
import gravity.delegate_;
import gravity.closure;
import gravity.c.ast;
import gravity.c.json;

import std.string;
import gravity.vm;

public class GravityCompiler
{
	gravity_compiler_t* compiler;

	this(gravity_compiler_t* c)
	{
		compiler = c;
	}

	this(GravityDelegate d)
	{
		this(gravity_compiler_create(d.del));
	}

	GravityClosure run(string source, uint fileid, bool is_static, bool add_debug)
	{
		return new GravityClosure(gravity_compiler_run(compiler, source.ptr, source.length, fileid, is_static, add_debug));
	}

	@property gnode_t* AST()
	{
		return gravity_compiler_ast(compiler);
	}

	void free()
	{
		gravity_compiler_free(compiler);
	}

	json_t* serialize(GravityClosure c)
	{
		return gravity_compiler_serialize(compiler, c.closure);
	}

	bool serializeInfile(GravityClosure c, string path)
	{
		return gravity_compiler_serialize_infile(compiler, c.closure, path.toStringz);
	}

	void transfer(GravityVM vm)
	{
		gravity_compiler_transfer(compiler, vm.vm);
	}
}