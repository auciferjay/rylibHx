package cn.royan.hl.services.messages;

import cn.royan.hl.interfaces.services.IServiceMessageBase;
import haxe.io.Bytes;
import haxe.io.Input;
/**
 * ...
 * @author RoYan
 */
class SoctServiceMessage extends Bytes, implements IServiceMessageBase
{
	var type:Int;
	var value:Bytes;
	
	public function new()
	{
		super();
	}
	
	public function writeMessageType(type:Int):Void
	{
		this.type = type;
		this.set(0, this.type)
	}
	
	public function writeMessageValue(value:Dynamic):Void
	{
		this.value = cast( value );
		
		this.set( 1, this.value.length >> 8 );
		this.set( 2, this.value.length & 0xFF );
		
		this.blit(3, value, 0, this.value.length);
	}
	
	public function writeMessageFromBytes(input:Input):Void
	{
		writeMessageType(input.readByte());
		
		var len:Int = (input.readByte() << 8) + input.readByte();
		
		this.set( 1, len >> 8 );
		this.set( 2, len & 0xFF );
		
		this.value = Bytes.alloc(len);
		
		input.readBytes(this.value, 0, len);
	}
	
	public function readMessageType():Int
	{
		return type;
	}
	
	public function readMessageValue():Dynamic
	{
		return value;
	}
	
	public function serialize():Void
	{
		
	}
	
	public function dispose():Void
	{
		value = null;
	}
}