package cn.royan.hl.services.messages;
import cn.royan.hl.bases.Dictionary;
import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.utils.SystemUtils;

/**
 * ...
 * @author RoYan
 */
class MessageManager
{
	static var messages:Dictionary = #if flash new Dictionary(); #else { }; #end
	
	static public inline function setMessageByType(type:Int, message:Class<SocketServiceMessage>):Bool
	{
		SystemUtils.print(type + ":" + message, PrintConst.SERVICES);
		if ( getMessageByType( type ) != null ) return false;
		Reflect.setField(messages, Std.string(type), message);
		return true;
	}
	
	static public inline function getMessageByType(type:Int):Class<SocketServiceMessage>
	{
		var cls:Class<SocketServiceMessage> = Reflect.field(messages, Std.string(type));
		SystemUtils.print(type + ":" + cls, PrintConst.SERVICES);
		return cls;
	}
}