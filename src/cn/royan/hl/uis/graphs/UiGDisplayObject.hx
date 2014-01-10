package cn.royan.hl.uis.graphs;

import cn.royan.hl.bases.DispatcherBase;
import cn.royan.hl.bases.WeakMap;
import cn.royan.hl.consts.UiConst;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.interfaces.uis.IUiGBase;
import cn.royan.hl.uis.sparrow.Sparrow;
import cn.royan.hl.uis.sparrow.SparrowManager;
import cn.royan.hl.utils.SystemUtils;
import flash.geom.Matrix;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Mouse;
#if flash
import flash.ui.MouseCursor;
#end

/**
 * ...
 * @author RoYan
 */
class UiGDisplayObject extends DispatcherBase, implements IUiGBase
{
	public var alpha:Float;
	public var name:String;
	public var parent(getParent, setParent):UiGDisplayObjectContainer;
	public var graphics(getGraphics, never):UiGGraphic;
	public var rotation(getRotation, setRotation):Float;
	public var scaleX(getScaleX, setScaleX):Float;
	public var scaleY(getScaleY, setScaleY):Float;
	public var stage(getStage, never):UiGStage;
	public var visible(getVisible, setVisible):Bool;
	public var width(getWidth, setWidth):Int;
	public var height(getHeight, setHeight):Int;
	public var touchable(getTouchable, setTouchable):Bool;
	public var x(getX, setX):Int;
	public var y(getY, setY):Int;
	
	private var _stage:UiGStage;
	private var _alpha:Float;
	private var _parent:UiGDisplayObjectContainer;
	private var _graphics:UiGGraphic;
	private var _renderFlags:Int;
	private var _bound:Rectangle;
	private var _globalbounds:Rectangle;
	private var _height:Int;
	private var _rotation:Float;
	private var _scaleX:Float;
	private var _scaleY:Float;
	private var _visible:Bool;
	private var _touchable:Bool;
	private var _width:Int;
	private var _x:Int;
	private var _y:Int;
	private var _touchstats:Array<Int>;
	
	private var _mapKeys:Array<String>;
	private static var _weakMap:WeakMap = WeakMap.getInstance();
	
	private var _transformationMatrix:Matrix;
	
	public static inline var RENDER_REFRESH:Int 	= 1;
	public static inline var RENDER_RESIZE:Int 		= 2;
	public static inline var RENDER_PICTURE:Int 	= 4;
	
	public function new() 
	{
		super();
		
		_bound = new Rectangle();
		_visible = true;
		_touchable = false;
		_touchstats = [];
		
		_transformationMatrix = new Matrix();
		
		_renderFlags = 0;
		
		_mapKeys = [];
	}
	
	public function hitTest(point:Point):Bool
	{
		return getBound().containsPoint(point);
	}
	
	public function touchTest(point:Point, isDown:Bool):UiGDisplayObject
	{
		if ( _touchable && hitTest(point) ) {
			//checkTouchStats(isDown?UiConst.TOUCHSTATS_IN_DOWN:UiConst.TOUCHSTATS_IN_UP);
			return this;
		}
		checkTouchStats(isDown?UiConst.TOUCHSTATS_OUT_DOWN:UiConst.TOUCHSTATS_OUT_UP);
		return null;
	}

	public function checkTouchStats(value:Int):Void
	{
		if ( _touchstats.length > 0 && _touchstats[_touchstats.length - 1] == value )
			return;
		
		_touchstats.push(value);
		var history:String = _touchstats.join("");
		var index:Int = -1;
		switch( value ) {
			case UiConst.TOUCHSTATS_IN_UP:
				index = history.lastIndexOf("21");
				if ( index != -1 )
					dispatchEvent(new DatasEvent(DatasEvent.MOUSE_UP));
				index = history.lastIndexOf("121");
				if ( index != -1 )
					dispatchEvent(new DatasEvent(DatasEvent.MOUSE_CLICK));
				if ( history == "1" )
					dispatchEvent(new DatasEvent(DatasEvent.MOUSE_OVER));
			case UiConst.TOUCHSTATS_IN_DOWN:
				index = history.lastIndexOf("12");
				if ( index != -1 )
					dispatchEvent(new DatasEvent(DatasEvent.MOUSE_DOWN));
				index = history.lastIndexOf("32");
				if( index != -1 )
					dispatchEvent(new DatasEvent(DatasEvent.MOUSE_OVER));
			case UiConst.TOUCHSTATS_OUT_UP:
				index = history.lastIndexOf("1230");
				if ( index != -1 )
					dispatchEvent(new DatasEvent(DatasEvent.MOUSE_RELEASE_OUT));
				index = history.lastIndexOf("10");
				if ( index != -1 )
					dispatchEvent(new DatasEvent(DatasEvent.MOUSE_OUT));
			case UiConst.TOUCHSTATS_OUT_DOWN:
				index = history.lastIndexOf("23");
				if ( index != -1 )
					dispatchEvent(new DatasEvent(DatasEvent.MOUSE_OUT));
		}
		
		if ( value == UiConst.TOUCHSTATS_OUT_UP ) {
			_touchstats = [];
		}
	}
	
