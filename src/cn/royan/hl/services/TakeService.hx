package cn.royan.hl.services;

import cn.royan.hl.interfaces.services.IServiceBase;
import cn.royan.hl.bases.CallBackBase;
import cn.royan.hl.bases.DispatcherBase;
import cn.royan.hl.utils.SystemUtils;
import cn.royan.hl.utils.BytesUtils;
import cn.royan.hl.events.DatasEvent;

#if flash
import flash.net.URLStream;
#else
import flash.net.URLRequest;
#end
import flash.net.URLVariables;
import flash.net.URLRequestMethod;
import flash.utils.ByteArray;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.events.EventDispatcher;
import flash.display.Loader;

class TakeService extends DispatcherBase, implements IServiceBase 
{
	#if flash
	var urlstream:URLStream;
	#else
	var urlstream:URLRequest;
	#end
	var urlvariable:URLVariables;
	var serviceData:ByteArray;
	var callbacks:CallBackBase;
	
	var swfLoader:Loader;
	
	public function new( param:Dynamic = null )
	{
		super();
		
		if( param != null )
			if ( Std.is(param, URLVariables) ) {
				urlvariable = param;
			} else if( Std.is(param, String) ) {
				urlvariable = new URLVariables( param );
			} else {
				urlvariable = new URLVariables();
				for( key in Reflect.fields(param) ){
					Reflect.setField(urlvariable, key, Reflect.field(param, key));
				}
			}
	}
		
	public function sendRequest(url:String='', extra:Dynamic=null):Void
	{
		urlrequest = new URLRequest(url);
		if( urlvariable != null ) urlrequest.data = urlvariable;
		urlrequest.method = extra == URLRequestMethod.POST?extra:URLRequestMethod.GET;
	}
		
	/**
	 * {done:Function,doing:Function,error:Function}
	 * 
	 */
	public function setCallbacks(value:CallBackBase):Void
	{
		callbacks = value;
	}
	
	public function connect():Void
	{
		close();
		
		if( serviceData != null ) serviceData.clear();
		else serviceData = new ByteArray();
		
		#if flash
		urlstream = new URLStream();
		#else
		urlstream = new URLRequest();
		#end
		urlstream.addEventListener(Event.COMPLETE, onComplete);
		urlstream.addEventListener(ProgressEvent.PROGRESS, onProgress);
		urlstream.addEventListener(IOErrorEvent.IO_ERROR, onError);
		urlstream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		urlstream.load(urlrequest);
	}
	
	public function close():Void
	{
		if( getIsServicing() ){
			urlstream.close();
		}
	}
	
	public function dispose():Void
	{
		urlstream.removeEventListener(Event.COMPLETE, onComplete);
		urlstream.removeEventListener(ProgressEvent.PROGRESS, onProgress);
		urlstream.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		urlstream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		
		urlstream = null;
		
		serviceData.length = 0;
		serviceData = null;
		urlrequest = null;
		urlvariable = null;
		callbacks = null;
			
		removeAllEventListeners();
	}
	
	public function getData():Dynamic
	{
		return serviceData;
	}
	
	public function getIsServicing():Bool
	{
		return urlstream != null && urlstream.connected;
	}
	
	function onComplete(evt:Event):Void
	{
		SystemUtils.print("[Class TakeService]:onComplete");
		
		#if flash
		urlstream.readBytes(serviceData, 0, urlstream.bytesAvailable);
		#else
		serviceData = urlstream.data;
		#end
		
		switch( BytesUtils.getType(serviceData) ){
			case "SWF":
				swfLoader = new Loader();
				swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderOnComplete);
				swfLoader.loadBytes(BytesUtils.simpleDecode(serviceData, "gameuzgame"), SystemUtils.getLoaderContext());
			case "XML":
			case "PNG":
			case "JPEG":
			case "GIF":
			case "BMP":
			case "FLV":
			case "MP3":
			default:
				if( callbacks != null && callbacks.done != null) callbacks.done(serviceData);
				else dispatchEvent(new DatasEvent(DatasEvent.DATA_DONE, serviceData));
		}
	}
	
	function loaderOnComplete(evt:Event):Void
	{
		if( callbacks != null && callbacks.done != null ) callbacks.done(swfLoader);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_DONE, swfLoader));
		
		swfLoader = null;
	}
	
	function onProgress(evt:ProgressEvent):Void
	{
		if( callbacks != null && callbacks.doing != null ) callbacks.doing({loaded:evt.bytesLoaded, total:evt.bytesTotal});
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_DOING, {loaded:evt.bytesLoaded, total:evt.bytesTotal}));
	}
	
	function onError(evt:IOErrorEvent):Void
	{
		SystemUtils.print("[Class TakeService]:onError:"+evt.type);
		if( callbacks != null && callbacks.error != null ) callbacks.error(evt.type);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_ERROR, evt.type));
		close();
	}
	
	function onSecurityError(evt:SecurityErrorEvent):Void
	{
		SystemUtils.print("[Class TakeService]:onSecurityError:"+evt.type);
		if( callbacks != null && callbacks.error != null ) callbacks.error(evt.type);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_ERROR, evt.type));
		close();
	}
}