package cn.royan.hl.uis.starling;

import cn.royan.hl.geom.Range;
import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.interfaces.uis.IUiItemStateBase;
import cn.royan.hl.utils.BitmapDataUtils;

import flash.geom.Rectangle;
import flash.display.BitmapData;
import flash.events.EventDispatcher;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.events.Event;

/**
 * ...
 * @author RoYan
 */
class UninteractiveUiS extends Sprite, implements IUiBase, implements IUiItemStateBase
{
	//properties
	var originalDPI:Int;
	var scale:Float;
	
	var bgColors:Array<Dynamic>;
	var bgAlphas:Array<Dynamic>;
	var defaultTexture:Texture;
	var bgTexture:Texture;
	
	var containerWidth:Float;
	var containerHeight:Float;
	var positionX:Float;
	var positionY:Float;
	
	var excludes:Array<String>;
	var includes:Array<String>;

	public var graphics:Image;
	
	var isInit:Bool;
	
	//Constructor
	public function new(texture:Texture = null)
	{
		super();
		
		scale = 1;
		
		containerHeight = 0;
		containerWidth = 0;
		
		positionX = 0;
		positionY = 0;

		if (texture != null) {
			bgTexture = texture;
			
			setSize(Std.int(bgTexture.width), Std.int(bgTexture.height));
		}
		
		if ( containerHeight > 0 && containerWidth > 0 ) {
			graphics = new Image(Texture.fromBitmapData(BitmapDataUtils.fromColors(Std.int(containerWidth), Std.int(containerHeight), [0x000000], [0x00])));
			addChild( graphics );
		}
		
		isInit = true;
		
		draw();
	}
	
	//Public methods
	public function draw():Void
	{
		if ( !isInit ) return;
		if ( containerWidth > 0 && containerHeight > 0 ) {
			if( bgTexture != null )
				graphics.texture = bgTexture;
			else if( defaultTexture != null )
				graphics.texture = defaultTexture;
		}
	}
	
	public function getDefaultTexture():Dynamic
	{
		return Texture.fromBitmapData(BitmapDataUtils.fromColors(Std.int(containerWidth), Std.int(containerHeight), bgColors, bgAlphas));
	}
	
	public function setColorsAndAplhas(color:Array<Dynamic>, alpha:Array<Dynamic>):Void
	{
		bgColors = color;
		bgAlphas = alpha;
		
		while ( bgAlphas.length < bgColors.length ) {
			bgAlphas.push(bgAlphas[bgAlphas.length - 1]);
		}
		
		while ( bgColors.length < bgAlphas.length ) {
			bgColors.push(bgColors[bgColors.length - 1]);
		}
		
		if( containerWidth > 0 && containerHeight > 0 )
			defaultTexture = getDefaultTexture();
		
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
		
	}
	
	public function setSize(w:Float, h:Float):Void
	{
		containerWidth = w;
		containerHeight = h;
		
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
		if ( !Std.is(texture, Texture) )
		{
			throw "";
		}else {
			bgTexture = texture;
			
			setSize(Std.int(bgTexture.width), Std.int(bgTexture.height));
			
			if ( containerHeight > 0 && containerWidth > 0 && graphics == null ) {
				graphics = new Image(Texture.fromBitmapData(BitmapDataUtils.fromColors(Std.int(containerWidth), Std.int(containerHeight), [0x000000], [0x00])));
				addChild( graphics );
			}
		}
	}
	
	public function getTexture():Dynamic
	{
		return bgTexture;
	}
	
	public function setScale(value:Float):Void
	{
		scale = value;
		
		x = positionX * (Std.is(parent, IUiBase)?getScale():1);
		y = positionY * (Std.is(parent, IUiBase)?getScale():1);
		
		draw();
	}
	
	public function getScale():Float
	{
		return scale;
	}
	
	public function getDispatcher():EventDispatcher
	{
		return null;
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

	override public function dispose():Void
	{
		bgTexture.dispose();
	}
}