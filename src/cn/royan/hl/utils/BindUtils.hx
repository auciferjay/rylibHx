package cn.royan.hl.utils;

import cn.royan.hl.bases.DispatcherBase;
import cn.royan.hl.events.DatasEvent;

/**
 * ...
 * 绑定工具类
 * @author RoYan
 */
class BindUtils
{
	/**
	 * 将A对象的A属性与B对象的B属性进行绑定
	 * @param	oa
	 * @param	fa
	 * @param	ob
	 * @param	fb
	 */
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
	
	/**
	 * 将A对象的A属性与函数进行绑定
	 * @param	oa
	 * @param	fa
	 * @param	call
	 */
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