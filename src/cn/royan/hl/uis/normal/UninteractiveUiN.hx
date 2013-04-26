package cn.royan.hl.uis.normal;

import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.interfaces.uis.IUiItemStateBase;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.geom.Range;
import cn.royan.hl.systems.DeviceCapabilities;
import cn.royan.hl.uis.sparrow.Sparrow;
import cn.royan.hl.utils.BitmapDataUtils;
import cn.royan.hl.utils.SystemUtils;
import flash.display.Bitmap;
import flash.geom.Rectangle;

import flash.display.BitmapData;
import flash.display.GradientType;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.EventDispatcher;
import flash.geom.Point;

class UninteractiveUiN extends Sprite, implements IUiBase, implements IUiItemStateBase
{
	//properties
	var originalDPI:Int;
	var scale:Float;
	
	var bgColors:Array<Dynamic>;
	var bgAlphas:Array<Dynamic>;
	var defaultTexture:Sparrow;
	var bgTexture:Sparrow;
	
	var callbacks:Dynamic;
	var selected:Bool;
	
	var containerWidth:Float;
	var containerHeight:Float;
	var positionX:Float;
	var positionY:Float;
	
	var excludes:Array<String>;
	var includes:Array<String>;
	
	var background:Bitmap;
	
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
			if ( bgTexture != null )
				background.bitmapData.copyPixels(bgTexture.bitmapdata, bgTexture.regin, new Point());
			else if( defaultTexture != null )
				background.bitmapData.copyPixels(defaultTexture.bitmapdata, defaultTexture.regin, new Point());
			background.scaleX = background.scaleY = getScale();
		}
	}
	
	public function getDefaultTexture():Sparrow
	{
		return Sparrow.fromBitmapData(BitmapDataUtils.fromColors(Std.int(containerWidth), Std.int(containerHeight), bgColors, bgAlphas));
	}
	
	public function setColorsAndAplhas(color:Array<Dynamic>, alpha:Array<Dynamic>):Void
	{
		bgColors = color;
		bgAlphas = alpha;
		
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
			
			if( containerWidth > 0 && containerHeight > 0 )
				defaultTexture = getDefaultTexture();
		}
		
		draw();
	}
	
	public function getColors():Array<Dynamic>
	{
		return bgColors;
	}
	
	public function getAlphas():Array<Dynamic>
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
		
		if( bgTexture == null && bgColors != null && bgAlphas != null )
			defaultTexture = getDefaultTexture();
			
		draw();
	}

	public function setPosition(cx:Float, cy:Float):Void
	{
		positionX = cx;
		positionY = cy;
		
		x = positionX * (Std.is(parent, IUiBase)?getScale():1);
		y = positionY * (Std.is(parent, IUiBase)?getScale():1);
	}
	
	public function setRange(value:Range):Void
	{
		setSize(cast(value.width), cast(value.height));
		setPosition(cast(value.x), cast(value.y));
	}
	
	public function getRange():Range
	{
		return { x:positionX, y:positionY, width:containerWidth, height:containerHeight };
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
	
	public function setScale(value:Float):Void
	{
		scale = value;
		
		x = positionX * getScale();
		y = positionY * getScale();
		
		draw();
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