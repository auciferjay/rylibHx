package cn.royan.hl.uis.starling;

import cn.royan.hl.bases.Dictionary;
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
import starling.events.Touch;
import starling.events.TouchPhase;
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
	
	static public inline var STATUS_LEN:Int = 5;
	//properties
	var originalDPI:Int;
	var scale:Float;
	
	var bgColors:Array<Dynamic>;
	var bgAlphas:Array<Dynamic>;
	var defaultTexture:Texture;
	var bgTexture:Texture;
	var callbacks:Dynamic;
	var isMouseRender:Bool;
	var status:Int;
	var selected:Bool;
	var isOnStage:Bool;
	
	var containerWidth:Float;
	var containerHeight:Float;
	var positionX:Float;
	var positionY:Float;
	
	var mouseEnabled:Bool;
	
	var excludes:Array<String>;
	var includes:Array<String>;

	var evtListenerType:Array<String>;
	var evtListenerDirectory:Array<Dynamic>;
	
	public var graphics:Image;
	
	//Constructor
	public function new(texture:Texture = null)
	{
		super();
		
		scale = 1;
		
		containerHeight = 0;
		containerWidth = 0;
		
		positionX = 0;
		positionY = 0;
		
		status = INTERACTIVE_STATUS_NORMAL;
		
		if (texture != null) {
			bgTexture = texture;
			
			setSize(Std.int(bgTexture.width), Std.int(bgTexture.height));
		}
		
		if ( containerHeight > 0 && containerWidth > 0 ) {
			graphics = new Image(Texture.fromBitmapData(BitmapDataUtils.fromColors(Std.int(containerWidth), Std.int(containerHeight), [0x000000], [0x00])));
			addChild( graphics );
		}
		
		isOnStage = false;
		
		addEventListener( Event.ADDED_TO_STAGE, addToStageHandler );
	}
	
	//Public methods
	public function draw():Void
	{
		if ( !isOnStage ) return;
		
		if( containerWidth > 0 && containerHeight > 0 ){
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
		callbacks = value;
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
	
	public function setMouseRender(value:Bool):Void
	{
		isMouseRender = value;
		mouseEnabled = value;
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
	
	function mouseTouchHandler(evt:TouchEvent):Void
	{
        if ( !mouseEnabled ) return;
		
		if (evt.getTouch(this, TouchPhase.HOVER) != null) {
			mouseOverHandler(evt.getTouch(this, TouchPhase.HOVER));
        } else {
			mouseOutHandler();
        }
		
		if (evt.getTouch(this, TouchPhase.BEGAN) != null) {
			mouseDownHandler(evt.getTouch(this, TouchPhase.BEGAN));
		}
		
		if (evt.getTouch(this, TouchPhase.ENDED) != null) {
			mouseUpHandler(evt.getTouch(this, TouchPhase.ENDED));
			mouseClickHandler(evt.getTouch(this, TouchPhase.ENDED));
        }
		
		if (evt.getTouch(this, TouchPhase.MOVED) != null) {
			mouseMoveHandler(evt.getTouch(this, TouchPhase.MOVED));
		}
	}
	
	//Protected methods
	function mouseOverHandler(touch:Touch):Void
	{
		if ( mouseEnabled ) status = selected?INTERACTIVE_STATUS_SELECTED:INTERACTIVE_STATUS_OVER;
		if ( isMouseRender ) draw();
		if ( callbacks != null && callbacks.over != null ) callbacks.over(this, touch);
	}
	
	function mouseOutHandler():Void
	{
		if ( mouseEnabled ) status = selected?INTERACTIVE_STATUS_SELECTED:INTERACTIVE_STATUS_NORMAL;
		if ( isMouseRender ) draw();
		if ( callbacks != null && callbacks.out != null ) callbacks.out(this);
	}
	
	function mouseDownHandler(touch:Touch):Void
	{
		if ( mouseEnabled ) status = selected?INTERACTIVE_STATUS_SELECTED:INTERACTIVE_STATUS_DOWN;
		if ( isMouseRender ) draw();
		if ( callbacks != null && callbacks.down != null ) callbacks.down(this, touch);
	}
	
	function mouseUpHandler(touch:Touch):Void
	{
		if ( mouseEnabled ) status = selected?INTERACTIVE_STATUS_SELECTED:INTERACTIVE_STATUS_OVER;
		if ( isMouseRender ) draw();
		if ( callbacks != null && callbacks.up != null ) callbacks.up(this, touch);
	}
	
	function mouseMoveHandler(touch:Touch):Void
	{
		if ( callbacks != null && callbacks.move != null ) callbacks.move(this, touch);
	}
	
	function mouseClickHandler(touch:Touch):Void
	{
		if( callbacks != null && callbacks.click != null ) callbacks.click(this, touch);
	}
	
	function addToStageHandler(evt:Event = null):Void
	{
		if ( hasEventListener(Event.ADDED_TO_STAGE) )
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
		addEventListener(TouchEvent.TOUCH, mouseTouchHandler );
		
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