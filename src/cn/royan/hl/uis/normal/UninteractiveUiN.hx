package cn.royan.hl.uis.normal;

import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.interfaces.uis.IUiItemStateBase;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.bases.Dictionary;
import cn.royan.hl.geom.Position;
import cn.royan.hl.geom.Square;
import cn.royan.hl.systems.DeviceCapabilities;
import cn.royan.hl.uis.sparrow.Sparrow;
import cn.royan.hl.utils.SystemUtils;
import flash.display.Bitmap;
import flash.geom.Rectangle;

import flash.display.BitmapData;
import flash.display.GradientType;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.EventDispatcher;
import flash.geom.Matrix;
import flash.geom.Point;

class UninteractiveUiN extends Sprite, implements IUiBase, implements IUiItemStateBase
{
	//properties
	var originalDPI:Int;
	var scale:Float;
	
	var bgColors:Array<Dynamic>;
	var bgAlphas:Array<Dynamic>;
	var bgTexture:Sparrow;
	var callbacks:Dynamic;
	var matrix:Matrix;
	var selected:Bool;
	
	var containerWidth:Float;
	var containerHeight:Float;
	var positionX:Float;
	var positionY:Float;
	
	var excludes:Array<String>;
	var includes:Array<String>;
	
	var background:Bitmap;
	var backgroundRect:Rectangle;
	
	//Constructor
	public function new(texture:Sparrow = null)
	{
		super();
		
		scale = 1;
		
		originalDPI = DeviceCapabilities.dpi;
		
		containerHeight = 0;
		containerWidth = 0;
		
		positionX = 0;
		positionY = 0;
		
		bgColors = getDefaultBackgroundColors();
		bgAlphas = getDefaultBackgroundAlphas();
		
		backgroundRect = new Rectangle();
		
		background = new Bitmap();
		background.smoothing = true;
		addChild(background);
		
		if (texture != null) {
			bgTexture = texture;
			
			setSize(Std.int(bgTexture.regin.width), Std.int(bgTexture.regin.height));
		}
		
		mouseEnabled = false;
		mouseChildren = false;
	}
	
	//Public methods
	public function draw():Void
	{
		graphics.clear();
		
		if( containerWidth > 0 && containerHeight > 0 ){
			if ( bgTexture != null ) {
				background.bitmapData.copyPixels(bgTexture.bitmapdata, bgTexture.regin, new Point());
				background.scaleX = background.scaleY = getScale();
			}else if( bgColors != null && bgColors.length > 1 ){
				matrix.createGradientBox(containerWidth, containerHeight, Math.PI / 2, 0, 0);
				graphics.beginGradientFill(GradientType.LINEAR, cast(bgColors), bgAlphas, [0,255], matrix);
				graphics.drawRect( 0, 0, getSize().width, getSize().height );
				graphics.endFill();
			}else if(  bgColors != null && bgColors.length > 0 && cast(bgAlphas[0]) > 0 ){
				graphics.beginFill( cast(bgColors[0]), bgAlphas[0] );
				graphics.drawRect( 0, 0, getSize().width, getSize().height );
				graphics.endFill();
			}else{
				//graphics.beginFill( 0xFFFFFF, 0 );
				//graphics.drawRect( 0, 0, containerWidth, containerHeight );
				//graphics.endFill();
			}
		}
	}
	
	public function getDefaultBackgroundColors():Array<Dynamic>
	{
		return [[0xFFFFFF]];
	}
	
	public function getDefaultBackgroundAlphas():Array<Dynamic>
	{
		return [[0.0]];
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
	
	public function setCallbacks(value:Dynamic):Void
	{
		callbacks = value;
	}
	
	public function setSize(w:Float, h:Float):Void
	{
		containerWidth = w;
		containerHeight = h;
		
		background.bitmapData = new BitmapData(Std.int(w), Std.int(h), true, 0xFFFFFF);
		
		backgroundRect.width 	= w;
		backgroundRect.height 	= h;
		
		draw();
	}

	public function getSize():Square
	{
		return { width:containerWidth, height:containerHeight };
	}

	public function setPosition(cx:Float, cy:Float):Void
	{
		positionX = cx;
		positionY = cy;
		
		x = positionX * getScale();
		y = positionY * getScale();
	}

	public function getPosition():Position
	{
		return { x:positionX, y:positionY };
	}
	
	public function setPositionPoint(point:Position):Void
	{
		positionX = point.x;
		positionY = point.y;
		
		x = positionX * getScale();
		y = positionY * getScale();
	}
	
	public function setPositionRange(value:Rectangle):Void
	{
		setSize(cast(value.width), cast(value.height));
		setPosition(cast(value.x), cast(value.y));
	}
	
	public function getRange():Rectangle
	{
		return backgroundRect;
	}
	
	public function setTexture(texture:Dynamic, frames:Int = 1):Void
	{
		if ( !Std.is(texture, Sparrow) ) {
			throw "";
		}else {
			bgTexture = texture;
			
			setSize(Std.int(bgTexture.regin.width), Std.int(bgTexture.regin.height));
		}
	}
	
	public function getTexture():Dynamic
	{
		return bgTexture;
	}
	
	public function setOriginalDPI(value:Int):Void
	{
		originalDPI = value;
		
		setScale( 72 / originalDPI );
		
		draw();
	}
	
	public function getOriginalDPI():Int
	{
		return originalDPI;
	}
	
	public function setScale(value:Float):Void
	{
		scale = value;
		
		x = positionX * getScale();
		y = positionY * getScale();
	}
	
	public function getScale():Float
	{
		return scale;
	}
	
	public function getDispatcher():EventDispatcher
	{
		return this;
	}
	
	public function setExclude(args:Array<String>):Void
	{
		excludes = args;
	}
	
	public function getExclude():Array<String>
	{
		return excludes;
	}
	
	public function setInclude(args:Array<String>):Void
	{
		includes = args;
	}
	
	public function getInclude():Array<String>
	{
		return includes;
	}

	override public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool=false, priority:Int=0, useWeakReference:Bool=false):Void
	{
		
	}

	override public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool=false):Void
	{
		
	}
	
	public function dispose():Void
	{
		background.bitmapData.dispose();
	}
}