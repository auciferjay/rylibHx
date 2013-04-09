package cn.royan.hl.uis.normal.bases;

import cn.royan.hl.interfaces.uis.IUiItemGroupBase;
import cn.royan.hl.uis.normal.InteractiveUiN;
import cn.royan.hl.uis.sparrow.Sparrow;
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
	var currentStatus:Bitmap;
	var total:Int;
	var isInGroup:Bool;
	
	public function new(texture:Dynamic, frames:Int=5 )
	{
		super(Std.is( texture, Sparrow )?cast( texture, Sparrow ):null);
		
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
		
		currentStatus = new Bitmap();
		
		if( bgTextures[status] != null )
			currentStatus.bitmapData.copyPixels(bgTextures[status].bitmapdata, bgTextures[status].regin, new Point());
		
		addChild(currentStatus);
		
		setMouseRender(true);
		
		buttonMode = true;
	}
	
	public function setInGroup(value:Bool):Void
	{
		isInGroup = value;
	}
	
	function drawTextures():Void
	{
		var frameWidth:Int = Std.int(bgTexture.bitmapdata.width / total);
		var frameHeight:Int = Std.int(bgTexture.bitmapdata.height);
		
		var i:Int;
		var rectangle:Rectangle = new Rectangle();
			rectangle.width = frameWidth;
			rectangle.height = frameHeight;
			
		var point:Point = new Point();
		var curRow:Int;
		var curCol:Int;
		
		for ( i in 0...total ) {
			curRow = Std.int(i % total);
			curCol = Std.int(i / total);
			
			rectangle.x = curRow * frameWidth;
			rectangle.y = curCol * frameHeight;
			
			var bmpd:Sparrow = Sparrow.fromSparrow(bgTexture, rectangle.clone());
			
			bgTextures[i] = bmpd;
			
			//addChild(new Bitmap(bgTextures[i])).visible = false;//确保显示
		}
		
		setSize(frameWidth, frameHeight);
		
		rectangle = null;
		point = null;
	}
	
	override function addToStageHandler(evt:Event=null):Void
	{
		super.addToStageHandler(evt);
		
		//addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
	}
	
	function mouseMoveHandler(evt:MouseEvent):Void
	{
		buttonMode = (currentStatus.bitmapData.getPixel32(Std.int(evt.localX), Std.int(evt.localY)) >> 24) != 0x00;
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
		if ( status < bgTextures.length ) {
			currentStatus.bitmapData.copyPixels(bgTextures[status].bitmapdata, bgTextures[status].regin, new Point());
		}
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