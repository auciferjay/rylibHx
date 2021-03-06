package cn.royan.hl.uis.starling;

import cn.royan.hl.bases.Dictionary;
import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.consts.UiConst;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.geom.Range;
import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.uis.style.Style;
import cn.royan.hl.utils.BitmapDataUtils;
import cn.royan.hl.utils.SystemUtils;

import flash.geom.Rectangle;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
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
class InteractiveUiS extends Sprite, implements IUiBase
{
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
	
	var borderThick:Int;
	var borderColor:Int;
	var borderAlpha:Float;
	var borderRx:Int;
	var borderRy:Int;
	
	var containerWidth:Float;
	var containerHeight:Float;
	var positionX:Float;
	var positionY:Float;
	
	var mouseEnabled:Bool;
	
	var excludes:Array<String>;
	var includes:Array<String>;

	var evtListenerType:Array<String>;
	var evtListenerDirectory:Array<Dynamic>;
	
	var type:Int;
	
	public var graphics:Image;
	public var buttonMode:Bool;
	
	private var _isOver:Bool;
	
	//Constructor
	public function new(texture:Texture = null)
	{
		super();
		
		scale = 1;
		
		containerHeight = 0;
		containerWidth = 0;
		
		positionX = 0;
		positionY = 0;
		
		status = UiConst.INTERACTIVE_STATUS_NORMAL;
		
		_isOver = false;
		
		if (texture != null) {
			bgTexture = texture;
			
			type = 1;
			setSize(Std.int(bgTexture.frame != null ? bgTexture.frame.width : bgTexture.width ), 
					Std.int(bgTexture.frame != null ? bgTexture.frame.height : bgTexture.height ));
		}
		
		if ( containerHeight > 0 && containerWidth > 0 ) {
			graphics = new Image(texture != null?texture:Texture.fromBitmapData(BitmapDataUtils.fromColors(Std.int(containerWidth), Std.int(containerHeight), 
									[0x000000], [0x00], 1, borderColor, borderThick, borderAlpha, borderRx, borderRy)));
			addChild( graphics );
		}
		
		isOnStage = false;
		
		addEventListener( Event.ADDED_TO_STAGE, addToStageHandler );
	}
	
	//Public methods
	public function draw():Void
	{
		if ( !isOnStage ) return;
		
		if ( containerWidth > 0 && containerHeight > 0 && graphics != null ) {
			SystemUtils.print(bgTexture + ":" + defaultTexture, PrintConst.UIS);
			
			if ( type == 0 ) {
				if ( graphics != null ) graphics.dispose();
				graphics = new Image(getDefaultTexture());
				graphics.touchable = false;
				addChild( graphics );
			} else {
				graphics.texture = bgTexture;
			}
			graphics.scaleX = graphics.scaleY = getScale();
		}
	}
	
	public function getDefaultTexture():Dynamic
	{
		return Texture.fromBitmapData(BitmapDataUtils.fromColors(Std.int(containerWidth), Std.int(containerHeight), 
										bgColors, bgAlphas, 1, borderColor, borderThick, borderAlpha, borderRx, borderRy));
	}
	
	public function setColorsAndAplhas(color:Array<Dynamic>, alpha:Array<Dynamic>):Void
	{
		SystemUtils.print(color+":"+alpha, PrintConst.UIS);
		bgColors = color;
		bgAlphas = alpha;
		
		while ( bgAlphas.length < bgColors.length ) {
			bgAlphas.push(bgAlphas[bgAlphas.length - 1]);
		}
		
		while ( bgColors.length < bgAlphas.length ) {
			bgColors.push(bgColors[bgColors.length - 1]);
		}
		
		type = 0;
		
		setSize(containerWidth, containerHeight);
	}
	
	public function getColors():Array<Dynamic>
	{
		return bgColors;
	}
	
	public function getAlphas():Array<Dynamic>
	{
		return bgAlphas;
	}
	
	public function setBorder(thick:Int, color:Int, alpha:Float, rx:Int=0, ry:Int=0):Void
	{
		borderThick = thick;
		borderColor = color;
		borderAlpha = alpha;
		borderRx	= rx;
		borderRy 	= ry;
	}
	
	public function setCallbacks(value:Dynamic):Void
	{
		if ( callbacks == null ) callbacks = { };
		var fields:Array<String> = Reflect.fields(value);
		for ( field in fields ) {
			Reflect.setField(callbacks, field, Reflect.field(value, field));
		}
	}
	
	public function setSize(w:Float, h:Float):Void
	{
		SystemUtils.print(w + ":" + h, PrintConst.UIS);
		containerWidth = w;
		containerHeight = h;
		
		draw();
	}

