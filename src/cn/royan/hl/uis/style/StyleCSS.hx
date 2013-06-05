package cn.royan.hl.uis.style;

import cn.royan.hl.bases.Dictionary;
import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.utils.SystemUtils;

/**
 * ...
 * @author RoYan
 */
class StyleCSS
{
	var css:String;
	var styles:Dictionary;
	
	public function new(name:String, value:String) 
	{
		css = name;
		
		styles = #if flash new Dictionary(); #else { }; #end
		
		parseAtlasCss(value);
	}
	
	function parseAtlasCss(value:String):Void
	{
		var position:Int = 0;
		while ( position < value.length ) {
			var start:Int = value.indexOf("{", position);
			var end:Int = value.indexOf("}", position);
			var name:String = value.substring(position, start);
			var property:String = value.substring(start + 1, end);
			
			SystemUtils.print(name + " {", PrintConst.UIS);
			Reflect.setField(styles, name, new Style(this, property));
			SystemUtils.print("}", PrintConst.UIS);
			position = end + 1;
		}
	}
	
	public function getStyle(name:String):Style
	{
		return Reflect.field(styles, name);
	}
}