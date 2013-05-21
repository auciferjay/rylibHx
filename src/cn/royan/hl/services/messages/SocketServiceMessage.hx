package cn.royan.hl.services.messages;

import cn.royan.hl.interfaces.services.IServiceMessageBase;
import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.Input;

/**
 * ...
 * @author RoYan
 */
class SocketServiceMessage extends Bytes, implements IServiceMessageBase
{
	var type:Int;
	var len:Int;
	var data:Bytes;
	
	public function new() {
		super(1, new BytesData());
	}
	
	public function writeMessageType(value:Int):Void
	{
		type = value;
		set(0, type);
	}
	
	public function writeMessageLen(value:Int):Void
	{
		len = value;
		length = 1 + 2 + len;
		set(1, len >> 8);
		set(2, len & 0xFF);
	}
	
	public function writeMessageData(value:BytesData):Void
	{
		data = Bytes.ofData(value);
		blit(3, data, 0, len);
	}
	
	public function writeMessageFromBytes(input:Input):Void
	{
		type = input.readByte();
		
		len = (input.readByte() << 8 ) + input.readByte();
		length = 1 + 2 + len;
		
		data = Bytes.alloc(len);
		input.readBytes(data, 0, len);
		
		set(0, type);
		set(1, len >> 8);
		set(2, len & 0xFF);
		blit(3, data, 0, len);
	}
	
	public function readMessageType():Int
	{
		if ( type == 0 )
			type = get(0);
		return type;
	}
	
	public function readMessageLen():Int
	{
		if ( len == 0 ) 
			len = (get(1) << 8) + get(2);
		return len;
	}
	
	public function readMessageData():BytesData
	{
		if ( data == null )
			data = sub(1, length - 1);
		return data.getData();
	}
	
	public function serialize():Void
	{
		
	}
	
	public function dispose():Void
	{
		type = 0;
		data = null;
	}
}