package cn.royan.hl.bases;

/**
 * ...
 * @author RoYan
 */

class WeakMap 
{
	static var __instance:WeakMap;
	
	public static function getInstance():WeakMap
	{
		return __instance;
	}
}