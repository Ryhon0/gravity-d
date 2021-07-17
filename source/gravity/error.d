module gravity.error;

import gravity.c.delegate_;

enum ErrorType
{
	GRAVITY_ERROR_NONE = 0,
	GRAVITY_ERROR_SYNTAX = 1,
	GRAVITY_ERROR_SEMANTIC = 2,
	GRAVITY_ERROR_RUNTIME = 3,
	GRAVITY_ERROR_IO = 4,
	GRAVITY_WARNING = 5
}

class ErrorDesc
{
	error_desc_t desc;

	this(error_desc_t d)
	{
		desc = d;
	}

	@property uint LineNumber()
	{
		return desc.lineno;
	}

	@property uint ColumnNumber()
	{
		return desc.colno;
	}

	@property uint FileID()
	{
		return desc.fileid;
	}

	@property uint Offset()
	{
		return desc.offset;
	}
}
