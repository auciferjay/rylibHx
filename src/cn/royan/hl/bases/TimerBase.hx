package cn.royan.hl.bases;

import cn.royan.hl.interfaces.IDisposeBase;

import haxe.Timer;

class TimerBase implements IDisposeBase
{
	static private var timerlists:Array<TimerBase> = [];
	static private var timer:Timer;
	static private var timerNumber:Int;
	
	static public inline var TIMERBASE_DELAY:Int = 10;
	
	var delay:Int;
	var callFun:Void->Void;
	var isStart:Bool;
	var last:Int;
	var current:Int;
	
	public function new(time:Int, f:Void->Void) 
	{
		delay = time;
		callFun = f;
		
		timerlists.push(this);
	}
	
	public function start():Void
	{
		if ( timer == Null ) {
			timerNumber = 0;
			timer = Timer(10);
			timer.run = timerHandler;
		}
		
		isStart = true;
		last = Timer.stamp();
		current = delay;
		
		timerNumber++;
	}
	
	public function stop():Void
	{
		isStart = false;
		
		timerNumber--;
		if ( timerNumber <= 0 )
			timer.stop();
	}
	
	public function callMethod():Void->Void
	{
		return callFun;
	}
	
	public function needRender():Boolean
	{
		if( !isStart ) return false;
		current -= (Timer.stamp() - last);
		last = Timer.stamp();
		var isInit:Bool = current < TIMERBASE_DELAY;
		if( isInit ) current = delay;
		return isStart && isInit;
	}
	
	public function dispose():Void
	{
		timerlists.remove(this);
		if ( isStart ) {
			isStart = false;
			timerNumber--;
		}
		if ( timerNumber <= 0 )
			timer.stop();
	}
	
	private static function timerHandler():Void
	{
		for ( time in timerlists ) {
			if ( time.needRender() ) {
				time.callMethod()();
			}
		}
	}
}