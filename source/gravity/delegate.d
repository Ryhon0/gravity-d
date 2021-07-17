module gravity.delegate_;
import gravity.c.delegate_;

class GravityDelegate
{
	gravity_delegate_t* del;

	this(gravity_delegate_t* d)
	{
		del = d;
	}

	this()
	{
		this(new gravity_delegate_t());
	}

	// user data

	/// optional user data transparently passed between callbacks
	@property void* xData() { return del.xdata;}
	@property void xData(void* value) { del.xdata = value;}
	/// by default messages sent to null objects are silently ignored (if this flag is false)
	@property bool reportNullErrors () { return del.report_null_errors;}
	@property void reportNullErrors(bool value) { del.report_null_errors = value;}
	/// memory allocations are protected so it could be useful to automatically check gc when enabled is restored
	@property bool disableGCCheck_1() { return del.disable_gccheck_1;}
	@property void disableGCCheck_1(bool value) { del.disable_gccheck_1 = value;}

	// callbacks
	/// log reporting callback
	@property gravity_log_callback logCallback() { return del.log_callback;}
	@property void logCallback(gravity_log_callback value) { del.log_callback = value;}
	/// log reset callback
	@property gravity_log_clear logClear() { return del.log_clear;}
	@property void logClear(gravity_log_clear value) { del.log_clear = value;}
	/// error reporting callback
	@property gravity_error_callback errorCallback() { return del.error_callback;}
	@property void errorCallback(gravity_error_callback value) { del.error_callback = value;}
	/// special unit test callback
	@property gravity_unittest_callback unitTestCallback() { return del.unittest_callback;}
	@property void unitTestCallback(gravity_unittest_callback value) { del.unittest_callback = value;}
	/// lexer callback used for syntax highlight
	@property gravity_parser_callback parserCallback() { return del.parser_callback;}
	@property void parserCallback(gravity_parser_callback value) { del.parser_callback = value;}
	/// callback used to bind a token with a declared type
	@property gravity_type_callback typeCallback() { return del.type_callback;}
	@property void typeCallback(gravity_type_callback value) { del.type_callback = value;}
	/// called at parse time in order to give the opportunity to add custom source code
	@property gravity_precode_callback precodeCallback() { return del.precode_callback;}
	@property void precodeCallback(gravity_precode_callback value) { del.precode_callback = value;}
	/// callback to give the opportunity to load a file from an import statement
	@property gravity_loadfile_callback loadFileCallback() { return del.loadfile_callback;}
	@property void loadFileCallback(gravity_loadfile_callback value) { del.loadfile_callback = value;}
	/// called while reporting an error in order to be able to convert a fileid to a real filename
	@property gravity_filename_callback fileNameCallback() { return del.filename_callback;}
	@property void fileNameCallback(gravity_filename_callback value) { del.filename_callback = value;}
	/// optional classes to be exposed to the semantic checker as extern (to be later registered)
	@property gravity_optclass_callback optionalClasses() { return del.optional_classes;}
	@property void optionalClasses(gravity_optclass_callback value) { del.optional_classes = value;}

	// bridge
	/// init class
	@property gravity_bridge_initinstance bridgeInitinstance() { return del.bridge_initinstance;}
	@property void bridgeInitinstance(gravity_bridge_initinstance value) { del.bridge_initinstance = value;}
	/// setter
	@property gravity_bridge_setvalue bridgeSetValue() { return del.bridge_setvalue;}
	@property void bridgeSetValue(gravity_bridge_setvalue value) { del.bridge_setvalue = value;}
	/// getter
	@property gravity_bridge_getvalue bridgeGetValue() { return del.bridge_getvalue;}
	@property void bridgeGetValue(gravity_bridge_getvalue value) { del.bridge_getvalue = value;}
	/// setter not found
	@property gravity_bridge_setundef bridgeSetUndef() { return del.bridge_setundef;}
	@property void bridgeSetUndef(gravity_bridge_setundef value) { del.bridge_setundef = value;}
	/// getter not found
	@property gravity_bridge_getundef bridgeGetUndef() { return del.bridge_getundef;}
	@property void bridgeGetUndef(gravity_bridge_getundef value) { del.bridge_getundef = value;}
	/// execute a method/function
	@property gravity_bridge_execute bridgeExecute() { return del.bridge_execute;}
	@property void bridgeExecute(gravity_bridge_execute value) { del.bridge_execute = value;}
	/// blacken obj to be GC friend
	@property gravity_bridge_blacken bridgeBlacken() { return del.bridge_blacken;}
	@property void bridgeBlacken(gravity_bridge_blacken value) { del.bridge_blacken = value;}
	/// instance string conversion
	@property gravity_bridge_string bridgeString() { return del.bridge_string;}
	@property void bridgeString(gravity_bridge_string value) { del.bridge_string = value;}
	// check if two objects are equals
	@property gravity_bridge_equals bridgeEquals() { return del.bridge_equals;}
	@property void bridgeEquals(gravity_bridge_equals value) { del.bridge_equals = value;}
	/// clone
	@property gravity_bridge_clone bridgeClone() { return del.bridge_clone;}
	@property void bridgeClone(gravity_bridge_clone value) { del.bridge_clone = value;}
	/// size of obj
	@property gravity_bridge_size bridgeSize() { return del.bridge_size;}
	@property void bridgeSize(gravity_bridge_size value) { del.bridge_size = value;}
	/// free obj
	@property gravity_bridge_free bridgeFree() { return del.bridge_free;}
	@property void bridgeFree(gravity_bridge_free value) { del.bridge_free = value;}
}