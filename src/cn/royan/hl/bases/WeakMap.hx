package cn.royan.hl.bases;

import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.utils.SystemUtils;

#if !flash
import nme.ObjectHash;
#else
import flash.utils.TypedDictionary;
#end
/**
 * ...
 * @author RoYan
 */

class WeakMap
{
	static var __instance:WeakMap;
	
	#if !flash
	var map:ObjectHash<Dynamic, Array<String>>;
	#else
	var map:TypedDictionary<Dynamic, Array<String>>;
	#end
	var keys:Array<String>;
	var length:Int;
	
	public static function getInstance():WeakMap
	{
		if ( __instance == null ) __instance = new WeakMap();
		return __instance;
	}
	
	function new()
	{
		#if !flash
		map = new ObjectHash < Dynamic, Array<String> > ();
		#else
		map = new TypedDictionary < Dynamic, Array<String> > (true);
		#end
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
		for (item in map) {
			result.push(item);
		}
		return result;
	}
	
	public function containValue(value:Dynamic):Bool
	{
		//SystemUtils.print(Type.getClass(value), PrintConst.BASES);
		for (item in map) {
			if ( item == value ) {
				return true;
			}
		}
		return false;
	}
	
	public function containKey(key:String):Bool
	{
		SystemUtils.print(key, PrintConst.BASES);
		for( item in keys) {
			if( item == key ) {
				return true;
			}
		}
		return false;
	}
	
	public function set(key:String, value:Dynamic):Void
	{
		SystemUtils.print(key, PrintConst.BASES);
		//如果键存在，删除键
		if( containKey( key ) ) {
			for ( item in map ) {
				item.remove( key );
			}
			length--;
		}
		//如果值存在
		if( containValue( value ) ) {
			//增加指向值的键
			#if flash
			untyped map[value].push( key );
			#else
			map.get(value).push(key);
			#end
		} else {
			//指向值的键
			SystemUtils.print(map +":"+[key], PrintConst.BASES);
			#if flash
			untyped map[value] = [key];
			#else
			map.set(value, [key]);
			#end
		}
		length++;
		if( SystemUtils.arrayIndexOf(keys, key) == -1 )
			keys.push(key);
	}
	
	public function getValue(key:String):Dynamic
	{
		SystemUtils.print(key, PrintConst.BASES);
		// i 为值
		for (item in map.keys())
		{
			// 指向 i 的键
			#if flash
			var key_arr:Array<Dynamic> = untyped map[item];
			#else
			var key_arr:Array<Dynamic> = map.get(item);
			#end
			SystemUtils.print(map.get(item), PrintConst.BASES);
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
		return untyped map[value];
	}
	
	public function clear(key:String):Void
	{
		SystemUtils.print(key, PrintConst.BASES);
		var value:Dynamic = getValue(key);
		var key_arr:Array<Dynamic> = untyped map[value];
		if( key_arr != null )
		{
			key_arr.remove(key);
			
			if( key_arr.length <= 0 )
			{
				untyped map[value];
			}
			
			length--;
			
			keys.remove(key);
		}
	}
}