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
	var totalRow:Int;
	var totalCol:Int;
	var toFrame:Int;
	var frameRate:Int;
	var sequence:Bool;
	var loop:Bool;
	var autoPlay:Bool;
	var currentFrame:Bitmap;
	var freshRect:Rectangle;
	
	//Constructor
	public function new(texture:Dynamic, rate:Int = 10, auto:Bool = true, row:Int = 1, column:Int = 1, frames:Int = 1) 
	{
		super(Std.is( texture, Sparrow )?cast( texture, Sparrow ):null);
		
		totalRow = row;
		totalCol = column;
		
		var bmpd:BitmapData;
		var frameunit:UninteractiveUiN;
		bgTextures = [];
		
		freshRect = new Rectangle();
		
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
		
		currentFrame = new Bitmap(new BitmapData(Std.int(containerWidth), Std.int(containerHeight), true, #if neko {rgb:0,a:0} #else 0x00000000 #end));
		
		if( bgTextures[current-1] != null )
			currentFrame.bitmapData.copyPixels(bgTextures[current - 1].bitmapdata, bgTextures[current - 1].regin, new Point(bgTextures[current - 1].frame.x, bgTextures[current - 1].frame.y));
		
		addChild(currentFrame);
	}
	
	function drawTextures():Void
	{
		var frameWidth:Int = Std.int(bgTexture.regin.width / total);
		var frameHeight:Int = Std.int(bgTexture.regin.height);
		
		if ( bgTexture.frame != null ) {
			frameWidth = Std.int(bgTexture.frame.width / total);
			frameHeight = Std.int(bgTexture.frame.height);
		}
		
		var i:Int;
		var regin:Rectangle;
		var frame:Rectangle;
		var curRow:Int;
		var curCol:Int;
		
		for ( i in 0...total ) {
			curRow = Std.int(i % totalRow);
			curCol = Std.int(i / totalRow);
			
			frame = new Rectangle();
			regin = new Rectangle();
			regin.width = frameWidth;
			regin.height = frameHeight - (bgTexture.frame != null ? bgTexture.frame.height - bgTexture.regin.height + bgTexture.frame.y : 0);
			
			regin.x = curRow * frameWidth + bgTexture.regin.x + (bgTexture.frame != null ? bgTexture.frame.x : 0);
			regin.y = curCol * frameHeight + bgTexture.regin.y + (bgTexture.frame != null ? bgTexture.frame.y : 0);
			
			if ( curRow == 0 ) {
				regin.width = frameWidth + (bgTexture.frame != null ? bgTexture.frame.x : 0);
				//regin.height = frameHeight + (bgTexture.frame != null ? bgTexture.frame.y : 0);
				
				frame.x = bgTexture.frame != null ? -bgTexture.frame.x : 0;
				//frame.y = bgTexture.frame != null ? -bgTexture.frame.y : 0;
				
				regin.x = curRow * frameWidth + bgTexture.regin.x;
				//regin.y = curCol * frameHeight + bgTexture.regin.y;
			}
			if ( curRow == totalRow - 1 ) {
				regin.width = frameWidth - (bgTexture.frame != null ? bgTexture.frame.width - bgTexture.regin.width + bgTexture.frame.x : 0);
				//regin.height = frameHeight - (bgTexture.frame != null ? bgTexture.frame.height - bgTexture.regin.height + bgTexture.frame.y : 0);
			}
			
			if ( curCol == 0 ) {
				regin.height = frameHeight + (bgTexture.frame != null ? bgTexture.frame.y : 0);
				
				frame.y = bgTexture.frame != null ? -bgTexture.frame.y : 0;
				
				regin.y = curCol * frameHeight + bgTexture.regin.y;
			}
			if ( curCol == totalCol - 1 ) {
				regin.height = frameHeight - (bgTexture.frame != null ? bgTexture.frame.height - bgTexture.regin.height + bgTexture.frame.y : 0);
			}
			
			var bmpd:Sparrow = Sparrow.fromSparrow(bgTexture, regin, frame);
			
			bgTextures[i] = bmpd;
			
			//addChild(new Bitmap(bgTextures[i])).x = i * 60 + 60;
		}
		
		setSize(frameWidth, frameHeight);
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
		
		freshRect.x = getRange().x;
		freshRect.y = getRange().y;
		freshRect.width 	= getRange().width;
		freshRect.height 	= getRange().height;
		currentFrame.bitmapData.fillRect(freshRect, 0x00000000);
		currentFrame.bitmapData.copyPixels(bgTextures[current - 1].bitmapdata, bgTextures[current - 1].regin, new Point(bgTextures[current - 1].frame.x, bgTextures[current - 1].frame.y));
		currentFrame.scaleX = currentFrame.scaleY = getScale();
	}

	public function goFromTo(from:Int, to:Int):Void
	{
		if( from == to ) return;
		
		loop = false;
		sequence = from <= to;
		current = from;
		toFrame = to;
		
		freshRect.x = getRange().x;
		freshRect.y = getRange().y;
		freshRect.width 	= getRange().width;
		freshRect.height 	= getRange().height;
		currentFrame.bitmapData.fillRect(freshRect, 0x00000000);
		currentFrame.bitmapData.copyPixels(bgTextures[current - 1].bitmapdata, bgTextures[current - 1].regin, new Point(bgTextures[current - 1].frame.x, bgTextures[current - 1].frame.y));
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
		
		freshRect.x = getRange().x;
		freshRect.y = getRange().y;
		freshRect.width 	= getRange().width;
		freshRect.height 	= getRange().height;
		currentFrame.bitmapData.fillRect(freshRect, 0x00000000);
		currentFrame.bitmapData.copyPixels(bgTextures[current - 1].bitmapdata, bgTextures[current - 1].regin, new Point(bgTextures[current - 1].frame.x, bgTextures[current - 1].frame.y));
		currentFrame.scaleX = currentFrame.scaleY = getScale();
		
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