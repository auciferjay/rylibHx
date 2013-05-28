package cn.royan.hl.services;

import cn.royan.hl.bases.WeakMap;
import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.interfaces.services.IServiceBase;
import cn.royan.hl.bases.DispatcherBase;
import cn.royan.hl.utils.BitmapDataUtils;
import cn.royan.hl.utils.SystemUtils;
import cn.royan.hl.utils.BytesUtils;
import cn.royan.hl.events.DatasEvent;

import flash.net.URLLoader;
#if flash
import flash.net.URLStream;
#end
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.net.URLRequestMethod;
import flash.utils.ByteArray;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.events.EventDispatcher;
import flash.display.Loader;

/**
 * ...
 * @author RoYan
 */
class TakeService extends DispatcherBase, implements IServiceBase 
{
	#if flash
	var urlstream:URLStream;
	#else
	var urlstream:URLLoader;
	#end
	var urlrequest:URLRequest;
	var urlvariable:URLVariables;
	var serviceData:ByteArray;
	var callbacks:Dynamic;
	
	var weakMap:WeakMap;
	
	var swfLoader:Loader;
	var isLoading:Bool;
	
	public function new( param:Dynamic = null )
	{
		super();
		
		weakMap = WeakMap.getInstance();
		
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
		SystemUtils.print(url+":"+extra, PrintConst.SERVICES);
		urlrequest = new URLRequest(url);
		if( urlvariable != null ) urlrequest.data = urlvariable;
		urlrequest.method = extra == URLRequestMethod.POST?extra:URLRequestMethod.GET;
	}
		
	/**
	 * {done:Function,doing:Function,error:Function}
	 * 
	 */
	public function setCallbacks(value:Dynamic):Void
	{
		callbacks = value;
	}
	
	public function connect():Void
	{
		close();
		
		if ( weakMap.containKey(urlrequest.url) ) {
			if( callbacks != null && callbacks.done != null) callbacks.done( getData() );
			else dispatchEvent(new DatasEvent(DatasEvent.DATA_DONE, getData()));
			return;
		}
		
		serviceData = new ByteArray();
		
		isLoading = true;
		
		var uri:String = urlrequest.url.substr(0, 7);
		
		#if !flash
		if ( uri == "http://" || uri == "https:/" ) {
			urlstream = new URLLoader();
		#else
			urlstream = new URLStream();
		#end
			
			urlstream.addEventListener(Event.COMPLETE, onComplete);
			urlstream.addEventListener(ProgressEvent.PROGRESS, onProgress);
			urlstream.addEventListener(IOErrorEvent.IO_ERROR, onError);
			urlstream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			urlstream.load(urlrequest);
		#if !flash
		}else {
			var asset:Dynamic = ApplicationMain.getAsset(urlrequest.url);
			if ( asset == null ) {
				SystemUtils.print("[Class TakeService]:onError:"+urlrequest.url+" IOERROR", PrintConst.SERVICES);
				
				if( callbacks != null && callbacks.error != null ) callbacks.error("IOERROR");
				else dispatchEvent(new DatasEvent(DatasEvent.DATA_ERROR, "IOERROR"));
				close();
				return;
			}
			
			SystemUtils.print("[Class TakeService]:onComplete", PrintConst.SERVICES);
			isLoading = false;
			if( Std.is( asset, ByteArray ) )
				analyze();
			else {
				if( callbacks != null && callbacks.done != null) callbacks.done(asset);
				else dispatchEvent(new DatasEvent(DatasEvent.DATA_DONE, asset));	
			}
		}
		#end
	}
	
	public function close():Void
	{
		if ( getIsServicing() ) {
			urlstream.close();
		}
		
		isLoading = false;
	}
	
	public function dispose():Void
	{
		if ( urlstream != null ) {
			urlstream.removeEventListener(Event.COMPLETE, onComplete);
			urlstream.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			urlstream.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			urlstream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		
		urlstream = null;

		serviceData = null;
		urlrequest = null;
		urlvariable = null;
		callbacks = null;
		swfLoader = null;
		isLoading = false;
		
		removeAllEventListeners();
	}
	
	public function getData():Dynamic
	{
		//if (BytesUtils.isSWF(BytesUtils.simpleDecode(serviceData, "gameuzgame"))) {
		//	return swfLoader;
		//}
		return weakMap.getValue(urlrequest.url);//serviceData;
	}
	
	public function getIsServicing():Bool
	{
		return urlstream != null && isLoading;
	}
	
	function onComplete(evt:Event):Void
	{
		SystemUtils.print("[Class TakeService]:onComplete", PrintConst.SERVICES);
		
		isLoading = false;
		
		#if flash
		urlstream.readBytes( serviceData, 0, urlstream.bytesAvailable );
		#else
		serviceData = urlstream.data;
		#end
		
		analyze();
	}
	
	function analyze():Void
	{
		switch( BytesUtils.getType(serviceData) ){
			case "SWF","PNG","JPEG","GIF","BMP":
				swfLoader = new Loader();
				swfLoader.name = urlrequest.url;
				swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderOnComplete);
				swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
				swfLoader.loadBytes(BytesUtils.simpleDecode(serviceData, "gameuzgame")#if flash, SystemUtils.getLoaderContext() #end);
			/*case "XML":
			case "FLV":
			case "MP3":*/
			default:
				weakMap.set( urlrequest.url, serviceData );
				if( callbacks != null && callbacks.done != null) callbacks.done( getData() );
				else dispatchEvent(new DatasEvent(DatasEvent.DATA_DONE, getData()));
		}
	}
	
	function loaderOnComplete(evt:Event):Void
	{
		SystemUtils.print("[Class TakeService]:DISPLAYLoadOnComplete", PrintConst.SERVICES);
		switch( BytesUtils.getType(serviceData) ) {
			case "SWF":
				weakMap.set( urlrequest.url, swfLoader );
				if( callbacks != null && callbacks.done != null ) callbacks.done( getData() );
				else dispatchEvent(new DatasEvent(DatasEvent.DATA_DONE, getData()));
				
				swfLoader = null;
			default:
				weakMap.set( urlrequest.url, BitmapDataUtils.fromDisplayObject(swfLoader));
				if( callbacks != null && callbacks.done != null ) callbacks.done( getData() );
				else dispatchEvent(new DatasEvent(DatasEvent.DATA_DONE, getData()));
		}
	}
	
	function onProgress(evt:ProgressEvent):Void
	{
		SystemUtils.print("[Class TakeService]:onProgress", PrintConst.SERVICES);
		if( callbacks != null && callbacks.doing != null ) callbacks.doing({loaded:evt.bytesLoaded, total:evt.bytesTotal});
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_DOING, {loaded:evt.bytesLoaded, total:evt.bytesTotal}));
	}
	
	function onError(evt:IOErrorEvent):Void
	{
		SystemUtils.print("[Class TakeService]:onError:"+evt.type+"->"+urlrequest.url, PrintConst.SERVICES);
		if( callbacks != null && callbacks.error != null ) callbacks.error(evt.type);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_ERROR, evt.type));
		close();
	}
	
	function onSecurityError(evt:SecurityErrorEvent):Void
	{
		SystemUtils.print("[Class TakeService]:onSecurityError:"+evt.type+"->"+urlrequest.url, PrintConst.SERVICES);
		if( callbacks != null && callbacks.error != null ) callbacks.error(evt.type);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_ERROR, evt.type));
		close();
	}
}