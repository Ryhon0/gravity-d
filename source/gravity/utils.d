module gravity.utils;

TResult[] select(alias selector, TResult, TSource)(TSource[] source)
{
	TResult[] results;
	foreach (k; source)
	{
		results ~= selector(k);
	}
	return results;
}