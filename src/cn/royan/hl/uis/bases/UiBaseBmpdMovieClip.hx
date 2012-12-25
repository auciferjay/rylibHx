package cn.royan.hl.uis.bases;

import cn.royan.hl.bases.TimerBase;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.interfaces.uis.IUiPlayBase;
import cn.royan.hl.uis.InteractiveUiBase;
import cn.royan.hl.uis.UninteractiveUiBase;
import cn.royan.hl.utils.SystemUtils;

import flash.events.Event;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.errors.Error;

class UiBaseBmpdMovieClip extends InteractiveUiBase, implements IUiPlayBase
{
	//properties
	var bgTextures:Array<BitmapData>;
	var timer:TimerBase;
	var current:Int;
	var total:Int;
	var toFrame:Int;
	var frameRate:Int;
	var sequence:Bool;
	var loop:Bool;
	var autoPlay:Bool;
	var currentFrame:Bitmap;
	
	//Constructor
	public function new(texture:Dynamic, rate:Int = 10, auto:Bool = true, row:Int = 1, column:Int = 1, frames:Int = 1) 
	{
		super(Std.is( texture, BitmapData )?cast( texture, BitmapData ):null);
		
		var bmpd:BitmapData;
		var frameunit:UninteractiveUiBase;
		
		if( Std.is( texture, BitmapData ) ){
			total = frames;
			
			bgTextures = new Array<BitmapData>();
			
			var frameWidth:Int = Std.int( bgTexture.width / row );
			var frameHeight:Int = Std.int( bgTexture.height / column );
			
			setSize(frameWidth, frameHeight);
			
			var i:Int;
			var rectangle:Rectangle = new Rectangle();
				rectangle.width = frameWidth;
				rectangle.height = frameHeight;
			var point:Point = new Point();
			var curRow:Int;
			var curCol:Int;
			
			for(i in 0...total){
				curRow = Std.int( i % row );
				curCol = Std.int( i / row );
				
				rectangle.x = curRow * frameWidth;
				rectangle.y = curCol * frameHeight;
				
				bmpd = new BitmapData(frameWidth, frameHeight, true);
				bmpd.copyPixels( bgTexture, rectangle, point );
				
				bgTextures[i] = bmpd;
			}
		}else if( Std.is( texture, Array ) ){
			total = cast( texture ).length;
			bgTextures = cast texture;
			
			setSize(bgTextures[0].width, bgTextures[0].height);
		}else{
			throw new Error("texture is wrong type(BitmapData or Vector.<BitmapData>)");
		}
		
		loop = true;
		autoPlay = auto;
		sequence = true;
		current = 1;
		toFrame = 0;
		frameRate = rate;
		
		timer = new TimerBase( Std.int( 1000 / frameRate ), timerHandler );
		
		currentFrame = new Bitmap();
		
		if( bgTextures[current-1] != null )
			currentFrame.bitmapData = bgTextures[current - 1];
		
		addChild(currentFrame);
	}

	override public function draw():Void
	{

	}
	
	override public function dispose():Void 
	{
		super.dispose();
		
		if( bgTextures != null )
			while ( bgTextures.length > 0 ) {
				bgTextures.pop().dispose();
			}
		
		timer.stop();
	}
	
	public function clone():UiBaseBmpdMovieClip
	{
		return new UiBaseBmpdMovieClip(bgTextures, frameRate, autoPlay);
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
		currentFrame.bitmapData = bgTextures[current - 1];
	}

	public function goFromTo(from:Int, to:Int):Void
	{
		SystemUtils.print("Playing from["+from+"] to ["+to+"]");
		if( from == to ) return;
		
		loop = false;
		sequence = from <= to;
		current = from;
		toFrame = to;
		
		currentFrame.bitmapData = bgTextures[current - 1];
		
		timer.start();
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
		
		currentFrame.bitmapData = bgTextures[current - 1];
		
		if( current == toFrame && !loop ){
			if( callbacks != null && callbacks.done != null ) callbacks.done();
			else dispatchEvent(new DatasEvent(DatasEvent.DATA_DONE));
			timer.stop();
		}
	}
}