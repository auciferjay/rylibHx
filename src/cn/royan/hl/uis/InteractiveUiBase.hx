package cn.royan.hl.uis;

import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.geom.Position;
import cn.royan.hl.geom.Square;
import cn.royan.hl.utils.SystemUtils;

import flash.display.BitmapData;
import flash.display.GradientType;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.EventDispatcher;
import flash.geom.Matrix;
import flash.geom.Point;
#if flash
import flash.utils.Dictionary;
#end

typedef UiBaseCallBack = {
	var click:Void->Void;
	var down:Void->Void;
	var up:Void->Void;
	var over:Void->Void;
	var out:Void->Void;
}

class InteractiveUiBase extends Sprite, implements IUiBase
{
	static public inline var INTERACTIVE_STATUS_NORMAL:Int 		= 0;
	static public inline var INTERACTIVE_STATUS_OVER:Int 		= 1;
	static public inline var INTERACTIVE_STATUS_DOWN:Int 		= 2;
	static public inline var INTERACTIVE_STATUS_SELECTED:Int 	= 3;
	static public inline var INTERACTIVE_STATUS_DISABLE:Int 	= 4;
	
	//properties
	var bgColors:Array<Int>;
	var bgAlphas:Array<Float>;
	var bgTexture:BitmapData;
	var containerWidth:Int;
	var containerHeight:Int;
	var callbacks:UiBaseCallBack;
	var isMouseRender:Bool;
	var status:Int;
	var matrix:Matrix;
	var selected:Bool;
	var isOnStage:Bool;

	var evtListenerType:Array<String>;
	var evtListenerDirectory:Array<Dynamic>;
	
	//Constructor
	public function new(texture:BitmapData = null)
	{
		super();

		bgColors = getDefaultBackgroundColors();
		bgAlphas = getDefaultBackgroundAlphas();
		
		if (texture != null) {
			bgTexture = texture;
		
			setSize(bgTexture.width, bgTexture.height);
		}
		
		isOnStage = false;
		
		if (stage != null) addToStageHandler();
		else addEventListener( Event.ADDED_TO_STAGE, addToStageHandler );
	}
	
	//Public methods
	public function draw():Void
	{
		if ( !isOnStage ) return;
		graphics.clear();

		if( containerWidth > 0 && containerHeight > 0 ){
			if( bgTexture != null ){
				graphics.beginBitmapFill(bgTexture);
				graphics.drawRect( 0, 0, containerWidth, containerHeight );
				graphics.endFill();
			}else if( bgAlphas != null && bgAlphas.length > 1 ){
				matrix.createGradientBox(containerWidth, containerHeight, Math.PI / 2, 0, 0);
				graphics.beginGradientFill(GradientType.LINEAR, bgColors, bgAlphas, [0,255], matrix);
				graphics.drawRect( 0, 0, containerWidth, containerHeight );
				graphics.endFill();
			}else if(  bgAlphas != null && bgAlphas.length > 0 && bgAlphas[0] > 0 ){
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
	
	public function getDefaultBackgroundColors():Array<Int>
	{
		return [0xFFFFFF];
	}
	
	public function getDefaultBackgroundAlphas():Array<Float>
	{
		return [1.0];
	}
	
	public function setBackgroundColors(value:Array<Int>):Void
	{
		bgColors = value;
	}
	
	public function getBackgroundColors():Array<Int>
	{
		return bgColors;
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
	
	public function setTexture(texture:BitmapData, frames:Int = 1):Void
	{
		bgTexture = texture;

		setSize(bgTexture.width, bgTexture.height);
	}
	
	public function getTexture():BitmapData
	{
		return bgTexture;
	}
	
	public function getDispatcher():EventDispatcher
	{
		return this;
	}

	override public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool=false, priority:Int=0, useWeakReference:Bool=false):Void
	{
		if ( evtListenerDirectory == null ) {
			evtListenerDirectory = [];
			evtListenerType = [];
		}
		#if flash
		var dic:Dictionary = new Dictionary();
		#else
		var dic:Array<Dynamic->Void> = [];
		#end
		untyped dic[ type ] = listener;
		evtListenerDirectory.push( dic );
		evtListenerType.push( type );
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}

	override public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool=false):Void
	{
		super.removeEventListener(type, listener, useCapture);
		if ( evtListenerDirectory != null ) {
			for ( i in 0...evtListenerDirectory.length ) {
				#if flash
				var dic:Dictionary = evtListenerDirectory[i];
				#else
				var dic:Array<Dynamic->Void> = evtListenerDirectory[i];
				#end
				if ( untyped dic[ type ] == null ) {
					continue;
				}else {
					if ( untyped dic[ type ] != listener ) {
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
			#if flash
			var dic:Dictionary = evtListenerDirectory[i];
			#else
			var dic:Array<Dynamic->Void> = evtListenerDirectory[i];
			#end
			var fun:Dynamic->Void = untyped dic[ type ];
			removeEventListener( type, fun );
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
		if ( callbacks != null && callbacks.over != null ) callbacks.over();
	}
	
	function mouseOutHandler(evt:MouseEvent):Void
	{
		if( mouseEnabled ) status = selected?INTERACTIVE_STATUS_SELECTED:INTERACTIVE_STATUS_NORMAL;
		if( isMouseRender ) draw();
		if ( callbacks != null && callbacks.out != null ) callbacks.out();
	}
	
	function mouseDownHandler(evt:MouseEvent):Void
	{
		if( mouseEnabled ) status = selected?INTERACTIVE_STATUS_SELECTED:INTERACTIVE_STATUS_DOWN;
		if( isMouseRender ) draw();
		if ( callbacks != null && callbacks.down != null ) callbacks.down();
	}
	
	function mouseUpHandler(evt:MouseEvent):Void
	{
		if( mouseEnabled ) status = selected?INTERACTIVE_STATUS_SELECTED:INTERACTIVE_STATUS_OVER;
		if( isMouseRender ) draw();
		if ( callbacks != null && callbacks.up != null ) callbacks.up();
	}
	
	function mouseClickHandler(evt:MouseEvent):Void
	{
		if( callbacks != null && callbacks.click != null ) callbacks.click();
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_DONE));
	}
	
	function addToStageHandler(evt:Event = null):Void
	{
		if ( hasEventListener(Event.ADDED_TO_STAGE) )
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