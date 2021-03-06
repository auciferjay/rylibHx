package cn.royan.hl.bases;

import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.utils.SystemUtils;

import flash.events.EventDispatcher;

/**
 * ...
 * 基础事件驱动类，继承于EventDispatcher
 * <p>DispatcherBase->EventDispatcher</p>
 * @author RoYan
 */
class DispatcherBase extends EventDispatcher
{
	var evtListenerType:Array<String>;
	var evtListenerDirectory:Array<Dictionary>;
	
	/**
	 * 添加监听事件
	 * @param	type
	 * @param	listener
	 * @param	useCapture
	 * @param	priority
	 * @param	useWeakReference
	 */
	override public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool=false, priority:Int=0, useWeakReference:Bool=false):Void
	{
		SystemUtils.print(type+":"+listener, PrintConst.BASES);
		if ( evtListenerDirectory == null ) {
			evtListenerDirectory = [];
			evtListenerType = [];
		}
		var dic:Dictionary = #if flash new Dictionary(); #else {}; #end
		Reflect.setField(dic, type, listener);
		evtListenerDirectory.push( dic );
		evtListenerType.push( type );
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
	
	/**
	 * 移除监听事件
	 * @param	type
	 * @param	listener
	 * @param	useCapture
	 */
	override public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool=false):Void
	{
		SystemUtils.print(type+":"+listener, PrintConst.BASES);
		super.removeEventListener(type, listener, useCapture);
		if ( evtListenerDirectory != null ) {
			for ( i in 0...evtListenerDirectory.length ) {
				var dic:Dictionary = evtListenerDirectory[i];
				if ( Reflect.field(dic, type) == null ) {
					continue;
				}else {
					if ( Reflect.field(dic, type) != listener ) {
						continue;
					}else {
						evtListenerType.splice( i, 1 );
						evtListenerDirectory.splice( i, 1 );
						Reflect.deleteField( dic, type );
						dic = null;
						break;
					}
				}
			}
		}
	}
	
	/**
	 * 删除所有监听事件
	 */
	public function removeAllEventListeners():Void
	{
		if ( evtListenerType == null || evtListenerType.length == 0)
			return;
		
		for ( i in 0...evtListenerType.length)
		{
			var type:String = evtListenerType[i];
			var dic:Dictionary = evtListenerDirectory[i];
			if ( dic == null || Reflect.field(dic, type) == null ) {
				continue;
			}else {
				var fun:Dynamic->Void = Reflect.field(dic, type);
				removeEventListener( type, fun );
			}
		}
	}
}