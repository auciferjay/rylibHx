package cn.royan.hl.services.messages;

import haxe.io.BytesInput;
import haxe.io.Bytes;

/**
 * ...
 * @author RoYan
 */

class Unserializer 
{
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
	 * Request	20;
	 */
	static public function unserialize( v:BytesInput ):Array<Dynamic>
	{
		var result:Array<Dynamic> = [];
		var input:BytesInput = v;
		var length:Int = 1;
		while(length > 0){
			result.push(unserializeInput(input));
			var rest:Bytes = input.readAll();
			length = rest.length;
			input = new BytesInput(rest);
		}
		return result;
	}
	
	function unserializeInput( v:BytesInput ):Dynamic
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
			case 20:
				return unserializeData(v);
		}
		return null;
	}
	
	function unserializeObject(v:BytesInput):Dynamic
	{
		var object = { };
		var len:Int = v.readInt16();
		for ( i in 0...len ) {
			var key:String = unserializeInput(v);
			var value:String = unserializeInput(v);
			Reflect.setField( object, key, value );
		}
		return object;
	}
	
	function unserializeArray(v:BytesInput):Array<Dynamic>
	{
		var array:Array<Dynamic> = [];
		var len:Int = v.readInt16();
		for ( i in 0...len ) {
			array.push(unserializeInput(v));
		}
		return array;
	}
	
	function unserializeData(v:BytesInput):Data
	{
		var code:Int = v.readInt16();
		var clss:Class<IBuilder<Dynamic>> = datalistManager.retrieveBuilder(code);
		var array:Array<Dynamic> = [];
		var len:Int = v.readInt16();
		for ( i in 0...len ) {
			array.push(unserializeInput(v));
		}
		var builder:IBuilder<Dynamic> = Type.createInstance( clss, [] );
			builder.build(array);
		return builder.getResult();
	}
}