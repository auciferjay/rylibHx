package cn.royan.hl.uis.style;

import cn.royan.hl.bases.Dictionary;
import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.utils.SystemUtils;

/**
 * ...
 * @author RoYan
 */
class StyleManager
{
	static var gameCSSs:Dictionary = #if flash new Dictionary(); #else { }; #end
	static var gameStyles:Dictionary = #if flash new Dictionary(); #else { }; #end
	
	static public function setCSS(type:String, value:String):Void
	{
		Reflect.setField(gameStyles, type, value);
	}
	
	static public function getCSS(type:String):StyleCSS
	{
		if (Reflect.field(gameStyles, type) == null) {
			return null;
		}
		
		if (Reflect.field(gameCSSs, type) == null)
		{
			SystemUtils.print(type);
			Reflect.setField(gameCSSs, type, new StyleCSS( type, Reflect.field(gameStyles, type) ) );
		}
		return Reflect.field(gameCSSs, type);
	}
}