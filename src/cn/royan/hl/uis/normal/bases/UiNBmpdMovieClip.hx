package cn.royan.hl.uis.normal.bases;

import cn.royan.hl.interfaces.uis.IUiItemPlayBase;
import cn.royan.hl.bases.TimerBase;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.uis.normal.InteractiveUiN;
import cn.royan.hl.uis.normal.UninteractiveUiN;
import cn.royan.hl.uis.sparrow.Sparrow;
import cn.royan.hl.utils.SystemUtils;

import flash.events.Event;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.errors.Error;

class UiNBmpdMovieClip extends InteractiveUiN, implements IUiItemPlayBase
{
	//properties
	var bgTextures:Array<Sparrow>;
	var timer:TimerBase;
	var current:Int;
	var total:Int;
	var toFrame:Int;
	var frameRate:Int;
	var sequence:Bool;
	var loop:Bool;
	var autoPlay:Bool;
	var currentFrame:BitmapData;
	
	//Constructor
	public function new(texture:Dynamic, rate:Int = 10, auto:Bool = true, row:Int = 1, column:Int = 1, frames:Int = 1) 
	{
		super(Std.is( texture, Sparrow )?cast( texture, Sparrow ):null);
		
		var bmpd:BitmapData;
		var frameunit:UninteractiveUiN;
		bgTextures = [];
		
		if( Std.is( texture, Sparrow ) ){
			total = frames;
			
			drawTextures();
		}else if( Std.is( texture, Array ) ){
			total = cast( texture ).length;
			
			bgTextures = cast(texture);
			
			setSize(Std.int(bgTextures[0].regin.width), Std.int(bgTextures[0].regin.height));
		}else{
			throw new Error("texture is wrong type(BitmapData or Vector.<BitmapData>)");
		}
		
		loop = true;
		autoPlay = auto;
		sequence = true;
		current = 1;
		toFrame = 1;
		frameRate = rate;
		
		timer = new TimerBase( Std.int( 1000 / frameRate ), timerHandler );
		
		currentFrame = new BitmapData(containerWidth, containerHeight, true, 0x00000000);
		
		if( bgTextures[current-1] != null )
			currentFrame.copyPixels(bgTextures[current - 1].bitmapdata, bgTextures[current - 1].regin, new Point());
		
		addChild(new Bitmap(currentFrame));
	}
	
	function drawTextures():Void
	{
		var frameWidth:Int = Std.int(bgTexture.regin.width / total);
		var frameHeight:Int = Std.int(bgTexture.regin.height);
		
		if ( bgTexture.frame != null ) {
			frameWidth = Std.int(bgTexture.frame.width / total);
			//frameHeight = Std.int(bgTexture.frame.height);
		}
		
		var i:Int;
		var rectangle:Rectangle = new Rectangle();
			rectangle.width = frameWidth + (bgTexture.frame!=null?bgTexture.frame.x:0);
			rectangle.height = frameHeight;// + (bgTexture.frame != null?bgTexture.frame.y:0);
			
		var point:Point = new Point();
		var curRow:Int;
		var curCol:Int;
		
		for ( i in 0...total ) {
			curRow = Std.int(i % total);
			curCol = Std.int(i / total);
			
			rectangle.x = curRow * frameWidth + bgTexture.regin.x;
			rectangle.y = curCol * frameHeight + bgTexture.regin.y;
			
			var bmpd:Sparrow = Sparrow.fromSparrow(bgTexture, rectangle.clone());
			
			bgTextures[i] = bmpd;
			
			//addChild(new Bitmap(bgTextures[i])).x = i * 60 + 60;
		}
		
		setSize(frameWidth, frameHeight);
		
		rectangle = null;
		point = null;
	}
	
	public function clone():UiNBmpdMovieClip
	{
		return new UiNBmpdMovieClip(bgTextures, frameRate, autoPlay);
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
		goFromTo(current, frame);
	}

	public function jumpTo(frame:Int):Void
	{
		loop = false;
		current = frame;
		currentFrame.copyPixels(bgTextures[current - 1].bitmapdata, bgTextures[current - 1].regin, new Point());
	}

	public function goFromTo(from:Int, to:Int):Void
	{
		if( from == to ) return;
		
		loop = false;
		sequence = from <= to;
		current = from;
		toFrame = to;
		
		currentFrame.copyPixels(bgTextures[current - 1].bitmapdata, bgTextures[current - 1].regin, new Point());
		
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
	
	//Protected methods
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
		
		currentFrame.copyPixels(bgTextures[current - 1].bitmapdata, bgTextures[current - 1].regin, new Point());
		
		if( current == toFrame && !loop ){
			if( callbacks != null && callbacks.done != null ) callbacks.done(this);
			else dispatchEvent(new DatasEvent(DatasEvent.DATA_DONE));
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