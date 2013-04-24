package cn.royan.hl.uis.normal;

import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.interfaces.uis.IUiItemStateBase;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.bases.Dictionary;
import cn.royan.hl.geom.Position;
import cn.royan.hl.geom.Square;
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

class InteractiveUiN extends Sprite, implements IUiBase, implements IUiItemStateBase
{
	static public inline var INTERACTIVE_STATUS_NORMAL:Int 		= 0;
	static public inline var INTERACTIVE_STATUS_OVER:Int 		= 1;
	static public inline var INTERACTIVE_STATUS_DOWN:Int 		= 2;
	static public inline var INTERACTIVE_STATUS_SELECTED:Int 	= 3;
	static public inline var INTERACTIVE_STATUS_DISABLE:Int 	= 4;
	
	//properties
	var originalDPI:Int;
	
	var bgColors:Array<Dynamic>;
	var bgAlphas:Array<Dynamic>;
	var bgTexture:Sparrow;
	var containerWidth:Int;
	var containerHeight:Int;
	var callbacks:Dynamic;
	var isMouseRender:Bool;
	var status:Int;
	var statusLen:Int;
	var matrix:Matrix;
	var selected:Bool;
	var isOnStage:Bool;
	
	var excludes:Array<String>;
	var includes:Array<String>;

	var evtListenerType:Array<String>;
	var evtListenerDirectory:Array<Dynamic>;
	
	var background:Bitmap;
	var backgroundRect:Rectangle;
	
	//Constructor
	public function new(texture:Sparrow = null)
	{
		super();
		
		containerHeight = 0;
		containerWidth = 0;
		
		status = INTERACTIVE_STATUS_NORMAL;
		bgColors = getDefaultBackgroundColors();
		bgAlphas = getDefaultBackgroundAlphas();
		
		backgroundRect = new Rectangle();
		
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
			if ( bgTexture != null ) {
				background.bitmapData.copyPixels(bgTexture.bitmapdata, bgTexture.regin, new Point());
			}else if( bgColors != null && bgColors.length > 1 ){
				matrix.createGradientBox(containerWidth, containerHeight, Math.PI / 2, 0, 0);
				graphics.beginGradientFill(GradientType.LINEAR, cast(bgColors), bgAlphas, [0,255], matrix);
				graphics.drawRect( 0, 0, containerWidth, containerHeight );
				graphics.endFill();
			}else if(  bgColors != null && bgColors.length > 0 && cast(bgAlphas[0]) > 0 ){
				graphics.beginFill( cast(bgColors[0]), bgAlphas[0] );
				graphics.drawRect( 0, 0, containerWidth, containerHeight );
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
	
	public function setSize(w:Int, h:Int):Void
	{
		containerWidth = w;
		containerHeight = h;
		
		background.bitmapData = new BitmapData(w, h, true, 0xFFFFFF);
		
		backgroundRect.width 	= w;
		backgroundRect.height 	= h;
		
		draw();
	}

	public function getSize():Square
	{
		return { width:containerWidth, height:containerHeight };
	}

	public function setPosition(cx:Int, cy:Int):Void
	{
		x = cx;
		y = cy;
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
	
	public function setPositionRange(value:Rectangle):Void
	{
		setSize(cast(value.width), cast(value.height));
		setPosition(cast(value.x), cast(value.y));
	}
	
	public function getRange():Rectangle
	{
		return backgroundRect;
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
	
	public function setOriginalDPI(value:Int):Void
	{
		originalDPI = value;
	}
	
	public function getOriginalDPI():Int
	{
		return originalDPI;
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
		var dic:Dictionary = new Dictionary();
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