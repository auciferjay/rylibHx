package cn.royan.hl.events;

import flash.events.Event;

class DatasEvent extends Event
{
	static public inline var DATA_CHANGE:String 	= "data_change";
	static public inline var DATA_DOING:String		= "data_doing";
	static public inline var DATA_DONE:String		= "data_done";
	static public inline var DATA_CREATE:String		= "data_create";
	static public inline var DATA_DESTROY:String	= "data_destroy";
	static public inline var DATA_ERROR:String		= "data_error";
	
	var _t:String;
	var _d:Dynamic;
	var _b:Bool;
	var _c:Bool;

	public function new( t:String, ?d:Dynamic, ?b:Bool = false, ?c:Bool = false ) 
	{
		super( t, b, c );
		
		_t = t;
		_d = d;
		_b = b;
		_c = c;
	}
	
	override public function clone():Event 
	{
		return new DatasEvent( _t, _d, _b, _c );
	}
	
	public function getParams():Dynamic
	{
		return _d;
	}
	
}