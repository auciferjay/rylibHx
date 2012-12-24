package src.cn.royan.hl.utils;

import haxe.Log;
import haxe.PosInfos;
import haxe.Timer;

class SystemUtils 
{
	static public inline function print(v:Dynamic, ?info:PosInfos):Void
	{
		Log.trace(Timer.stamp + "|[" + info.className + "][" + info.methodName+"]:"+v);
	}
}