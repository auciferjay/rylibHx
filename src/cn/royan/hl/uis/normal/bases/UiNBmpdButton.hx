package cn.royan.hl.uis.normal.bases;

import cn.royan.hl.interfaces.uis.IUiItemGroupBase;
import cn.royan.hl.uis.normal.InteractiveUiN;
import cn.royan.hl.uis.sparrow.Sparrow;
import cn.royan.hl.utils.SystemUtils;
import flash.errors.Error;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;

class UiNBmpdButton extends InteractiveUiN, implements IUiItemGroupBase
{
	var bgTextures:Array<Sparrow>;
	var currentStatus:BitmapData;
	var isInGroup:Bool;
	
	public function new(texture:Dynamic, frames:Int=5 )
	{
		super(Std.is( texture, Sparrow )?cast( texture, Sparrow ):null);
		
		bgTextures = [];
		
		setMouseRender(true);
		buttonMode = true;
		
		if( Std.is( texture, Sparrow ) ){
			statusLen = frames;
			
			drawTextures();
		}else if( Std.is( texture, Array ) ){
		 	statusLen = cast( texture ).length;
			bgTextures = cast(texture);
			
		 	setSize(Std.int(bgTextures[0].regin.width), Std.int(bgTextures[0].regin.height));
		}else{
			//throw new Error("texture is wrong type(Sparrow or Vector.<Sparrow>)");
			return;
		}
		
		currentStatus = new BitmapData(containerWidth, containerHeight, true, 0x00000000);
		if( bgTextures[status] != null )
			currentStatus.copyPixels(bgTextures[status].bitmapdata, bgTextures[status].regin, new Point(bgTextures[status].frame.x, bgTextures[status].frame.y));
		addChildAt(new Bitmap(currentStatus), 0);
	}
	
	public function setInGroup(value:Bool):Void
	{
		isInGroup = value;
	}
	
	function drawTextures():Void
	{
		var frameWidth:Int = Std.int(bgTexture.regin.width / statusLen);
		var frameHeight:Int = Std.int(bgTexture.regin.height);
		
		if ( bgTexture.frame != null ) {
			frameWidth = Std.int(bgTexture.frame.width / statusLen);
			frameHeight = Std.int(bgTexture.frame.height);
		}
		
		var i:Int;
		var regin:Rectangle;
		var frame:Rectangle;
		var curRow:Int;
		var curCol:Int;
		
		for ( i in 0...statusLen ) {
			curRow = Std.int(i % statusLen);
			curCol = Std.int(i / statusLen);
			
			frame = new Rectangle();
			regin = new Rectangle();
			regin.width = frameWidth;
			regin.height = frameHeight - (bgTexture.frame != null ? bgTexture.frame.height - bgTexture.regin.height + bgTexture.frame.y : 0);
			
			regin.x = curRow * frameWidth + bgTexture.regin.x + (bgTexture.frame != null ? bgTexture.frame.x : 0);
			//regin.y = curCol * frameHeight + bgTexture.regin.y + (bgTexture.frame != null ? bgTexture.frame.y : 0);
			
			frame.y = bgTexture.frame != null ? -bgTexture.frame.y : 0;
			
			regin.y = curCol * frameHeight + bgTexture.regin.y;
			
			if ( i == 0 ) {
				regin.width = frameWidth + (bgTexture.frame != null ? bgTexture.frame.x : 0);
				//regin.height = frameHeight + (bgTexture.frame != null ? bgTexture.frame.y : 0);
				
				frame.x = bgTexture.frame != null ? -bgTexture.frame.x : 0;
				//frame.y = bgTexture.frame != null ? -bgTexture.frame.y : 0;
				
				regin.x = curRow * frameWidth + bgTexture.regin.x;
				//regin.y = curCol * frameHeight + bgTexture.regin.y;
			}else if ( i == statusLen - 1 ) {
				regin.width = frameWidth - (bgTexture.frame != null ? bgTexture.frame.width - bgTexture.regin.width + bgTexture.frame.x : 0);
				//regin.height = frameHeight - (bgTexture.frame != null ? bgTexture.frame.height - bgTexture.regin.height + bgTexture.frame.y : 0);
			}
			
			var bmpd:Sparrow = Sparrow.fromSparrow(bgTexture, regin, frame);
			
			bgTextures[i] = bmpd;
			
			//addChild(new Bitmap(bgTextures[i])).visible = false;//确保显示
		}
		
		setSize(frameWidth, frameHeight);
	}
	
	override function addToStageHandler(evt:Event=null):Void
	{
		super.addToStageHandler(evt);
		
		//addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
	}
	
	function mouseMoveHandler(evt:MouseEvent):Void
	{
		buttonMode = (currentStatus.getPixel32(Std.int(evt.localX), Std.int(evt.localY)) >> 24) != 0x00;
	}
	
	override function mouseClickHandler(evt:MouseEvent):Void
	{
		if( isInGroup ){
			selected = !selected;
			status = selected?InteractiveUiN.INTERACTIVE_STATUS_SELECTED:status;
			
			draw();
		}
		
		super.mouseClickHandler(evt);
	}
	
	//Public methods
	override public function draw():Void
	{
		if ( !isOnStage ) return;
		if ( status < bgTextures.length && currentStatus != null )
			currentStatus.copyPixels(bgTextures[status].bitmapdata, bgTextures[status].regin, new Point(bgTextures[status].frame.x, bgTextures[status].frame.y));
	}
	
	public function clone():UiNBmpdButton
	{
		return new UiNBmpdButton(bgTextures);
	}
	
	override public function getDefaultBackgroundColors():Array<Dynamic>
	{
		return [[0xFFFFFF,0x00ff64],[0x00ff64,0x00c850],[0x00c850,0xe9f48e],[0xe9f48e,0xa2a29e],[0xa2a29e,0xFFFFFF]];
	}
	
	override public function getDefaultBackgroundAlphas():Array<Dynamic>
	{
		return [[1,1],[1,1],[1,1],[1,1],[1,1]];
	}
	
	public function setSelected(value:Bool):Void
	{
		selected = value;
		status = selected?InteractiveUiN.INTERACTIVE_STATUS_SELECTED:InteractiveUiN.INTERACTIVE_STATUS_NORMAL;
		draw();
	}
	
	public function getSelected():Bool
	{
		return selected;
	}
	
	override public function setTexture(value:Sparrow, frames:Int=5):Void
	{
		if( value != null ){
			statusLen = frames;
		}
		bgTexture = value;
		
		drawTextures();
		
		if ( currentStatus == null ) {
			currentStatus = new BitmapData(containerWidth, containerHeight, true, 0x00000000);
			if( bgTextures[status] != null )
				currentStatus.copyPixels(bgTextures[status].bitmapdata, bgTextures[status].regin, new Point(bgTextures[status].frame.x, bgTextures[status].frame.y));
			addChildAt(new Bitmap(currentStatus), 0);
		}
		
		draw();
	}
	
	override public function dispose():Void
	{
		super.dispose();
		
		if( bgTextures != null )
			while ( bgTextures.length > 0 ) {
				bgTextures.pop().dispose();
			}
	}
}