	public function setPosition(cx:Float, cy:Float):Void
	{
		SystemUtils.print(cx+":"+cy, PrintConst.UIS);
		positionX = cast Math.floor(cx);
		positionY = cast Math.floor(cy);
		
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
			
			type = 1;
			
			if ( graphics != null ) {
				removeChild(graphics);
				graphics.dispose();
			}
			graphics = new Image(bgTexture);
			graphics.touchable = false;
			addChildAt(graphics, 0);
			
			setSize(Std.int(bgTexture.width), Std.int(bgTexture.height));
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
	
	public function setStyle(value:Style):Void
	{
		
	}
	
	public function getDispatcher():EventDispatcher
	{
		return null;
	}
	
	public function setEnabled(value:Bool):Void
	{
		status = value?UiConst.INTERACTIVE_STATUS_NORMAL:UiConst.INTERACTIVE_STATUS_DISABLE;
		
		setMouseRender(value);
		
		if ( !value ) mouseOutHandler();
		
		draw();
	}
	
	public function getEnabled():Bool
	{
		return status != UiConst.INTERACTIVE_STATUS_DISABLE;
	}
	
	public function setMouseRender(value:Bool):Void
	{
		isMouseRender = value;
		mouseEnabled = value;
		touchable = value;
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
		if ( graphics != null )
			graphics.dispose();
		if ( bgTexture != null )
			bgTexture.dispose();
		removeAllChildren();
		removeEventListeners();
		
		super.dispose();
	}
	
	function mouseTouchHandler(evt:TouchEvent):Void
	{
        if ( !mouseEnabled ) return;
		
		if ( evt.getTouch(this, TouchPhase.HOVER) != null ) {
			if ( getBounds(this).containsPoint(evt.getTouch(this, TouchPhase.HOVER).getLocation(this)) ) {
				if ( buttonMode )
					Mouse.cursor = MouseCursor.BUTTON;
				if( !getBounds(this).containsPoint(evt.getTouch(this, TouchPhase.HOVER).getPreviousLocation(this)) ){
					mouseOverHandler(evt.getTouch(this, TouchPhase.HOVER));
					_isOver = true;
				}else if ( !_isOver ) {
					mouseOverHandler(evt.getTouch(this, TouchPhase.HOVER));
					_isOver = true;
				}
			}
        } else if (	evt.getTouch(this, TouchPhase.HOVER) == null ){
			mouseOutHandler();
			_isOver = false;
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
		SystemUtils.print(touch, PrintConst.UIS);
		if ( mouseEnabled ) status = selected?UiConst.INTERACTIVE_STATUS_SELECTED:UiConst.INTERACTIVE_STATUS_OVER;
		if ( isMouseRender ) draw();
		if ( callbacks != null && callbacks.over != null ) callbacks.over(this, touch);
		
		if ( buttonMode ) {
			//Mouse.cursor = MouseCursor.BUTTON;
			dispatchEvent(new Event(UiConst.BUTTON_MOUSE_OVER, true));
		}
	}
	
	function mouseOutHandler():Void
	{
		SystemUtils.print("", PrintConst.UIS);
		if ( mouseEnabled ) status = selected?UiConst.INTERACTIVE_STATUS_SELECTED:UiConst.INTERACTIVE_STATUS_NORMAL;
		if ( isMouseRender ) draw();
		if ( callbacks != null && callbacks.out != null ) callbacks.out(this);
		
		Mouse.cursor = MouseCursor.AUTO;
	}
	
	function mouseDownHandler(touch:Touch):Void
	{
		SystemUtils.print(touch, PrintConst.UIS);
		if ( mouseEnabled ) status = selected?UiConst.INTERACTIVE_STATUS_SELECTED:UiConst.INTERACTIVE_STATUS_DOWN;
		if ( isMouseRender ) draw();
		if ( callbacks != null && callbacks.down != null ) callbacks.down(this, touch);
	}
	
	function mouseUpHandler(touch:Touch):Void
	{
		SystemUtils.print(touch, PrintConst.UIS);
		if ( mouseEnabled ) status = selected?UiConst.INTERACTIVE_STATUS_SELECTED:UiConst.INTERACTIVE_STATUS_OVER;
		if ( isMouseRender ) draw();
		if ( callbacks != null && callbacks.up != null ) callbacks.up(this, touch);
	}
	
	function mouseMoveHandler(touch:Touch):Void
	{
		SystemUtils.print(touch, PrintConst.UIS);
		if ( callbacks != null && callbacks.move != null ) callbacks.move(this, touch);
	}
	
	function mouseClickHandler(touch:Touch):Void
	{
		SystemUtils.print(touch, PrintConst.UIS);
		if( callbacks != null && callbacks.click != null ) callbacks.click(this, touch);
	}
	
	function addToStageHandler(evt:Event = null):Void
	{
		SystemUtils.print(evt, PrintConst.UIS);
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