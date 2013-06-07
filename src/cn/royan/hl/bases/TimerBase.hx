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
 * 基础计时器
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
	
	/**
	 * 计时是否开始
	 */
	public var isStart(default, null):Bool;
	
	/**
	 * 创建计时器
	 * @param	time	时间间隔（ms）
	 * @param	f		执行函数
	 * @param	loop	执行次数 0为无限次
	 */
	public function new(time:Float, f:Void->Void, loop:Int=0) 
	{
		delay = time;
		callFun = f;
		loopLimit = loop;
	}
	
	/**
	 * 开始计时
	 */
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
		current = delay;
		last = Std.int( Timer.stamp() * 1000 );
		begin = last;
		jumped = 0;
		
		timerlists.push(this);
	}
	
	/**
	 * 停止计时
	 */
	public function stop():Void
	{
		isStart = false;
		timerlists.remove(this);
	}
	
	/**
	 * 剩余时间
	 * @return
	 */
	public function remain():Float
	{
		return current;
	}
	
	/**
	 * 执行
	 */
	public function excute():Void
	{
		jumped++;
		if ( loopLimit != 0 && jumped > loopLimit ) {
			stop();
			return;
		}
		
		current = delay;
		callFun();
	}
	
	/**
	 * 获取执行次数
	 * @return
	 */
	public function needRender():Int
	{
		if ( !isStart ) return 0;
		
		current -= Std.int(Timer.stamp() * 1000 - last);

		last = Std.int( Timer.stamp() * 1000 );
		var total:Int = Std.int( (last - begin) / delay );
		return total - jumped;
	}
	
	/**
	 * 销毁
	 */
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