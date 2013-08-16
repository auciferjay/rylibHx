package cn.royan.hl.uis.graphs.bases;

import cn.royan.hl.bases.TimerBase;
import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.uis.graphs.InteractiveUiG;
import cn.royan.hl.uis.sparrow.Sparrow;
import cn.royan.hl.utils.SystemUtils;

/**
 * ...
 * @author RoYan
 */
class UiGBmpdMovieClip extends InteractiveUiG
{
	var bgTextures:Array<Sparrow>;
	
	var timer:TimerBase;
	
	var current:Int;
	var toFrame:Int;
	var total:Int;
	
	var sequence:Bool;
	var loop:Bool;
	var autoPlay:Bool;
	
	public function new(texture:Array<Sparrow>, fr:Int) 
	{
		super();
		
		timer = new TimerBase( Std.int( 1000 / fr ), timerHandler );
	}
	
	public function getIn():Void
	{
		goFromTo(1, total);
	}

	public function getOut():Void
	{
		goFromTo(total, 1);
	}

	public function goTo(frame:Int):Void
	{
		SystemUtils.print(current+":"+frame, PrintConst.UIS);
		goFromTo(current, frame);
	}

	public function jumpTo(frame:Int):Void
	{
		SystemUtils.print(frame, PrintConst.UIS);
		loop = false;
		current = frame;
		
		updateDisplayList();
	}

	public function goFromTo(from:Int, to:Int):Void
	{
		SystemUtils.print(from+":"+to, PrintConst.UIS);
		if( from == to ) return;
		
		loop = false;
		sequence = from <= to;
		current = from;
		toFrame = to;
		
		updateDisplayList();
		
		timer.start();
	}
	
	public function play():Void
	{
		timer.start();
	}
	
	public function stop():Void
	{
		timer.stop();
	}
	
	function timerHandler():Void
	{
		if( sequence )
		{
			current++;
			if( current > total )
			{
				if( loop ) current = 1;
				else timer.stop();
			}
		}
		else
		{
			current--;
			if( current < 1 )
			{
				if( loop ) current = total;
				else timer.stop();
			}
		}
		
		if( current == toFrame && !loop ){
			if( callbacks != null && callbacks.done != null ) callbacks.done(this);
			timer.stop();
		}
		
		updateDisplayList();
	}
	
	/**
	 * 获取当前材质
	 * @return
	 */
	override public function getTexture():Dynamic
	{
		return bgTextures[current];
	}
}