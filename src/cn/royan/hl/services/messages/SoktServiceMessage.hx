package cn.royan.hl.services.messages;

import cn.royan.hl.bases.PoolMap;
import cn.royan.hl.interfaces.services.IServiceMessageBase;
import flash.utils.ByteArray;
import flash.utils.IDataInput;

/**
 * ...
 * @author RoYan
 */
class SoktServiceMessage extends ByteArray, implements IServiceMessageBase
{
	public static inline var CONNECT:Int 		= 0x10;
	public static inline var DISCONNECT:Int 	= 0x20;
	public static inline var PING:Int			= 0x30;
	
	var type:Int;
	var value:ByteArray;
	
	public function new()
	{
		super();
	}
	
	public function writeMessageType(type:Int):Void
	{
		this.type = type;
	}
	
	public function writeMessageValue(value:Dynamic):Void
	{
		this.value = cast( value );
		this.position = 1;
		
		this.writeByte(this.value.length >> 8);
		this.writeByte(this.value.length & 0xFF);
		
		this.writeBytes(value);
	}
	
	public function writeMessageFromBytes(input:IDataInput):Void
	{
		this.position = 0;
		this.type = input.readUnsignedByte();
		var length:Int = (input.readUnsignedByte() << 8) + input.readUnsignedByte();
		
		input.readBytes(this, 1, length);
		serialize();
	}
	
	public function readMessageType():Int
	{
		return 0;
	}
	
	public function readMessageValue():Dynamic
	{
		return value;
	}
	
	public function serialize():Void
	{
		this.position = 0;
		this.type = this.readUnsignedByte();
		this.value = PoolMap.getInstanceByType( ByteArray );
		this.readBytes(value);
	}
	
	public function dispose():Void
	{
		value.length = 0;
		PoolMap.disposeInstance(value);
	}
	
}