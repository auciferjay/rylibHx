package cn.royan.hl.utils;

import haxe.Log;
import haxe.PosInfos;
import haxe.Timer;

class SystemUtils 
{
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
}