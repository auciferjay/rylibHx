package cn.royan.hl.bases;

import cn.royan.hl.interfaces.IDisposeBase;
import cn.royan.hl.utils.SystemUtils;

import haxe.Timer;
#if ( cpp || neko )
import nme.Lib;
import nme.events.Event;
#end

/**
 * ...
 * @author RoYan
 */
class TimerBase implements IDisposeBase
{
	static private inline var TIMERBASE_DELAY:Int = 10;
	#if ( flash || js )
	static private var timer:Timer;
	#else
	static private var timer:Timer;
	#end
	static private var timerNumber:Int = 0;
	static private var timerlists:Array<TimerBase> = [];
	
	var callFun:Void->Void;
	var delay:Float;
	var last:Int;
	var begin:Int;
	var current:Float;
	var jumped:Int;
	var loopLimit:Int;
	
	public var isStart(default, null):Bool;
	
	public function new(time:Float, f:Void->Void, loop:Int=0) 
	{
		delay = time;
		callFun = f;
		loopLimit = loop;
	}
	
	public function start():Void
	{
		if ( timer == null ) {
			timerNumber = 0;
			#if ( flash || js )
			timer = new Timer(10);
			timer.run = timerHandler;
			#else
			Lib.current.addEventListener(Event.ENTER_FRAME, timerHandler);
			#end
		}
		
		isStart = true;
		current = delay;//Std.int( Timer.stamp() * 1000 );
		last = Std.int( Timer.stamp() * 1000 );
		begin = last;
		jumped = 0;
		
		timerlists.push(this);
	}
	
	public function stop():Void
	{
		isStart = false;
		timerlists.remove(this);
	}

	public function remain():Float
	{
		return current;
	}
	
	public function excute():Void
	{
		jumped++;

		current = delay;
		callFun();
	}
	
	public function needRender():Int
	{
		if ( !isStart ) return 0;
		
		current -= Std.int(Timer.stamp() * 1000 - last);

		last = Std.int( Timer.stamp() * 1000 );
		var total:Int = Std.int( (last - begin) / delay );
		if ( loopLimit != 0 && total >= loopLimit ) {
			stop();
		}
		return total - jumped;
	}
	
	public function dispose():Void
	{
		timerlists.remove(this);
		#if ( flash || js ) 
		if ( timerNumber <= 0 )
			timer.stop(); 
		#else
			Lib.current.removeEventListener(Event.ENTER_FRAME, timerHandler);
		#end
	}
	
	private static function timerHandler(#if(cpp || neko) evt:Event #end):Void
	{
		for ( time in timerlists ) {
			var len:Int = time.needRender();
			for ( i in 0...len ) {
				time.excute();
			}
		}
	}
}