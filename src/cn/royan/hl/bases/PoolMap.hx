package cn.royan.hl.bases;
import flash.utils.Dictionary;

class PoolMap 
{
	static public inline var maxValue:Int = 10;
		
	static var __weakMap:WeakMap = WeakMap.getInstance();
	static var __pools:Dictionary = new Dictionary();
		
	static public function getInstanceByType():Dynamic
	{
		
	}
	
	static public function disposeInstance():Void
	{
		
	}
}