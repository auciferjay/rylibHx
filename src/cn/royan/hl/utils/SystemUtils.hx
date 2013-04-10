package cn.royan.hl.utils;

import cn.royan.hl.bases.PoolMap;
import haxe.Log;
import haxe.PosInfos;
import haxe.Timer;

#if flash
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.errors.Error;
import flash.Lib;
#end

class SystemUtils 
{
	static inline var ukey:Array<String> = ["A", "B", "C", "D", "E", "F", "G", "H"];
	static inline var UID_CHARS:String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	
	static public var showDebug:Bool = false;
	
	static public function print(v:Dynamic, ?info:PosInfos):Void
	{
		if ( showDebug ) {
			if ( info == null )
				Log.trace(Timer.stamp() + "|[" + info.className + "][" + info.methodName + "]:" + v);
			else
				Lib.trace(Timer.stamp() + "|" + v);
		}
	}
	
	static public function arrayIndexOf(array:Array<Dynamic>, value:Dynamic):Int
	{
		for ( i in 0...array.length ) {
			if ( array[i] == value )
				return i;
		}
		return -1;
	}
	
	static public function replace(orgin:String, args:Array<Dynamic>):String
	{
		var i:Int;
		for( i in 1...args.length ){
			orgin = StringTools.replace(orgin, "{"+i+"}", args[i - 1]);
		}
		return orgin;
	}
		
	static public function createUniqueID():String
	{
		return random(8) + '-' + random(4) + '-' + random(4) + '-' + random(4) + '-' + random(12);
	}
	
	private static inline function random(?size:Int):String {
		
		if (size == null) size = 32;
		
		var nchars = UID_CHARS.length;
		var uid = new StringBuf();
		
		for (i in 0 ... size) {
			
			uid.add(UID_CHARS.charAt(Std.int(Math.random() * nchars)));
			
		}
		
		return uid.toString();
	}
		
	public static function readObject(object:Dynamic, index:Int = 0):Void
	{
		for ( prop in Reflect.fields(object) ) {
			var str:String = "";
			var i:Int = 0;
			for ( i in 0...index ) {
				str += " ";
			}
			str += "|+";
			SystemUtils.print('[Class SystemUtils]:'+ str +'Object['+prop+']:'+Reflect.field(object, prop) );
			readObject(Reflect.field(object, prop), index+1);
		}
	}
	#if flash
	static var __loaderContext:LoaderContext;
	public static function getLoaderContext():LoaderContext
	{
		if( __loaderContext == null )
			__loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			
		return __loaderContext;
	}
	
	public static function getInstanceByClassName(className:String, ?parameters:Array<Dynamic>):Dynamic
	{
		var InstanceClass:Class<Dynamic> = Type.resolveClass(className);
		if( parameters != null && parameters.length > 0 )
			return PoolMap.getInstanceByType( InstanceClass, parameters);
		
		return PoolMap.getInstanceByType(InstanceClass);
	}
	
	public static function copyToClipboard(value:String):Void
	{
		flash.system.System.setClipboard(value);
	}
	
	public static function gc():Void
	{
		try
		{
			new flash.net.LocalConnection().connect("use_for_gc");
			new flash.net.LocalConnection().connect("use_for_gc");
		}catch(e:Error){
			
		}
	}
	#end
}