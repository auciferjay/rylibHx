package cn.royan.hl.uis.normal.bases;

import cn.royan.hl.interfaces.uis.IUiItemGroupBase;
import cn.royan.hl.uis.normal.InteractiveUiN;
import cn.royan.hl.uis.sparrow.Sparrow;
import cn.royan.hl.utils.BitmapDataUtils;
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
	var currentStatus:Bitmap;
	var isInGroup:Bool;
	var freshRect:Rectangle;
	
	public function new(texture:Dynamic, frames:Int=5)
	{
		super(Std.is( texture, Sparrow )?cast( texture, Sparrow ):null);
		
		bgTextures = [];
		
		setMouseRender(true);
		buttonMode = true;
		
		freshRect = new Rectangle();
		
		if( Std.is( texture, Sparrow ) ){
			statusLen = frames;
			
			drawTextures(texture);
		}else if( Std.is( texture, Array ) ){
		 	statusLen = cast( texture ).length;
			bgTextures = cast(texture);
			
		 	setSize(Std.int(bgTextures[0].regin.width), Std.int(bgTextures[0].regin.height));
		}else{
			//throw "texture is wrong type(Sparrow or Vector.<Sparrow>)";
			return;
		}
		
		currentStatus = new Bitmap(new BitmapData(Std.int(containerWidth), Std.int(containerHeight), true, 0x00000000));
		if( bgTextures[status] != null )
			currentStatus.bitmapData.copyPixels(bgTextures[status].bitmapdata, bgTextures[status].regin, new Point(bgTextures[status].frame.x, bgTextures[status].frame.y));
		addChildAt(currentStatus, 0);
	}
	
	public function setInGroup(value:Bool):Void
	{
		isInGroup = value;
	}
	
	function drawTextures(texture:Sparrow):Void
	{
		var frameWidth:Int = Std.int(texture.regin.width / statusLen);
		var frameHeight:Int = Std.int(texture.regin.height);
		
		if ( texture.frame != null ) {
			frameWidth = Std.int(texture.frame.width / statusLen);
			frameHeight = Std.int(texture.frame.height);
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
			regin.height = frameHeight - (texture.frame != null ? texture.frame.height - texture.regin.height + texture.frame.y : 0);
			
			regin.x = curRow * frameWidth + texture.regin.x + (texture.frame != null ? texture.frame.x : 0);
			
			frame.y = texture.frame != null ? -texture.frame.y : 0;
			
			regin.y = curCol * frameHeight + texture.regin.y;
			
			if ( i == 0 ) {
				regin.width = frameWidth + (texture.frame != null ? texture.frame.x : 0);
				regin.height = frameHeight + (texture.frame != null ? texture.frame.y : 0);
				
				frame.x = texture.frame != null ? -texture.frame.x : 0;
				frame.y = texture.frame != null ? -texture.frame.y : 0;
				
				regin.x = curRow * frameWidth + texture.regin.x;
				regin.y = curCol * frameHeight + texture.regin.y;
			}else if ( i == statusLen - 1 ) {
				regin.width = frameWidth - (texture.frame != null ? texture.frame.width - texture.regin.width + texture.frame.x : 0);
				regin.height = frameHeight - (texture.frame != null ? texture.frame.height - texture.regin.height + texture.frame.y : 0);
			}
			
			if ( i == 0 && i == statusLen - 1 ) {
				regin.width = texture.regin.width;
				regin.height = texture.regin.height;
			}
			
			var bmpd:Sparrow = Sparrow.fromSparrow(texture, regin, frame);
			
			bgTextures[i] = bmpd;
			//addChild(new Bitmap(bgTextures[i])).visible = false;//确保显示
		}
		
		while ( bgTextures.length < 5 ) {
			bgTextures.push(bgTextures[bgTextures.length - 1]);
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
		buttonMode = (currentStatus.bitmapData.getPixel32(Std.int(evt.localX), Std.int(evt.localY)) >> 24) != 0x00;
	}
	
	override function mouseClickHandler(evt:MouseEvent):Void
	{
		SystemUtils.print("btn click");
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
		if ( status < bgTextures.length && currentStatus != null ) {
			freshRect.x = getRange().x;
			freshRect.y = getRange().y;
			freshRect.width 	= getRange().width;
			freshRect.height 	= getRange().height;
			currentStatus.bitmapData.fillRect(freshRect, 0x00000000);
			currentStatus.bitmapData.copyPixels(bgTextures[status].bitmapdata, bgTextures[status].regin, new Point(bgTextures[status].frame.x, bgTextures[status].frame.y));
			currentStatus.scaleX = currentStatus.scaleY = getScale();
		}
	}
	
	override public function setColorsAndAplhas(color:Array<Dynamic>, alpha:Array<Dynamic>):Void 
	{
		bgColors = color;
		bgAlphas = alpha;
		
		if( bgTexture == null )
			statusLen = Std.int(Math.min(bgColors.length, 5));
		
		if( bgColors.length > 0 ){
			if ( bgAlphas == null ) bgAlphas = [];
			while ( bgAlphas.length < bgColors.length ) {
				var temp:Array<Float> = [];
				for ( i in 0...bgColors[bgAlphas.length].length ) {
					temp.push(1);
				}
				bgAlphas.push(temp);
			}
			
			while ( bgAlphas.length > bgColors.length ) {
				bgAlphas.pop();
			}
			
			if ( containerWidth > 0 && containerHeight > 0 ) {
				defaultTexture = Sparrow.fromBitmapData(BitmapDataUtils.fromColors(Std.int(statusLen * containerWidth), Std.int(containerHeight), bgColors, bgAlphas));
				
				drawTextures(defaultTexture);
				
				if ( currentStatus == null ) {
					currentStatus = new Bitmap(new BitmapData(Std.int(containerWidth), Std.int(containerHeight), true, 0x00000000));
					if( bgTextures[status] != null )
						currentStatus.bitmapData.copyPixels(bgTextures[status].bitmapdata, bgTextures[status].regin, new Point(bgTextures[status].frame.x, bgTextures[status].frame.y));
					addChildAt(currentStatus, 0);
				}
			}
		}
		
		draw();
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
	
	public function clone():UiNBmpdButton
	{
		return new UiNBmpdButton(bgTextures);
	}
	
	override public function setTexture(value:Sparrow, frames:Int=5):Void
	{
		if( value != null ){
			statusLen = frames;
		}
		bgTexture = value;
		
		drawTextures(bgTexture);
		
		if ( currentStatus == null ) {
			currentStatus = new Bitmap(new BitmapData(Std.int(containerWidth), Std.int(containerHeight), true, 0x00000000));
			if( bgTextures[status] != null )
				currentStatus.bitmapData.copyPixels(bgTextures[status].bitmapdata, bgTextures[status].regin, new Point(bgTextures[status].frame.x, bgTextures[status].frame.y));
			addChildAt(currentStatus, 0);
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