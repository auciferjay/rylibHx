package cn.royan.hl.uis.style;
import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.utils.SystemUtils;

/**
 * ...
 * @author RoYan
 */
class Style implements Dynamic
{
	var document:StyleCSS;
	
	public function new(name:StyleCSS, property:String) 
	{
		document = name;
		
		parseAtlasCss(property);
	}
	
	function parseAtlasCss(property:String):Void
	{
		var position:Int = 0;
		while ( position < property.length ) {
			var start:Int = property.indexOf(":", position);
			var end:Int = property.indexOf(";", position);
			var name:String = property.substring(position, start);
			var value:String = property.substring(start + 1, end);
			
			if ( name == "@extends" ) {
				SystemUtils.print("copyFrom:" + value, PrintConst.UIS);
				copyFrom(document.getStyle(value));
			}else {
				SystemUtils.print(name + ":" + value, PrintConst.UIS);
				Reflect.setField(this, name, decode(value));
			}
			
			position = end + 1;
		}
	}
	
	function decode(str:String):Dynamic
	{
		if ( str.charAt(0) == "[" && str.charAt(str.length - 1) == "]" ) {
			var list:Array<Float> = [];
			str = str.substring(1, str.length - 1);
			for ( item in str.split(",") ) {
				list.push(decode(item));
			}
			return list;
		}
		
		if ( str.substr(0, 2) == "0x" ) {
			return Std.parseInt(str);
		}
		
		if ( str.charAt(0) == "\"" && str.charAt(str.length - 1) == "\"" ) {
			return str.substring(1, str.length - 1);
		}
		
		return Std.parseFloat(str);
	}
	
	public function copyFrom(source:Style):Void
	{
		for ( field in Reflect.fields(source) ) {
			if ( !Reflect.isFunction( Reflect.field(source, field) ) ) {
				Reflect.setField( this, field, Reflect.field(source, field) );
				SystemUtils.print(field + ":" + Reflect.field(source, field), PrintConst.UIS);
			}
		}
	}
}