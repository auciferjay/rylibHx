package cn.royan.hl.services.messages;

import cn.royan.hl.bases.Dictionary;
import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.utils.SystemUtils;

/**
 * ...
 * 信息管理类
 * @author RoYan
 */
class MessageManager
{
	static var messages:Dictionary = #if flash new Dictionary(); #else { }; #end
	
	/**
	 * 注册消息
	 * @param	type		键值
	 * @param	message		消息类型
	 */
	static public inline function setMessageByType(type:Int, message:Class<SocketServiceMessage>):Void
	{
		SystemUtils.print(type + ":" + Type.getClassName(message), PrintConst.SERVICES);
		Reflect.setField(messages, Std.string(type), message);
	}
	
	/**
	 * 获取消息
	 * @param	type		键值
	 * @return
	 */
	static public inline function getMessageByType(type:Int):Class<SocketServiceMessage>
	{
		var cls:Class<SocketServiceMessage> = Reflect.field(messages, Std.string(type));
		SystemUtils.print(type + ":" + Type.getClassName(cls), PrintConst.SERVICES);
		return cls;
	}
}