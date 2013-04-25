package cn.royan.hl.bases;
import cn.royan.hl.utils.SystemUtils;
/**
 * ...
 * @author RoYan
 */

class WeakMap
{
	static var __instance:WeakMap;
	
	var map:Dictionary;
	var keys:Array<String>;
	var length:Int;
	
	public static function getInstance():WeakMap
	{
		if ( __instance == null ) __instance = new WeakMap();
		return __instance;
	}
	
	function new()
	{
		map = #if flash new Dictionary(true); #else {}; #end
		keys = [];
		length = 0;
	}
	
	public function getLength():Int
	{
		return length;
	}
	
	public function getAllKeys():Array<String>
	{
		return keys;
	}
	
	public function getValues():Array<Dynamic>
	{
		var result:Array<Dynamic> = [];
		for (i in Reflect.fields(map)) {
			result.push(Reflect.field(map, i));
		}
		return result;
	}
	
	public function contentValue(value:Dynamic):Bool
	{
		for (i in Reflect.fields(map)) {
			if (Reflect.field(map,i) == value) {
				return true;
			}
		}
		return false;
	}
	
	public function contentKey(key:String):Bool
	{
		for( i in keys) {
			if( i == key ) {
				return true;
			}
		}
		return false;
		
	}
	
	public function set(key:String,value:Dynamic):Void
	{
		//如果键存在，删除键
		if( contentKey( key ) ) {
			for ( i in Reflect.fields(map) ) {
				Reflect.field(map,i).splice(SystemUtils.arrayIndexOf(Reflect.field(map,i),key),1);
			}
			length--;
		}
		//如果值存在
		if( contentValue( value ) ) {
			//增加指向值的键
			Reflect.field(map,value).push(key);
		} else {
			//指向值的键
			Reflect.setField(map,value,[key]);
		}
		length++;
		if(SystemUtils.arrayIndexOf(keys, key)<0)
		{
			keys.push(key);
		}
	}
	
	public function getValue(key:String):Dynamic
	{
		// i 为值
		for (item in Reflect.fields(map))
		{
			// 指向 i 的键
			var key_arr:Array<Dynamic> = Reflect.field(map, item);
			for( k in key_arr )
			{
				if( k == key )
				{
					return item;
				}
			}
		}
		return null;
	}
	
	public function getKeys(value:Dynamic):Array<Dynamic>
	{
		return Reflect.field(map,value);
	}
	
	public function clear(key:String):Void
	{
		var value:Dynamic = getValue(key);
		var key_arr:Array<Dynamic> = Reflect.field(map,value);
		if( key_arr != null )
		{
			key_arr.splice(SystemUtils.arrayIndexOf(key_arr, key), 1);
			
			if( key_arr.length <= 0 )
			{
				Reflect.deleteField(map,value);
			}
			
			length--;
			
			keys.splice(SystemUtils.arrayIndexOf(keys, key),1);
		}
	}
}