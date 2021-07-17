module gravity.callbacks;

import gravity.c.vm;

class TransferCB
{
	vm_transfer_cb transfer_cb;
	this(vm_transfer_cb cb)
	{
		transfer_cb = cb;
	}
}

class CleanupCB
{
	vm_cleanup_cb cleanup_cb;
	this(vm_cleanup_cb cb)
	{
		cleanup_cb = cb;
	}
}

class FilterCB
{
	vm_filter_cb filter_cb;
	this(vm_filter_cb cb)
	{
		filter_cb = cb;
	}
}