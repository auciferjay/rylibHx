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
				Reflect.setField(this, name, value);
			}
			
			position = end + 1;
		}
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