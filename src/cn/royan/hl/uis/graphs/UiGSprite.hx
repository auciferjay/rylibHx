package cn.royan.hl.uis.graphs;

import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.uis.sparrow.Sparrow;
import cn.royan.hl.utils.SystemUtils;

import flash.geom.Point;
import flash.display.BitmapData;
import flash.ui.Mouse;
#if flash
import flash.ui.MouseCursor;
#end

/**
 * ...
 * @author RoYan
 */
class UiGSprite extends UiGDisplayObjectContainer
{
	public var buttonMode(getButtonMode, setButtonMode):Bool;
	public var dropTarget(getDropTarget, never):UiGDisplayObject;
	public var useHandCursor(default, setUseHandCursor):Bool;
	
	private var _cursorCallbackOut:Dynamic->Void;
	private var _cursorCallbackOver:Dynamic->Void;
	private var _dropTarget:UiGDisplayObject;
	private var _buttonMode:Bool;
	
	public function new(texture:Sparrow = null) 
	{
		super();
		
		_touchable = true;
		
		_graphics = new UiGGraphic(texture);
		
		if ( texture != null ) {
			if ( texture.frame != null ) {
				width 	= Std.int(texture.frame.width);
				height 	= Std.int(texture.frame.height);
			} else {
				width 	= Std.int(texture.regin.width);
				height	= Std.int(texture.regin.height);
			}
			/*
			var point:Point = new Point();
				point.x = _graphics.getTexture().frame != null ? -_graphics.getTexture().frame.x: 0;
				point.y = _graphics.getTexture().frame != null ? -_graphics.getTexture().frame.y: 0;
			
			_snap = new BitmapData(width, height, true, 0x00FF);
			_snap.copyPixels( _graphics.getTexture().bitmapdata, _graphics.getTexture().regin, point );
			*/
		}
		
		addEventListener(DatasEvent.MOUSE_OVER, mouseOverHandler);
		addEventListener(DatasEvent.MOUSE_OUT, mouseOutHandler);
	}
	
	function mouseOverHandler(evt:DatasEvent):Void
	{
		#if flash
		Mouse.cursor = _buttonMode?MouseCursor.BUTTON:MouseCursor.AUTO;
		#end
	}
	
	function mouseOutHandler(evt:DatasEvent):Void
	{
		#if flash
		Mouse.cursor = MouseCursor.AUTO;
		#end
	}
	
	public function getDropTarget():UiGDisplayObject
	{
		return _dropTarget;
	}
	
	public function setUseHandCursor(value:Bool):Bool
	{
		return useHandCursor;
	}
	
	public function setButtonMode(value:Bool):Bool
	{
		_buttonMode = value;
		return _buttonMode;
	}
	
	public function getButtonMode():Bool
	{
		return _buttonMode;
	}
}