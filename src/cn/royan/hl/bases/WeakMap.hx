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
 * 弱引用池
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

	/**
	 * 获取单例
	 * @return
	 */
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
	
	/**
	 * 获取键值数量
	 * @return
	 */
	public function getLength():Int
	{
		return length;
	}
	
	/**
	 * 获取键值列表
	 * @return
	 */
	public function getAllKeys():Array<String>
	{
		return keys;
	}

	/**
	 * 获取对象列表
	 * @return
	 */
	public function getValues():Array<Dynamic>
	{
		var result:Array<Dynamic> = [];
		for (item in map) {
			result.push(item);
		}
		return result;
	}
	
	/**
	 * 判断是否包含对象
	 * @param	value
	 * @return
	 */
	public function containValue(value:Dynamic):Bool
	{
		for (item in map) {
			if ( item == value ) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 判断是否包含键值
	 * @param	key
	 * @return
	 */
	public function containKey(key:String):Bool
	{
		for( item in keys) {
			if( item == key ) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 设置对象
	 * @param	key		键值
	 * @param	value	对象
	 */
	public function set(key:String, value:Dynamic):Void
	{
		//如果键存在，删除键
		if( containKey( key ) ) {
			for (item in map.keys())
			{
				// 指向 i 的键
				#if flash
				var key_arr:Array<Dynamic> = untyped map[item];
				#else
				var key_arr:Array<Dynamic> = map.get(item);
				#end
				key_arr.remove(key);
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

	/**
	 * 获取对象
	 * @param	key
	 * @return
	 */
	public function getValue(key:String):Dynamic
	{
		// i 为值
		for (item in map.keys())
		{
			// 指向 i 的键
			#if flash
			var key_arr:Array<Dynamic> = untyped map[item];
			#else
			var key_arr:Array<Dynamic> = map.get(item);
			#end
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

	/**
	 * 获取对象对应的所有键值
	 * @param	value
	 * @return
	 */
	public function getKeys(value:Dynamic):Array<Dynamic>
	{
		#if flash
		return untyped map[value];
		#else
		return map.get(value);
		#end
	}

	/**
	 * 清楚键值
	 * @param	key
	 */
	public function clear(key:String):Void
	{
		var value:Dynamic = getValue(key);
		#if flash
		var key_arr:Array<Dynamic> = untyped map[value];
		#else
		var key_arr:Array<Dynamic> = map.get(value);
		#end
		if( key_arr != null )
		{
			key_arr.remove(key);

			if( key_arr.length <= 0 )
			{
				#if flash
				untyped map[value];
				#else
				map.get(value);
				#end
			}

			length--;

			keys.remove(key);
		}
	}
}