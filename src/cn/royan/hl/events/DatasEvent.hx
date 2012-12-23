package src.cn.royan.hl.events;

import flash.events.Event;

class DatasEvent extends Event
{
	static public inline var DATA_CHANGE:String 	= "data_change";
	static public inline var DATA_DOING:String		= "data_doing";
	static public inline var DATA_DONE:String		= "data_done";
	static public inline var DATA_CREATE:String		= "data_create";
	static public inline var DATA_DESTROY:String	= "data_destroy";
	static public inline var DATA_ERROR:String		= "data_error";
		
	public function new() 
	{
		
	}
	
}