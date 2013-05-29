package cn.royan.hl.interfaces.services;

import cn.royan.hl.interfaces.IDisposeBase;

import flash.events.IEventDispatcher;

/**
 * ...
 * 交互接口，继承自可销毁接口
 * <p>IServiceBase->(IDisposeBase, IEventDispatcher)</p>
 * @author RoYan
 */
interface IServiceBase implements IEventDispatcher, implements IDisposeBase
{
	/**
	 * 设置请求
	 * @param	url
	 * @param	extra
	 */
	function sendRequest(url:String = '', extra:Dynamic = null):Void;
	
	/**
	 * 开始请求
	 */
	function connect():Void;
	
	/**
	 * 关闭请求
	 */
	function close():Void;
	
	/**
	 * 设置毁掉函数
	 * @param	value	{done:..., doing:..., create:..., error:..., destroy:...}
	 */
	function setCallbacks(value:Dynamic):Void;
	
	/**
	 * 获取回应值
	 * @return
	 */
	function getData():Dynamic;
	
	/**
	 * 获取交互状态
	 * @return
	 */
	function getIsServicing():Bool;
}