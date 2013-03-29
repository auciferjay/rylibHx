package cn.royan.hl.utils;

import cn.royan.hl.bases.PoolMap;
import haxe.Log;
import haxe.PosInfos;
import haxe.Timer;

#if flash
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.errors.Error;
#end

class SystemUtils 
{
	static inline var ukey:Array<String> = ["A", "B", "C", "D", "E", "F", "G", "H"];
	
	static public function print(v:Dynamic, ?info:PosInfos):Void
	{
		Log.trace(Timer.stamp + "|[" + info.className + "][" + info.methodName+"]:"+v);
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
		var uid:String = "";
		var time:Int = Std.int(Date.now().getTime());
		var timecut:Int = Std.int(time & 0xFFF);
		var i:Int;
		var sum:String = "";
		for ( i in 0...12 ) {
			sum = (time & 7) + sum;
			time >>= 3;
		}
		for ( i in 0...12 ) {
			uid = uid + ukey[Std.parseInt(sum.substr(i,1))];
		}
		return uid + "-" + timecut;
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