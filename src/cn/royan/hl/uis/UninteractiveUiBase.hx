package cn.royan.hl.uis;

import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.geom.Position;
import cn.royan.hl.geom.Square;

import flash.display.BitmapData;
import flash.display.GradientType;
import flash.display.Shape;
import flash.events.EventDispatcher;
import flash.geom.Matrix;

class UninteractiveUiBase extends Shape, implements IUiBase
{
	//properties
	var bgColors:Array<Int>;
	var bgAlphas:Array<Float>;
	var bgTexture:BitmapData;
	var containerWidth:Int;
	var containerHeight:Int;
	var matrix:Matrix;
	
	//Constructor
	public function new(texture:BitmapData = null) 
	{
		super();

		bgColors = getDefaultBackgroundColors();
		bgAlphas = getDefaultBackgroundAlphas();
		
		if (texture != null) {
			bgTexture = texture;
		
			setSize(bgTexture.width, bgTexture.height);
		}
		
		draw();
	}
	
	//Public methods
	public function draw():Void
	{
		graphics.clear();
		if( containerWidth > 0 && containerHeight > 0 ){
			if( bgTexture != null ){
				graphics.beginBitmapFill(bgTexture);
				graphics.drawRect( 0, 0, containerWidth, containerHeight );
				graphics.endFill();
			}else if( bgAlphas != null && bgAlphas.length > 1 ){
				matrix.createGradientBox(containerWidth, containerHeight, Math.PI / 2, 0, 0);
				graphics.beginGradientFill(GradientType.LINEAR, bgColors, bgAlphas, [0,255], matrix);
				graphics.drawRect( 0, 0, containerWidth, containerHeight );
				graphics.endFill();
			}else if(  bgAlphas != null && bgAlphas.length > 0 && bgAlphas[0] > 0 ){
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
	
	public function getDefaultBackgroundColors():Array<Int>
	{
		return [0xFF0000,0x00FF00];
	}
	
	public function getDefaultBackgroundAlphas():Array<Float>
	{
		return [1.0,1.0];
	}
	
	public function setBackgroundColors(value:Array<Int>):Void
	{
		bgColors = value;
	}
	
	public function getBackgroundColors():Array<Int>
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
		return { x:Std.int(x), y:Std.int(y) };
	}
	
	public function setPositionPoint(point:Position):Void
	{
		x = point.x;
		y = point.y;
	}
	
	public function setTexture(texture:BitmapData, frames:Int = 1):Void
	{
		bgTexture = texture;
	}
	
	public function getTexture():BitmapData
	{
		return bgTexture;
	}
	
	inline public function getDispatcher():EventDispatcher
	{
		return null;
	}
	
	public function dispose():Void
	{
		bgTexture.dispose();
	}
}