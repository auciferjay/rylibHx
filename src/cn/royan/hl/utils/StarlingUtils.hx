package cn.royan.hl.utils;

import flash.Vector;
import starling.textures.Texture;

/**
 * ...
 * Starling工具类
 * @author RoYan
 */
class StarlingUtils
{
	/**
	 * 切换列表类型
	 * @param	vector
	 * @return
	 */
	public static function toArray(vector:Vector<Texture>):Array<Dynamic>
	{
		var result:Array<Dynamic> = [];
		for ( item in vector ) {
			result.push(item);
		}
		return result;
	}
}