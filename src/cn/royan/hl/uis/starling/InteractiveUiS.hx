package cn.royan.hl.uis.starling;
import cn.royan.hl.bases.Dictionary;
import cn.royan.hl.geom.Position;
import cn.royan.hl.geom.Square;
import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.interfaces.uis.IUiItemStateBase;
import flash.geom.Rectangle;

import flash.display.BitmapData;
import flash.events.EventDispatcher;
import flash.geom.Matrix;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.events.Event;
import starling.events.TouchEvent;
/**
 * ...
 * @author RoYan
 */
class InteractiveUiS extends Sprite, implements IUiBase, implements IUiItemStateBase
{
	static public inline var INTERACTIVE_STATUS_NORMAL:Int 		= 0;
	static public inline var INTERACTIVE_STATUS_OVER:Int 		= 1;
	static public inline var INTERACTIVE_STATUS_DOWN:Int 		= 2;
	static public inline var INTERACTIVE_STATUS_SELECTED:Int 	= 3;
	static public inline var INTERACTIVE_STATUS_DISABLE:Int 	= 4;
	
	//properties
	var originalDPI:Int;
	var scale:Float;
	
	var bgColors:Array<Dynamic>;
	var bgAlphas:Array<Dynamic>;
	var bgTexture:Texture;
	var callbacks:Dynamic;
	var isMouseRender:Bool;
	var status:Int;
	var statusLen:Int;
	var matrix:Matrix;
	var selected:Bool;
	var isOnStage:Bool;
	
	var containerWidth:Float;
	var containerHeight:Float;
	var positionX:Float;
	var positionY:Float;
	
	var excludes:Array<String>;
	var includes:Array<String>;

	var evtListenerType:Array<String>;
	var evtListenerDirectory:Array<Dynamic>;
	
	public var graphics:Image;
	public var backgroundRect:Rectangle;
	
	//Constructor
	public function new(texture:Texture = null)
	{
		super();
		
		containerHeight = 0;
		containerWidth = 0;
		
		positionX = 0;
		positionY = 0;
		
		status = INTERACTIVE_STATUS_NORMAL;
		bgColors = getDefaultBackgroundColors();
		bgAlphas = getDefaultBackgroundAlphas();
		
		if (texture != null) {
			bgTexture = texture;
			
			graphics = new Image( bgTexture );
			addChild( graphics );
			setSize(Std.int(bgTexture.width), Std.int(bgTexture.height));
		}
		
		isOnStage = false;
		
		addEventListener( Event.ADDED_TO_STAGE, addToStageHandler );
	}
	
	//Public methods
	public function draw():Void
	{
		if ( !isOnStage ) return;
		
		if( containerWidth > 0 && containerHeight > 0 ){
			if( bgTexture != null ){
				graphics.texture = bgTexture;
			}else if( bgColors != null && bgColors.length > 1 ){
				
			}else if(  bgColors != null && bgColors.length > 0 && cast(bgAlphas[0]) > 0 ){
				
			}else{
				
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
		
		if( bgColors != null && bgTexture == null )
			statusLen = Std.int(Math.min(bgColors.length, 5));
		
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
		
		if( bgColors != null && bgTexture == null )
			statusLen = Std.int(Math.min(bgColors.length, 5));
			
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
		
		backgroundRect.width = w;
		backgroundRect.height = h;
		
		draw();
	}

	public function getSize():Square
	{
		return { width:containerWidth * getScale(), height:containerHeight * getScale() };
	}

	public function setPosition(cx:Float, cy:Float):Void
	{
		positionX = cx;
		positionY = cy;
		
		x = cx * getScale();
		y = cy * getScale();
	}

	public function getPosition():Position
	{
		return { x:positionX, y:positionY };
	}
	
	public function setPositionPoint(point:Position):Void
	{
		positionX = point.x;
		positionY = point.y;
		
		x = point.x * getScale();
		y = point.y * getScale();
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
		if ( !Std.is(texture, Texture) )
		{
			throw "";
		}else {
			bgTexture = texture;
			
			setSize(Std.int(bgTexture.width), Std.int(bgTexture.height));
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
	}
	
	public function getScale():Float
	{
		return scale;
	}
	
	public function getDispatcher():EventDispatcher
	{
		return null;
	}
	
	public function setMouseRender(value:Bool):Void
	{
		isMouseRender = value;
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

	public function removeAllChildren():Void
	{
		removeChildren();
	}

	override public function dispose():Void
	{
		removeAllChildren();
		removeEventListeners();
	}
	
	//Protected methods
	function mouseOverHandler(evt:TouchEvent):Void
	{
		//if( mouseEnabled ) status = selected?INTERACTIVE_STATUS_SELECTED:INTERACTIVE_STATUS_OVER;
		if( isMouseRender ) draw();
		if ( callbacks != null && callbacks.over != null ) callbacks.over(this);
	}
	
	function mouseOutHandler(evt:TouchEvent):Void
	{
		//if( mouseEnabled ) status = selected?INTERACTIVE_STATUS_SELECTED:INTERACTIVE_STATUS_NORMAL;
		if( isMouseRender ) draw();
		if ( callbacks != null && callbacks.out != null ) callbacks.out(this);
	}
	
	function mouseDownHandler(evt:TouchEvent):Void
	{
		//if( mouseEnabled ) status = selected?INTERACTIVE_STATUS_SELECTED:INTERACTIVE_STATUS_DOWN;
		if( isMouseRender ) draw();
		if ( callbacks != null && callbacks.down != null ) callbacks.down(this);
	}
	
	function mouseUpHandler(evt:TouchEvent):Void
	{
		//if( mouseEnabled ) status = selected?INTERACTIVE_STATUS_SELECTED:INTERACTIVE_STATUS_OVER;
		if( isMouseRender ) draw();
		if ( callbacks != null && callbacks.up != null ) callbacks.up(this);
	}
	
	function mouseClickHandler(evt:TouchEvent):Void
	{
		if( callbacks != null && callbacks.click != null ) callbacks.click(this);
	}
	
	function addToStageHandler(evt:Event = null):Void
	{
		if ( hasEventListener(Event.ADDED_TO_STAGE) )
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
		addEventListener(TouchEvent.TOUCH, mouseOverHandler );
		
		addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
		
		isOnStage = true;
		
		draw();
	}
	
	function removeFromStageHandler(evt:Event):Void
	{
		isOnStage = false;
		
		removeEventListeners();
		
		addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
	}
	//Private methods
}