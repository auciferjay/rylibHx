package cn.royan.hl.uis.style;
import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.utils.SystemUtils;

/**
 * ...
 * @author RoYan
 */
class Style implements Dynamic
{
	var css:String;
	
	public function new(name:String, property:String) 
	{
		css = name;
		
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
				copyFrom(StyleManager.getCSS(css).getStyle(value));
				SystemUtils.print("copyFrom:" + value, PrintConst.UIS);
			}else {
				Reflect.setField(this, name, value);
				SystemUtils.print(name + ":" + value, PrintConst.UIS);
			}
			
			position = end + 1;
		}
	}
	
	public function copyFrom(source:Style):Void
	{
		for ( field in Reflect.fields(source) ) {
			if ( !Reflect.isFunction( Reflect.field(source, field) ) )
				Reflect.setField( this, field, Reflect.field(source, field) );
		}
	}
}