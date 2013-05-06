package cn.royan.hl.utils;

import flash.Vector;
import starling.textures.Texture;

/**
 * ...
 * @author RoYan
 */
class StarlingUtils
{
	public static function toArray(vector:Vector<Texture>):Array<Dynamic>
	{
		var result:Array<Dynamic> = [];
		for ( item in vector ) {
			result.push(item);
		}
		return result;
	}
}