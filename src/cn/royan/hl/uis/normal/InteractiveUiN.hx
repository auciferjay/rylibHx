package cn.royan.hl.uis.normal;

import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.interfaces.uis.IUiItemStateBase;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.bases.Dictionary;
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

class InteractiveUiN extends Sprite, implements IUiBase, implements IUiItemStateBase
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
	var defaultTexture:Sparrow;
	var bgTexture:Sparrow;
	
	var callbacks:Dynamic;
	var isMouseRender:Bool;
	var status:Int;
	var statusLen:Int;
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
	
	var background:Bitmap;
	
	//Constructor
	public function new(texture:Sparrow = null)
	{
		super();
		
		scale = 1;
		
		originalDPI = DeviceCapabilities.dpi;
		
		containerHeight = 0;
		containerWidth 	= 0;
		
		positionX = 0;
		positionY = 0;
		
		status = INTERACTIVE_STATUS_NORMAL;
		
		background = new Bitmap();
		addChild(background);
		
		if (texture != null) {
			bgTexture = texture;
			
			setSize(Std.int(bgTexture.regin.width), Std.int(bgTexture.regin.height));
		}
		
		isOnStage = false;
		
		addEventListener( Event.ADDED_TO_STAGE, addToStageHandler );
	}
	
	//Public methods
	public function draw():Void
	{
		if ( !isOnStage ) return; 
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
	
	public function setEnabled(value:Bool):Void
	{
		status = value?INTERACTIVE_STATUS_NORMAL:INTERACTIVE_STATUS_DISABLE;
		mouseChildren = value;
		mouseEnabled = value;
		draw();
	}
	
	public function getEnabled():Bool
	{
		return status != INTERACTIVE_STATUS_DISABLE;
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

	override public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool=false, priority:Int=0, useWeakReference:Bool=false):Void
	{
		if ( evtListenerDirectory == null ) {
			evtListenerDirectory = [];
			evtListenerType = [];
		}
		var dic:Dictionary = #if flash new Dictionary(); #else {}; #end
		Reflect.setField(dic, type, listener);
		evtListenerDirectory.push( dic );
		evtListenerType.push( type );
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}

	override public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool=false):Void
	{
		super.removeEventListener(type, listener, useCapture);
		if ( evtListenerDirectory != null ) {
			for ( i in 0...evtListenerDirectory.length ) {
				var dic:Dictionary = evtListenerDirectory[i];
				if ( Reflect.field(dic, type) == null ) {
					continue;
				}else {
					if ( Reflect.field(dic, type) != listener ) {
						continue;
					}else {
						evtListenerType.splice( i, 1 );
						evtListenerDirectory.splice( i, 1 );
						Reflect.deleteField( dic, type );
						dic = null;
						break;
					}
				}
			}
		}
	}

	public function removeAllEventListeners():Void
	{
		if ( evtListenerType == null || evtListenerType.length == 0)
			return;
		
		for ( i in 0...evtListenerType.length)
		{
			var type:String = evtListenerType[i];
			var dic:Dictionary = evtListenerDirectory[i];
			if ( dic == null ||  Reflect.field(dic, type) == null ) {
				continue;
			}else {
				var fun:Dynamic->Void =  Reflect.field(dic, type);
				removeEventListener( type, fun );
			}
		}
	}

	public function removeAllChildren():Void
	{
		while( numChildren > 0 ){
			removeChildAt(0);
		}
	}

	public function dispose():Void
	{
		removeAllChildren();
		removeAllEventListeners();
	}
	
	//Protected methods
	function mouseOverHandler(evt:MouseEvent):Void
	{
		if( mouseEnabled ) status = selected?INTERACTIVE_STATUS_SELECTED:INTERACTIVE_STATUS_OVER;
		if( isMouseRender ) draw();
		if ( callbacks != null && callbacks.over != null ) callbacks.over(this);
	}
	
	function mouseOutHandler(evt:MouseEvent):Void
	{
		if( mouseEnabled ) status = selected?INTERACTIVE_STATUS_SELECTED:INTERACTIVE_STATUS_NORMAL;
		if( isMouseRender ) draw();
		if ( callbacks != null && callbacks.out != null ) callbacks.out(this);
	}
	
	function mouseDownHandler(evt:MouseEvent):Void
	{
		if( mouseEnabled ) status = selected?INTERACTIVE_STATUS_SELECTED:INTERACTIVE_STATUS_DOWN;
		if( isMouseRender ) draw();
		if ( callbacks != null && callbacks.down != null ) callbacks.down(this);
	}
	
	function mouseUpHandler(evt:MouseEvent):Void
	{
		if( mouseEnabled ) status = selected?INTERACTIVE_STATUS_SELECTED:INTERACTIVE_STATUS_OVER;
		if( isMouseRender ) draw();
		if ( callbacks != null && callbacks.up != null ) callbacks.up(this);
	}
	
	function mouseClickHandler(evt:MouseEvent):Void
	{
		if( callbacks != null && callbacks.click != null ) callbacks.click(this);
	}
	
	function addToStageHandler(evt:Event = null):Void
	{
		if ( hasEventListener(Event.ADDED_TO_STAGE) )
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
		addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, 	false, 99, true );
		addEventListener(MouseEvent.MOUSE_OUT, 	mouseOutHandler, 	false, 99, true );
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, 	false, 99, true );
		addEventListener(MouseEvent.MOUSE_UP, 	mouseUpHandler, 	false, 99, true );
		addEventListener(MouseEvent.CLICK, 		mouseClickHandler, 	false, 99, true );
		
		addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
		
		isOnStage = true;
		
		draw();
	}
	
	function removeFromStageHandler(evt:Event):Void
	{
		isOnStage = false;
		
		#if flash
		removeAllEventListeners();
		#end
		
		addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
	}
	//Private methods
}