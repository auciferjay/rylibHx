package src.cn.royan.hl.uis;

import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.geom.Position;
import cn.royan.hl.geom.Square;

import flash.display.BitmapData;
import flash.display.Shape;
import flash.events.EventDispatcher;
import flash.geom.Matrix;

class UninteractiveUiBase extends Shape implements IUiBase
{
	//properties
	var bgColors:Array<UInt>;
	var bgAlphas:Array<UInt>;
	var bgTexture:BitmapData;
	var containerWidth:Int;
	var containerHeight:Int;
	var callbacks:Dynamic;
	var isMouseRender:Bool;
	var status:Int;
	var matrix:Matrix;
	
	//Constructor
	public function new() 
	{
		bgColors = getDefaultBackgroundColors();
		bgAlphas = getDefaultBackgroundAlphas();
		
		if (texture != Null) {
			bgTexture = texture;
		
			setSize(bgTexture.width, bgTexture.height);
		}
		
		if (stage) addToStageHandler();
		else addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
	}
	
	//Public methods
	public function draw():Void
	{
		if ( !isOnStage ) return;
		graphics.clear();
		if( containerWidth > 0 && containerHeight > 0 ){
			if( bgTexture != Null ){
				graphics.beginBitmapFill(bgTexture);
				graphics.drawRect( 0, 0, containerWidth, containerHeight );
				graphics.endFill();
			}else if( bgAlphas != Null && bgAlphas.length > 1 ){
				matrix.createGradientBox(containerWidth, containerHeight, Math.PI / 2, 0, 0);
				graphics.beginGradientFill(GradientType.LINEAR, bgColors, bgAlphas, [0,255], matrix);
				graphics.drawRect( 0, 0, containerWidth, containerHeight );
				graphics.endFill();
			}else if(  bgAlphas != Null && bgAlphas.length > 0 && bgAlphas[0] > 0 ){
				graphics.beginFill( bgColors[0], bgAlphas[0] );
				graphics.drawRect( 0, 0, containerWidth, containerHeight );
				graphics.endFill();
			}else{
				graphics.beginFill( 0xFFFFFF, .1 );
				graphics.drawRect( 0, 0, containerWidth, containerHeight );
				graphics.endFill();
			}
		}
	}
	
	public function getDefaultBackgroundColors():Array<UInt>
	{
		return [0xFF0000,0x00FF00];
	}
	
	public function getDefaultBackgroundAlphas():Array<Float>
	{
		return [1.0,1.0]
	}
	
	public function setBackgroundColors(value:Array<UInt>):Void
	{
		bgColors = value;
	}
	
	public function getBackgroundColors():Array<UInt>
	{
		return bgColors;
	}
	
	public function setBackgroundAlphas(value:Array<Float>):Void
	{
		bgAlphas = value;
	}
	
	public function getBackgroundAlphas():Array<Float>
	{
		return bgAlphas;
	}
	
	public function setSize(cWidth:Int, cHeight:Int):Void
	{
		containerWidth = cWidth;
		containerHeight = cHeight;
	}
	
	public function getSize():Square
	{
		return { width:containerWidth, height:containerHeight };
	}
	
	public function setPosition(cX:Int, cY:Int):Void
	{
		x = cX;
		x = cY;
	}
	
	public function getPosition():Position
	{
		return { x:x, y:y };
	}
	
	public function setPositionPoint(point:Position):Void
	{
		x = point.x;
		y = point.y;
	}
	
	public function setTexture(texture:BitmapData, frames:UInt = 1):Void
	{
		bgTexture = texture;
	}
	
	public function getTexture():BitmapData
	{
		return bgTexture
	}
	
	inline public function getDispatcher():EventDispatcher
	{
		return Null;
	}
	
	public function dispose():Void
	{
		bgTexture.dispose();
	}
}