package cn.royan.hl.uis.bases;

import cn.royan.hl.interfaces.uis.IUiSelectBase;
import cn.royan.hl.uis.InteractiveUiBase;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;

class UiBaseBmpdButton extends InteractiveUiBase, implements IUiSelectBase
{
	var bgTextures:Array<BitmapData>;
	var currentStatus:Bitmap;
	var total:Bool;
	var isInGroup:Bool;
	
	public function new(texture:Dynamic, length:Int=5 )
	{
		super(Std.is( texture, BitmapData )?cast( texture, BitmapData ):null);
		
		if( Std.is( texture, BitmapData ) ){
			total = frames;
			bgTextures = new Array<BitmapData>();
			
			drawTextures();
		}else if( Std.is( texture, Array ) ){
		 	total = cast( texture, Array<BitmapData>).length;
		 	bgTextures = cast( texture, Array<BitmapData>);
			
		 	setSize(bgTextures[0].width, bgTextures[0].height);
		}else{
			throw new Error("texture is wrong type(BitmapData or Vector.<BitmapData>)");
		}
		
		currentStatus = new Bitmap();
		
		if( bgTextures[status] != null )
			currentStatus.bitmapData = bgTextures[status];
		
		addChild(currentStatus);
		
		setMouseRender(true);
		
		buttonMode = true;
	}
	
	//Public methods
	override public function getDefaultBackgroundColors():Array<Int> 
	{
		return [0xFFFFFF,0x00ff64,0x00ff64,0x00c850,0xcccccc];
	}
	
	override public function getBackgroundAlphas():Array<Float> 
	{
		return [1.0,1.0,1.0,1.0,1.0];
	}

	override public function draw():Void
	{
		if( currentStatus != null )
			currentStatus.bitmapData = bgTextures[status];
	}
	
	public function setSelected(value:Bool):Void
	{
		
	}
	
	public function getSelected():Bool
	{
		return status == InteractiveUiBase.INTERACTIVE_STATUS_SELECTED;
	}
	
	public function setInGroup(value:Bool):Void
	{
		
	}
	
	public function clone():UiBaseBmpdButton
	{
		return new UiBaseBmpdButton(bgTextures);
	}
	
	//Protected methods
	function mouseMoveHandler(evt:MouseEvent):Void
	{
		
	}
	
	override private function addToStageHandler(evt:Event = null):Void 
	{
		super.addToStageHandler(evt);
		
		addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
	}
	
	function drawTextures():Void
	{
		var frameWidth:Int 	= Std.int( bgTexture.width / total );
		var frameHeight:Int = Std.int( bgTexture.height );
		
		var i:Int;
		var rectangle:Rectangle = new Rectangle();
			rectangle.width = frameWidth;
			rectangle.height = frameHeight;
		var point:Point = new Point();
		var curRow:Int;
		var curCol:Int;
		
		for(i in 0...total){
			curRow = Std.int( i % total );
			curCol = Std.int( i / total );
			
			rectangle.x = curRow * frameWidth;
			rectangle.y = curCol * frameHeight;
			
			var bmpd:BitmapData;
				bmpd = new BitmapData( frameWidth, frameHeight, true );
				bmpd.copyPixels( bgTexture, rectangle, point );
			
			bgTextures[i] = bmpd;
		}
		
		setSize(frameWidth, frameHeight);
	}
}