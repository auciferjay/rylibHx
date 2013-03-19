package cn.royan.hl.uis;

import cn.royan.hl.bases.CallBackBase;
import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.geom.Position;
import cn.royan.hl.geom.Square;
import cn.royan.hl.utils.SystemUtils;
import flash.errors.Error;

import flash.display.BitmapData;
import flash.display.GradientType;
import flash.display.Shape;
import flash.events.EventDispatcher;
import flash.geom.Matrix;

class UninteractiveUiBase extends Shape, implements IUiBase
{
	//properties
	var bgColors:Array<Dynamic>;
	var bgAlphas:Array<Dynamic>;
	var bgTexture:BitmapData;
	var containerWidth:Int;
	var containerHeight:Int;
	var matrix:Matrix;
	
	//Constructor
	public function new(texture:BitmapData = null) 
	{
		super();
		
		containerHeight = 0;
		containerWidth = 0;
		
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
			}else if ( bgColors != null && bgColors.length > 1 ) {
				matrix.createGradientBox(containerWidth, containerHeight, Math.PI / 2, 0, 0);
				graphics.beginGradientFill(GradientType.LINEAR, cast(bgColors), bgAlphas, [0,255], matrix);
				graphics.drawRect( 0, 0, containerWidth, containerHeight );
				graphics.endFill();
			}else if(  bgColors != null && bgColors.length > 0 && cast(bgAlphas[0]) > 0 ){
				graphics.beginFill( cast(bgColors[0]), bgAlphas[0] );
				graphics.drawRect( 0, 0, containerWidth, containerHeight );
				graphics.endFill();
			}else{
				graphics.beginFill( 0xFFFFFF, 0 );
				graphics.drawRect( 0, 0, containerWidth, containerHeight );
				graphics.endFill();
			}
		}
	}
	
	public function getDefaultBackgroundColors():Array<Dynamic>
	{
		return [0xFF0000];
	}
	
	public function getDefaultBackgroundAlphas():Array<Dynamic>
	{
		return [1.0];
	}
	
	public function setBackgroundColors(value:Array<Dynamic>):Void
	{
		bgColors = value;
		
		if( bgColors.length > 1 ){
			if( matrix == null )
				matrix = new Matrix();
			
			if ( bgAlphas == null ) bgAlphas = [];
			while ( bgAlphas.length < bgColors.length ) {
				bgAlphas.push(1);
			}
			
			while ( bgAlphas.length > bgColors.length ) {
				bgAlphas.pop();
			}
		}
		
		draw();
	}
	
	public function getBackgroundColors():Array<Dynamic>
	{
		return bgColors;
	}
	
	public function setBackgroundAlphas(value:Array<Dynamic>):Void
	{
		bgAlphas = value;
		
		if( bgColors.length > 1 ){
			if( matrix == null )
				matrix = new Matrix();
			
			if ( bgAlphas == null ) bgAlphas = [];
			while ( bgAlphas.length < bgColors.length ) {
				bgAlphas.push(1);
			}
			
			while ( bgAlphas.length > bgColors.length ) {
				bgAlphas.pop();
			}
		}
		
		draw();
	}
	
	public function getBackgroundAlphas():Array<Dynamic>
	{
		return bgAlphas;
	}
	
	public function setCallbacks(value:CallBackBase):Void
	{
		throw new Error("uninteractivebase");
	}
	
	public function setSize(cWidth:Int, cHeight:Int):Void
	{
		containerWidth = cWidth;
		containerHeight = cHeight;

		draw();
	}
	
	public function getSize():Square
	{
		return { width:containerWidth, height:containerHeight };
	}
	
	public function setPosition(cX:Int, cY:Int):Void
	{
		x = cX;
		y = cY;
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

		setSize(bgTexture.width, bgTexture.height);
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