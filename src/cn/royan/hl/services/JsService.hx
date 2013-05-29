package cn.royan.hl.services;

import cn.royan.hl.bases.DispatcherBase;
import cn.royan.hl.interfaces.services.IServiceBase;

import flash.external.ExternalInterface;

/**
 * ...
 * Js交互
 * @author RoYan
 */
class JsService extends DispatcherBase, implements IServiceBase
{
	var fun:String;
	var params:Array<Dynamic>;
	var serviceData:String;
	
	var callbacks:Dynamic;
	
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
		fun = url;
		params = cast extra;
	}
	
	/**
	 * 开始请求
	 */
	public function connect():Void
	{
		serviceData = ExternalInterface.call(fun, params);
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
		callbacks = value;
	}
	
	/**
	 * 获取回应值
	 * @return
	 */
	public function getData():Dynamic
	{
		return serviceData;
	}
	
	/**
	 * 获取交互状态
	 * @return
	 */
	public function getIsServicing():Bool
	{
		return false;
	}
	
	/**
	 * 销毁
	 */
	public function dispose():Void
	{
		
	}
}