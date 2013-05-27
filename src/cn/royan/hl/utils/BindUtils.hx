package cn.royan.hl.utils;

import cn.royan.hl.bases.DispatcherBase;
import cn.royan.hl.events.DatasEvent;

/**
 * ...
 * @author RoYan
 */
class BindUtils
{
	static public function toProperty(oa:DispatcherBase, fa:String, ob:DispatcherBase, fb:String):Void
	{
		var fun:Dynamic->Void = function(evt:DatasEvent):Void
		{
			if ( evt.getParams() == fa ) {
				Reflect.setField( ob, fb, Reflect.field(oa, fa) );
			}
		}
		oa.addEventListener(DatasEvent.DATA_CHANGE, fun );
	}
	
	static public function toFunction(oa:DispatcherBase, fa:String, call:Dynamic->Void):Void
	{
		var fun:Dynamic->Void = function(evt:DatasEvent):Void
		{
			if ( evt.getParams() == fa ) {
				call(Reflect.field(oa, fa));
			}
		}
			
		oa.addEventListener(DatasEvent.DATA_CHANGE, fun );
	}
}