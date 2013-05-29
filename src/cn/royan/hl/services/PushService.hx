package cn.royan.hl.services;

import cn.royan.hl.bases.DispatcherBase;
import cn.royan.hl.interfaces.services.IServiceBase;

import flash.events.EventDispatcher;

/**
 * ...
 * 发送
 * @author RoYan
 */
class PushService extends DispatcherBase, implements IServiceBase 
{

	public function new() 
	{
		super();
	}
	
	/**
	 * 设置请求
	 * @param	url
	 * @param	extra
	 */
	public function sendRequest(url:String = '', extra:Dynamic = null):Void
	{
		
	}
	
	/**
	 * 开始请求
	 */
	public function connect():Void
	{
		
	}
	
	/**
	 * 关闭请求
	 */
	public function close():Void
	{
		
	}
	
	/**
	 * 设置毁掉函数
	 * @param	value	{done:..., doing:..., create:..., error:..., destroy:...}
	 */
	public function setCallbacks(value:Dynamic):Void
	{
		
	}
	
	/**
	 * 获取回应值
	 * @return
	 */
	public function getData():Dynamic
	{
		return null;
	}
	
	/**
	 * 获取交互状态
	 * @return
	 */
	public function getIsServicing():Bool
	{
		
	}
	
	/**
	 * 销毁
	 */
	public function dispose():Void
	{
		
	}
}