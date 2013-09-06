package cn.royan.hl.uis.graphs.bases;

import cn.royan.hl.bases.TimerBase;
import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.uis.graphs.UiGBmpdSprite;
import cn.royan.hl.uis.sparrow.Sparrow;
import cn.royan.hl.utils.SystemUtils;

/**
 * ...
 * @author RoYan
 */
class UiGBmpdMovieClip extends UiGBmpdSprite
{
	var textures:Array<Sparrow>;
	
	var timer:TimerBase;
	
	var current:Int;
	var toFrame:Int;
	var total:Int;
	
	var loop:Bool;
	var autoPlay:Bool;
	var sequence:Bool;
	
	public function new( sparrows:Array<Sparrow>, fps:Int ) 
	{
		super(sparrows[0]);
		
		current = 0;
		toFrame = total = sparrows.length;
		loop 	= true;
		sequence = true;
		autoPlay = true;
		
		textures = sparrows;
		if ( textures[0].frame != null ) setSize(Std.int(textures[0].frame.width), Std.int(textures[0].frame.height));
		else setSize(Std.int(textures[0].regin.width), Std.int(textures[0].regin.height));
		
		timer = new TimerBase( Std.int( 1000 / fps ), timerHandler );
	}
	
	/**
	 * 顺序播放
	 */
	public function getIn():Void
	{
		goFromTo(0, total);
	}
	
	/**
	 * 倒叙播放
	 */
	public function getOut():Void
	{
		goFromTo(total, 0);
	}

	/**
	 * 播放到..
	 * @param	frame
	 */
	public function goTo(frame:Int):Void
	{
		SystemUtils.print(current+":"+frame, PrintConst.UIS);
		goFromTo(current, frame);
	}
	
	/**
	 * 跳至...
	 * @param	frame
	 */
	public function jumpTo(frame:Int):Void
	{
		SystemUtils.print(frame, PrintConst.UIS);
		loop = false;
		current = frame;
		
		updateDisplayList();
	}

	/**
	 * 从某一帧开始播放至另一帧
	 * @param	from
	 * @param	to
	 */
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
	
	/**
	 * 播放
	 */
	public function play():Void
	{
		timer.start();
	}
	
	/**
	 * 停止
	 */
	public function stop():Void
	{
		timer.stop();
		current = 0;
	}
	
	/**
	 * 暂停
	 */
	public function pause():Void
	{
		timer.stop();
	}
	
	public function nextFrame():Void
	{
		current++;
		if( current > total - 1 )
		{
			current = 0;
		}
		updateDisplayList();
	}
	
	public function prevFrame():Void
	{
		current--;
		if( current < 0 )
		{
			current = total - 1;
		}
		updateDisplayList();
	}
	
	/**
	 * 获取当前材质
	 * @return
	 */
	override public function getTexture():Dynamic
	{
		return textures[current];
	}
	
	function timerHandler():Void
	{
		if( sequence )
		{
			current++;
			if( current > total - 1 )
			{
				if( loop ) current = 0;
				else timer.stop();
			}
		}
		else
		{
			current--;
			if( current < 0 )
			{
				if( loop ) current = total - 1;
				else timer.stop();
			}
		}
		
		if( current == toFrame - 1 && !loop ){
			if( callbacks != null && callbacks.done != null ) callbacks.done(this);
			timer.stop();
		}
		
		updateDisplayList();
	}
}