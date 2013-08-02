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
import flash.Lib;

/**
 * ...
 * 系统工具类
 * @author RoYan
 */
class SystemUtils 
{
	static inline var ukey:Array<String> = ["A", "B", "C", "D", "E", "F", "G", "H"];
	static inline var UID_CHARS:String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	
	static public var showDebug:Int = -1;
	
	/**
	 * 打印调试代码
	 * @param	v
	 * @param	level
	 * @param	?info
	 */
	static public function print(v:Dynamic, level:Int=0,?info:PosInfos):Void
	{
		if ( showDebug == level || showDebug == 0 || level == 0) {
			#if !swc
			if ( info != null )
				Log.trace(Timer.stamp() + "|[" + info.className + "][" + info.methodName + "]:" + v);
			else
			#end
				Lib.trace(Timer.stamp() + "|" + v);
		}
	}
	
	/**
	 * 查找索引
	 * @param	array
	 * @param	value
	 * @return
	 */
	static public function arrayIndexOf(array:Array<Dynamic>, value:Dynamic):Int
	{
		for ( i in 0...array.length ) {
			if ( array[i] == value )
				return i;
		}
		return -1;
	}
	
	/**
	 * 替换
	 * @param	orgin
	 * @param	args
	 * @return
	 */
	static public function replace(orgin:String, args:Array<Dynamic>):String
	{
		for( i in 0...args.length ){
			orgin = StringTools.replace(orgin, "{" + (i+1) + "}", args[i]);
		}
		return orgin;
	}
	
	/**
	 * 创建唯一值
	 * @return
	 */
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
	
	/**
	 * 读取对象
	 * @param	object
	 * @param	index
	 */
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
	/**
	 * 获取加载配置
	 * @return
	 */
	public static function getLoaderContext():LoaderContext
	{
		if ( __loaderContext == null ) {
			__loaderContext = new LoaderContext(false);
			/* 加载到子域(模块) */
			//__loaderContext.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
			/* 加载到同域(共享库) */
			__loaderContext.applicationDomain = ApplicationDomain.currentDomain;
			/* 加载到新域(独立运行的程序或模块) */
			//__loaderContext.applicationDomain = new ApplicationDomain();
		}
			
		return __loaderContext;
	}
	
	/**
	 * 创建对象
	 * @param	className
	 * @param	?parameters
	 * @return
	 */
	public static function getInstanceByClassName(className:String, ?parameters:Array<Dynamic>):Dynamic
	{
		var InstanceClass:Class<Dynamic> = Type.resolveClass(className);
		if( parameters != null && parameters.length > 0 )
			return PoolMap.getInstanceByType( InstanceClass, parameters);
		
		return PoolMap.getInstanceByType(InstanceClass);
	}
	
	/**
	 * 复制
	 * @param	value
	 */
	public static function copyToClipboard(value:String):Void
	{
		flash.system.System.setClipboard(value);
	}
	
	/**
	 * 内存回收
	 */
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