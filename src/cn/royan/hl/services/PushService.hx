package cn.royan.hl.services;

import cn.royan.hl.interfaces.services.IServiceBase;

import flash.events.EventDispatcher;

class PushService extends EventDispatcher, implements IServiceBase 
{

	public function new()
	{
		super();
	}

	public function sendRequest(url:String='', extra:Dynamic=null) 
	{
		
	}

	public function setCallbacks(value:Dynamic):Void
	{

	}

	public function connect():Void
	{

	}

	public function close():Void
	{

	}

	public function getData():Dynamic
	{

	}

	public function getIsServicing():Bool
	{
		return false;
	}
	
	public function dispose():Void
	{
		
	}
}