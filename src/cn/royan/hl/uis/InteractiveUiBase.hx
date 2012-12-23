package cn.royan.hl.uis;

import cn.royan.hl.interfaces.uis.IUiBase
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.geom.Position;
import cn.royan.hl.geom.Square;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.EventDispatcher;
import flash.geom.Matrix;
import flash.geom.Point;

class InteractiveUiBase extends Sprite, implements IUiBase
{
	static public inline var INTERACTIVE_STATUS_NORMAL:Int 		= 0;
	static public inline var INTERACTIVE_STATUS_OVER:Int 		= 1;
	static public inline var INTERACTIVE_STATUS_DOWN:Int 		= 2;
	static public inline var INTERACTIVE_STATUS_SELECTED:Int 	= 3;
	static public inline var INTERACTIVE_STATUS_DISABLE:Int 	= 4;
	
	//properties
	var bgColors:Array<UInt>;
	var bgAlphas:Array<UInt>;
	var bgTexture:BitmapData;
	var containerWidth:Int;
	var containerHeight:Int;
	var callbacks:Dynamic;
	var isMouseRender:Bool;
	var status:Int;
	var matrix:Matrix;
	var isOnStage:Bool;

	var evtListenerType:Array;
	var evtListenerDirectory:Array;
	
	//Constructor
	function new(texture:BitmapData = Null)
	{
		super();

		bgColors = getDefaultBackgroundColors();
		bgAlphas = getDefaultBackgroundAlphas();
		
		if (texture != Null) {
			bgTexture = texture;
		
			setSize(bgTexture.width, bgTexture.height);
		}
		
		isOnStage = false;
		
		if (stage) addToStageHandler();
		else addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
	}
	
	//Public methods
	public function draw():Void
	{
		if ( !isOnStage ) return;
		graphics.clear();
		if( containerWidth > 0 && containerHeight > 0 ){
			if( bgTexture != Null ){
				graphics.beginBitmapFill(bgTexture);
				graphics.drawRect( 0, 0, containerWidth, containerHeight );
				graphics.endFill();
			}else if( bgAlphas != Null && bgAlphas.length > 1 ){
				matrix.createGradientBox(containerWidth, containerHeight, Math.PI / 2, 0, 0);
				graphics.beginGradientFill(GradientType.LINEAR, bgColors, bgAlphas, [0,255], matrix);
				graphics.drawRect( 0, 0, containerWidth, containerHeight );
				graphics.endFill();
			}else if(  bgAlphas != Null && bgAlphas.length > 0 && bgAlphas[0] > 0 ){
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
	
	public function getDefaultBackgroundColors():Array<UInt>
	{
		return [0xFFFFFF];
	}
	
	public function getDefaultBackgroundAlphas():Array<Float>
	{
		return [1.0];
	}
	
	public function setBackgroundColors(value:Array<UInt>):Void
	{
		bgColors = value;
	}
	
	public function getBackgroundColors():Array<UInt>
	{
		return bgColors
	}
	
	public function setBackgroundAlphas(value:Array<Float>):Void
	{
		bgAlphas = value;
	}
	
	public function getBackgroundAlphas():Array<Float>
	{
		return bgAlphas;
	}
	
	public function setSize(w:Int, h:Int):Void
	{
		containerWidth = w;
		containerHeight = h;
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
		return { x:x, y:y };
	}
	
	public function setPositionPoint(point:Position):Void
	{
		x = point.x;
		y = point.y;
	}
	
	public function setTexture(texture:BitmapData, frames:UInt = 1):Void
	{
		bgTexture = texture;
	}
	
	public function getTexture():BitmapData
	{
		return bgTexture;
	}
	
	public function getDispatcher():EventDispatcher
	{
		return this;
	}

	override public function addEventListener(type:String, listener:Function, useCapture:Bool = false, priority:int = 0, useWeakReference:Bool = false):Void
	{
		if ( evtListenerDirectory == Null ) {
			evtListenerDirectory = [];
			evtListenerType = [];
		}
		var dir:Dictionary = new Dictionary();
		dir[ type ] = listener;
		evtListenerDirectory.push( dir );
		evtListenerType.push( type );
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}

	override public function removeEventListener(type:String, listener:Function, useCapture:Bool = false):Void
	{
		super.removeEventListener(type, listener, useCapture);
		if ( evtListenerDirectory != Null ) {
			for ( i in 0...evtListenerDirectory.length ) {
				var dir:Dictionary = evtListenerDirectory[i];
				if ( dir[ type ] == Null ) {
					continue;
				}else {
					if ( dir[ type ] != listener ) {
						continue
					}else {
						evtListenerType.splice( i, 1 );
						evtListenerDirectory.splice( i, 1 );
						delete dir[ type ];
						dir = Null;
						break;
					}
				}
			}
		}
	}

	public function removeAllEventListeners():Void
	{
		if ( evtListenerType == Null || evtListenerType.length == 0)
			return;
		for ( i in 0...evtListenerType.length)
		{
			var type:String = evtListenerType[i];
			var dic:Dictionary = evtListenerDirectory[i];
			var fun:Function = dic[ type ];
			removeEventListener( type, fun );
		}
	}

	public function removeAllChildren():Void
	{
		while( numChildren ){
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
		if ( callbacks != Null && callbacks["over"] != Null ) callbacks["over"]();
	}
	
	function mouseOutHandler(evt:MouseEvent):Void
	{
		if( mouseEnabled ) status = selected?INTERACTIVE_STATUS_SELECTED:INTERACTIVE_STATUS_NORMAL;
		if( isMouseRender ) draw();
		if ( callbacks != Null && callbacks["out"] != Null ) callbacks["out"]();
	}
	
	function mouseDownHandler(evt:MouseEvent):Void
	{
		if( mouseEnabled ) status = selected?INTERACTIVE_STATUS_SELECTED:INTERACTIVE_STATUS_DOWN;
		if( isMouseRender ) draw();
		if ( callbacks != Null && callbacks["down"] != Null ) callbacks["down"]();
	}
	
	function mouseUpHandler(evt:MouseEvent):Void
	{
		if( mouseEnabled ) status = selected?INTERACTIVE_STATUS_SELECTED:INTERACTIVE_STATUS_OVER;
		if( isMouseRender ) draw();
		if ( callbacks != Null && callbacks["up"] != Null ) callbacks();
	}
	
	function mouseClickHandler(evt:MouseEvent):Void
	{
		if( callbacks != Null && callbacks["click"] != Null ) callbacks["click"]();
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_DONE));
	}
	
	function addToStageHandler(evt:Event = Null):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE)
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		
		addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler );
		addEventListener(MouseEvent.MOUSE_OUT, 	mouseOutHandler );
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler );
		addEventListener(MouseEvent.MOUSE_UP, 	mouseUpHandler );
		addEventListener(MouseEvent.CLICK, 		mouseClickHandler );
		
		addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
		
		isOnStage = true;
		
		draw();
	}
	
	function removeFromStageHandler(evt:Event):Void
	{
		isOnStage = false;
		
		removeAllEventListeners();
		addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
	}
	//Private methods
}