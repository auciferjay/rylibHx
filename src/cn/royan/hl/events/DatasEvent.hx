package cn.royan.hl.events;

import flash.events.Event;

/**
 * ...
 * 基础事件
 * @author RoYan
 */
class DatasEvent extends Event
{
	/**
	 * 修改事件
	 */
	static public inline var DATA_CHANGE:String 	= "data_change";
	
	/**
	 * 进行事件
	 */
	static public inline var DATA_DOING:String		= "data_doing";
	
	/**
	 * 完成事件
	 */
	static public inline var DATA_DONE:String		= "data_done";
	
	/**
	 * 创建事件
	 */
	static public inline var DATA_CREATE:String		= "data_create";
	
	/**
	 * 摧毁事件
	 */
	static public inline var DATA_DESTROY:String	= "data_destroy";
	
	/**
	 * 错误事件
	 */
	static public inline var DATA_ERROR:String		= "data_error";
	
	var _t:String;
	var _d:Dynamic;
	var _b:Bool;
	var _c:Bool;
	
	/**
	 * 创建事件
	 * @param	t		事件类型
	 * @param	?d		事件数据
	 * @param	?b		是否冒泡
	 * @param	?c		是否可取消
	 */
	public function new( t:String, ?d:Dynamic, ?b:Bool = false, ?c:Bool = false ) 
	{
		super( t, b, c );
		
		_t = t;
		_d = d;
		_b = b;
		_c = c;
	}
	
	/**
	 * 复制事件
	 * @return
	 */
	override public function clone():Event 
	{
		return new DatasEvent( _t, _d, _b, _c );
	}
	
	/**
	 * 获取事件数据
	 * @return
	 */
	public function getParams():Dynamic
	{
		return _d;
	}
	
}