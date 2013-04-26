package cn.royan.hl.uis.starling.bases;

import cn.royan.hl.interfaces.uis.IUiItemGroupBase;
import cn.royan.hl.uis.starling.InteractiveUiS;
import cn.royan.hl.utils.BitmapDataUtils;
import cn.royan.hl.utils.SystemUtils;
import flash.geom.Rectangle;
import starling.display.Image;
import starling.events.Event;
import starling.events.TouchEvent;
import starling.textures.Texture;

/**
 * ...
 * @author RoYan
 */

class UiSBmpdButton extends InteractiveUiS, implements IUiItemGroupBase
{
	var bgTextures:Array<Texture>;
	var currentStatus:Image;
	var isInGroup:Bool;
	var freshRect:Rectangle;
	
	public function new(texture:Dynamic, frames:Int=5)
	{
		super(Std.is( texture, Texture )?cast( texture, Texture ):null);
		
		bgTextures = [];
		
		setMouseRender(true);
		//buttonMode = true;
		
		freshRect = new Rectangle();
		
		if( Std.is( texture, Texture ) ){
			statusLen = frames;
			
			drawTextures(texture);
		}else if( Std.is( texture, Array ) ){
		 	statusLen = cast( texture ).length;
			bgTextures = cast(texture);
			
		 	setSize(Std.int(bgTextures[0].width), Std.int(bgTextures[0].height));
		}else{
			//throw "texture is wrong type(Sparrow or Vector.<Sparrow>)";
			return;
		}
		
		currentStatus = new Image(Texture.fromBitmapData(BitmapDataUtils.fromColors(Std.int(containerWidth), Std.int(containerHeight), [0x00000], [0x00])));
		if( bgTextures[status] != null )
			currentStatus.texture = bgTextures[status];
		addChildAt(currentStatus, 0);
	}
	
	public function setInGroup(value:Bool):Void
	{
		isInGroup = value;
	}
	
	function drawTextures(texture:Texture):Void
	{
		var frameWidth:Int = Std.int(texture.width / statusLen);
		var frameHeight:Int = Std.int(texture.height);
		
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
			regin.height = frameHeight - (texture.frame != null ? texture.frame.height - texture.height + texture.frame.y : 0);
			
			regin.x = curRow * frameWidth + (texture.frame != null ? texture.frame.x : 0);
			
			frame.y = texture.frame != null ? -texture.frame.y : 0;
			
			regin.y = curCol * frameHeight;
			
			if ( i == 0 ) {
				regin.width = frameWidth + (texture.frame != null ? texture.frame.x : 0);
				regin.height = frameHeight + (texture.frame != null ? texture.frame.y : 0);
				
				frame.x = texture.frame != null ? -texture.frame.x : 0;
				frame.y = texture.frame != null ? -texture.frame.y : 0;
				
				regin.x = curRow * frameWidth;
				regin.y = curCol * frameHeight;
			}else if ( i == statusLen - 1 ) {
				regin.width = frameWidth - (texture.frame != null ? texture.frame.width - texture.width + texture.frame.x : 0);
				regin.height = frameHeight - (texture.frame != null ? texture.frame.height - texture.height + texture.frame.y : 0);
			}
			
			if ( i == 0 && i == statusLen - 1 ) {
				regin.width = texture.width;
				regin.height = texture.height;
			}
			
			var bmpd:Texture = Texture.fromTexture(texture, regin, frame);
			
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
	
	function mouseMoveHandler(evt:TouchEvent):Void
	{
		//buttonMode = (currentStatus.bitmapData.getPixel32(Std.int(evt.localX), Std.int(evt.localY)) >> 24) != 0x00;
	}
	
	override function mouseClickHandler():Void
	{
		SystemUtils.print("btn click");
		if( isInGroup ){
			selected = !selected;
			status = selected?InteractiveUiS.INTERACTIVE_STATUS_SELECTED:status;
			
			draw();
		}
		
		super.mouseClickHandler();
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
			currentStatus.texture = bgTextures[status];
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
				defaultTexture = Texture.fromBitmapData(BitmapDataUtils.fromColors(Std.int(statusLen * containerWidth), Std.int(containerHeight), bgColors, bgAlphas));
				
				drawTextures(defaultTexture);
				
				if ( currentStatus == null ) {
					currentStatus = new Image(Texture.fromBitmapData(BitmapDataUtils.fromColors(Std.int(containerWidth), Std.int(containerHeight), [0x00000], [0x00])));
					if( bgTextures[status] != null )
						currentStatus.texture = bgTextures[status];
					addChildAt(currentStatus, 0);
				}
			}
		}
		
		draw();
	}
	
	public function setSelected(value:Bool):Void
	{
		selected = value;
		status = selected?InteractiveUiS.INTERACTIVE_STATUS_SELECTED:InteractiveUiS.INTERACTIVE_STATUS_NORMAL;
		draw();
	}
	
	public function getSelected():Bool
	{
		return selected;
	}
	
	public function clone():UiSBmpdButton
	{
		return new UiSBmpdButton(bgTextures);
	}
	
	override public function setTexture(value:Texture, frames:Int=5):Void
	{
		if( value != null ){
			statusLen = frames;
		}
		bgTexture = value;
		
		drawTextures(bgTexture);
		
		if ( currentStatus == null ) {
			currentStatus = new Image(Texture.fromBitmapData(BitmapDataUtils.fromColors(Std.int(containerWidth), Std.int(containerHeight), [0x00000], [0x00])));
			if( bgTextures[status] != null )
				currentStatus.texture = bgTextures[status];
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