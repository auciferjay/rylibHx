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
			
			Reflect.setField(styles, name, new Style(css, property));
			
			position = end + 1;
			
			SystemUtils.print(name + ":" + property, PrintConst.UIS);
		}
	}
	
	public function getStyle(name:String):Style
	{
		return Reflect.field(styles, name);
	}
}