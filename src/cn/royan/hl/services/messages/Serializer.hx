package cn.royan.hl.services.messages;

import haxe.io.BytesData;
import haxe.io.BytesOutput;
import haxe.io.Bytes;
import Type.ValueType;

/**
 * ...
 * 序列化
 * @author RoYan
 */
class Serializer 
{
	var bytesOutput:BytesOutput;
	public function new() 
	{
		bytesOutput = new BytesOutput();
	}
	
	/**
	 * 对对象进行序列化
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
	 * Date		9;
	 */
	public function serialize( v:Dynamic ):BytesOutput
	{
		switch( Type.typeof(v) ) {
			case TNull:
				bytesOutput.writeInt8(0);
			case TInt:
				bytesOutput.writeInt8(1);
				bytesOutput.writeInt16(v);
			case TFloat:
				bytesOutput.writeInt8(2);
				bytesOutput.writeDouble(v);
			case TBool:
				bytesOutput.writeInt8(3);
				bytesOutput.writeByte(v);
			case TClass(c):
				switch(#if neko Type.getClassName(c) #else c #end) {
					case #if neko "Array" #else cast Array #end:
						serializeArray(v);
					case #if neko "String" #else cast String #end:
						bytesOutput.writeInt8(7);
						serializeString(v);
					case #if neko "Date" #else cast Date #end:
						bytesOutput.writeInt8(9);
						bytesOutput.writeDouble(v);
				}
			case TObject:
				serializeObject(v);
			case TEnum(e):
				bytesOutput.writeInt8(6);
				serializeString(Std.string(v.tag));
			case TFunction:
				throw "Cannot serialize function";
			default:
				trace("default");
		}
		return bytesOutput;
	}
	
	function serializeString( v:String ):BytesOutput
	{
		var encodeString:String = StringTools.urlEncode(v);
		bytesOutput.writeInt16(encodeString.length);
		bytesOutput.writeString(encodeString);
		return bytesOutput;
	}
	
	function serializeObject( v:Dynamic ):BytesOutput
	{
		bytesOutput.writeInt8(5);
		bytesOutput.writeInt16(Reflect.fields(v).length);
		for ( f in Reflect.fields(v) ) {
			serialize(f);
			serialize(Reflect.field(v, f));
		}
		return bytesOutput;
	}
	
	function serializeArray( v:Array<Dynamic> ):BytesOutput
	{
		bytesOutput.writeInt8(8);
		bytesOutput.writeInt16(v.length);
		for ( i in v ) {
			serialize(i);
		}
		return bytesOutput;
	}
	
	public function getBytes():BytesData
	{
		return bytesOutput.getBytes().getData();
	}
}