	public function updateDisplayList(item:UiGDisplayObject = null):Void
	{
		if ( parent != null )
			parent.updateDisplayList(this);
		_renderFlags |= RENDER_REFRESH;
	}
	
	public function getRenderFlags():Int
	{
		return _renderFlags;
	}
	
	/**
	 * 画布刷新
	 */
	public function draw():Void
	{
		if ( _renderFlags == 0 ) return;
		_renderFlags = 0;
	}
	
	public function getRelativePosition(target:UiGDisplayObject=null):Rectangle
	{
		if ( _globalbounds != null && _renderFlags == 0 ) return _globalbounds;
		if ( target == null ) target = stage;
		var currentObject:UiGDisplayObject = this;
		var currentBounds = new Rectangle(0,0,width,height);
		while ( currentObject.parent != null )
		{
			if ( currentObject == target ) {
				_globalbounds = currentBounds;
				return currentBounds;
			} else {
				currentBounds.offset( currentObject.x, currentObject.y);
				currentObject = currentObject.parent;
			}
		}
		_globalbounds = currentBounds;
		return currentBounds;
	}
	
	public function getBound():Rectangle
	{
		_bound.x = _x;
		_bound.y = _y;
		_bound.width 	= _width;
		_bound.height 	= _height;
		return _bound;
	}
	
	public function getStage():UiGStage
	{
		if ( _renderFlags == 0 ) return _stage;
		var currentObject:UiGDisplayObject = this;
		while ( currentObject.parent != null )
		{
			if ( Std.is( currentObject.parent, UiGStage) ) {
				_stage = cast(currentObject.parent);
				return cast(currentObject.parent);
			}
			else
				currentObject = currentObject.parent;
		}
		_stage = null;
		return null;
	}
	
	public function setParent(value:UiGDisplayObjectContainer):UiGDisplayObjectContainer
	{
		_parent = value;
		updateDisplayList();
		return _parent;
	}
	
	public function getParent():UiGDisplayObjectContainer
	{
		return _parent;
	}
	
	public function getGraphics():UiGGraphic
	{
		return _graphics;
	}
	
	public function setRotation(value:Float):Float
	{
		_rotation = value;
		updateDisplayList();
		return _rotation;
	}
	
	public function getRotation():Float
	{
		return _rotation;
	}
	
	public function setVisible(value:Bool):Bool
	{
		_visible = value;
		updateDisplayList();
		return _visible;
	}
	
	public function getVisible():Bool
	{
		return _visible;
	}
	
	public function setAlpha(value:Float):Float
	{
		_alpha = value;
		updateDisplayList();
		return _alpha;
	}
	public function getAlpha():Float
	{
		return _alpha;
	}
	
	public function setScaleX(value:Float):Float
	{
		_scaleX = value;
		updateDisplayList();
		return _scaleX;
	}
	
	public function getScaleX():Float
	{
		return _scaleX;
	}
	
	public function setScaleY(value:Float):Float
	{
		_scaleY = value;
		updateDisplayList();
		return _scaleY;
	}
	
	public function getScaleY():Float
	{
		return _scaleY;
	}
	
	public function setWidth(value:Int):Int
	{
		_width = value;
		_renderFlags |= RENDER_RESIZE;
		updateDisplayList();
		return _width;
	}
	
	public function getWidth():Int
	{
		return _width;
	}
	
	public function setHeight(value:Int):Int
	{
		_height = value;
		_renderFlags |= RENDER_RESIZE;
		updateDisplayList();
		return _height;
	}
	
	public function getHeight():Int
	{
		return _height;
	}
	
	public function getTouchable():Bool
	{
		return _touchable;
	}
	
	public function setTouchable(value:Bool):Bool
	{
		_touchable = value;
		return _touchable;
	}
	
	public function setX(value:Int):Int
	{
		_x = value;
		updateDisplayList();
		return _x;
	}
	
	public function getX():Int
	{
		return _x;
	}
	
	public function setY(value:Int):Int
	{
		_y = value;
		updateDisplayList();
		return _y;
	}
	
	public function getY():Int
	{
		return _y;
	}
	
	public function dispose():Void
	{
		while ( _mapKeys.length > 0 ) {
			var key:String = _mapKeys.shift();
			
			_weakMap.clear( key );
			
			var keys:Array<String> = key.split("|");
			
			SparrowManager.disposeSparrow(keys[0], keys[1]);
		}
	}
	
	public function registSparrow(type:String, name:String, isNew:Bool=false):Sparrow
	{
		var sparrow:Sparrow = SparrowManager.getSparrow(type, name, isNew);
		_weakMap.set(type+"|"+name, sparrow);
		return sparrow;
	}
	
	public function registSparrows(type:String, name:String, isNew:Bool=false):Array<Sparrow>
	{
		var sparrows:Array<Sparrow> = SparrowManager.getSparrows(type, name, isNew);
		_weakMap.set(type+"|"+name, sparrows);
		return sparrows;
	}
}