package cn.royan.hl.services.messages;

import cn.royan.hl.interfaces.services.IServiceMessageBase;
import haxe.io.Bytes;
import haxe.io.Input;

/**
 * ...
 * @author RoYan
 */
class SoktServiceMessage extends Bytes, implements IServiceMessageBase
{
	var type:Int;
	var value:Bytes;
	
	public function writeMessageType(type:Int):Void
	{
		
	}
	
	public function writeMessageValue(value:Dynamic):Void
	{
		
	}
	
	public function writeMessageFromBytes(input:Input):Void
	{
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
		
	}
	
	public function dispose():Void
	{
		
	}
}