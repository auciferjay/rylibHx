package cn.royan.hl.bases;

import cn.royan.hl.interfaces.IDisposeBase;
import cn.royan.hl.utils.SystemUtils;

import haxe.Timer;
#if cpp
import cpp.vm.Thread;
#elseif neko
import neko.vm.Thread;
#end

class TimerBase implements IDisposeBase
{
	static private inline var TIMERBASE_DELAY:Int = 10;
	#if ( flash || js )
	static private var timer:Timer;
	#elseif ( cpp || neko)
	static private var timer:Thread;
	#end
	static private var timerNumber:Int;
	static private var timerlists:Array<TimerBase> = [];
	
	var callFun:Void->Void;
	var delay:Int;
	var last:Int;
	var begin:Int;
	var jumped:Int;
	
	public var isStart(default, null):Bool;
	
	public function new(time:Int, f:Void->Void) 
	{
		delay = time;
		callFun = f;
		
		timerlists.push(this);
	}
	
	public function start():Void
	{
		if ( timer == null ) {
			timerNumber = 0;
			#if ( flash || js )
			timer = new Timer(10);
			timer.run = timerHandler;
			#else
			//timer = Thread.create(threadHandler);
			#end
		}
		
		if( !isStart ) timerNumber++;
		isStart = true;
		last = Std.int( Timer.stamp() * 1000 );
		begin = last;
	}
	
	public function stop():Void
	{
		if( isStart ) timerNumber--;
		isStart = false;
	}
	
	public function excute():Void
	{
		jumped++;
		callFun();
	}
	
	public function needRender():Int
	{
		if ( !isStart ) return 0;
		
		last = Std.int( Timer.stamp() * 1000 );
			
		var total:Int = Std.int( (last - begin) / delay );
			
		return total - jumped;
	}
	
	public function dispose():Void
	{
		timerlists.remove(this);
		if ( isStart ) {
			isStart = false;
			timerNumber--;
		}
		#if ( flash || js ) 
		if ( timerNumber <= 0 )
			timer.stop(); 
		#end
	}
	
	private static function timerHandler():Void
	{
		if ( timerNumber <= 0 ) return;
		for ( time in timerlists ) {
			var len:Int = time.needRender();
			for ( i in 0...len ) {
				time.excute();
			}
		}
	}
	#if ( cpp || neko )
	private static function threadHandler():Void
	{
		while(true){
			try{
				Sys.sleep(.01);
				timerHandler();
			}catch(e:Dynamic){
				SystemUtils.print(e);
			}
		}
	}
	#end
}