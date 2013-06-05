package cn.royan.hl.uis.starling.bases;

import cn.royan.hl.bases.TimerBase;
import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.interfaces.uis.IUiItemPlayBase;
import cn.royan.hl.uis.starling.InteractiveUiS;
import cn.royan.hl.utils.BitmapDataUtils;
import cn.royan.hl.utils.SystemUtils;

import starling.display.Image;
import starling.events.Event;
import starling.textures.Texture;

/**
 * ...
 * @author RoYan
 */
class UiSBmpdMovieClip extends InteractiveUiS, implements IUiItemPlayBase
{
	var bgTextures:Array<Texture>;
	var timer:TimerBase;
	var current:Int;
	var toFrame:Int;
	var frameRate:Int;
	var sequence:Bool;
	var loop:Bool;
	var autoPlay:Bool;
	var currentFrame:Image;
	
	public function new(texture:Array<Texture>, rate:Int = 10, auto:Bool = true)
	{
		super();
		
		bgTextures = texture;
		
		loop = true;
		autoPlay = auto;
		sequence = true;
		current = 1;
		toFrame = 1;
		frameRate = rate;
		
		timer = new TimerBase( Std.int( 1000 / frameRate ), timerHandler );
		
		setSize(Std.int(bgTextures[0].frame != null ? bgTextures[0].frame.width : bgTextures[0].width ), 
				Std.int(bgTextures[0].frame != null ? bgTextures[0].frame.height : bgTextures[0].height ));
		
		currentFrame = new Image(Texture.fromBitmapData(BitmapDataUtils.fromColors(Std.int(containerWidth), Std.int(containerHeight), [0x00000], [0], 1)));
		if ( bgTextures[current - 1] != null ) {
			currentFrame.texture = bgTextures[status];
		}
		addChild(currentFrame);
	}
	
	public function clone():UiSBmpdMovieClip
	{
		return new UiSBmpdMovieClip(bgTextures, frameRate, autoPlay);
	}
	
	public function getIn():Void
	{
		goFromTo(1, bgTextures.length);
	}

	public function getOut():Void
	{
		goFromTo(bgTextures.length, 1);
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
		
		currentFrame.texture = bgTextures[current - 1];
		currentFrame.scaleX = currentFrame.scaleY = getScale();
		
		timer.stop();
	}

	public function goFromTo(from:Int, to:Int):Void
	{
		SystemUtils.print(from + ":" + to, PrintConst.UIS);
		if( from == to ) return;
		
		loop = false;
		sequence = from <= to;
		current = from;
		toFrame = to;
		
		currentFrame.texture = bgTextures[current - 1];
		currentFrame.scaleX = currentFrame.scaleY = getScale();
		
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
	
	override private function addToStageHandler(evt:Event = null):Void 
	{
		super.addToStageHandler(evt);
		
		if ( autoPlay ) timer.start();
	}
	
	override private function removeFromStageHandler(evt:Event):Void 
	{
		super.removeFromStageHandler(evt);
		
		timer.stop();
	}
	
	function timerHandler():Void
	{
		if( sequence )
		{
			current++;
			if( current > bgTextures.length )
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
				if( loop ) current = bgTextures.length;
				else timer.stop();
			}
		}
		
		currentFrame.texture = bgTextures[current - 1];
		currentFrame.scaleX = currentFrame.scaleY = getScale();
		
		if( current == toFrame && !loop ){
			if( callbacks != null && callbacks.done != null ) callbacks.done(this);
			else dispatchEvent(new Event(DatasEvent.DATA_DONE));
			timer.stop();
		}
	}
	
	override public function draw():Void {}
	
	override public function dispose():Void 
	{
		super.dispose();
		
		if( bgTextures != null )
			while ( bgTextures.length > 0 ) {
				bgTextures.pop().dispose();
			}
		
		timer.stop();
	}
}