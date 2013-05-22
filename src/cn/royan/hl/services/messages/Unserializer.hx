package cn.royan.hl.services.messages;

import haxe.io.Input;
import haxe.io.Bytes;

/**
 * ...
 * @author RoYan
 */

class Unserializer 
{
	public function new() {
	}
	/**
	 * 
	 * @param	v
	 * 
	 * TNull 	0
	 * TInt		1
	 * TFloat	2
	 * TBool	3
	 * TClass	4
	 * TObject	5
	 * TEnum	6
	 * String	7
	 * Array	8
	 * Date		9
	 */
	public function unserialize( v:Input ):Dynamic
	{
		var type:Int = v.readInt8();
		switch( type ) {
			case 0:
				return null;
			case 1:
				return v.readInt16();
			case 2:
				return v.readDouble();
			case 3:
				return v.readByte()!=0;
			case 4:
			case 5:
				return unserializeObject(v);
			case 6:
				var len:Int = v.readInt16();
				return v.readString(len);
			case 7:
				var len:Int = v.readInt16();
				var str:String = v.readString(len);
				return StringTools.urlDecode(str);
			case 8:
				return unserializeArray(v);
			case 9:
				return Date.fromTime(v.readDouble());
		}
		return null;
	}
	
	function unserializeObject(v:Input):Dynamic
	{
		var object = { };
		var len:Int = v.readInt16();
		for ( i in 0...len ) {
			var key:String = unserialize(v);
			var value:String = unserialize(v);
			Reflect.setField( object, key, value );
		}
		return object;
	}
	
	function unserializeArray(v:Input):Array<Dynamic>
	{
		var array:Array<Dynamic> = [];
		var len:Int = v.readInt16();
		for ( i in 0...len ) {
			array.push(unserialize(v));
		}
		return array;
	}
}