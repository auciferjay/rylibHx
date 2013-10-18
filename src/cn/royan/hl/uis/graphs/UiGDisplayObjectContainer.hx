package cn.royan.hl.uis.graphs;

import cn.royan.hl.interfaces.uis.IUiGBase;
import cn.royan.hl.uis.graphs.UiGDisplayObject;
import cn.royan.hl.uis.graphs.UiGStage;
import cn.royan.hl.uis.sparrow.Sparrow;
import cn.royan.hl.utils.SystemUtils;
import flash.display.BitmapData;

import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.BitmapData;

/**
 * ...
 * @author RoYan
 */
class UiGDisplayObjectContainer extends UiGDisplayObject
{
	static var WIDTH:Int 	= 256;
	static var HEIGHT:Int 	= 256;
	
	private var _current:String;
	private var _states:Array<String>;
	private var _items:Array<UiGDisplayObject>;
	private var _blocks:Array<Rectangle>;
	
	public function new() 
	{
		super();
		
		_states = [];
		_items 	= [];
		_blocks = [];
	}
	
	override public function updateDisplayList(item:UiGDisplayObject = null):Void 
	{
		if ( item != null ) {
			_blocks.push(item.getBound().clone());
		}
		super.updateDisplayList();
	}
	
	public function addChild(value:UiGDisplayObject):UiGDisplayObject
	{
		_items.push(value);
		
		value.setStage(stage);
		value.setParent(this);
		
		updateDisplayList(value);
		return value;
	}
	
	public function addChildAt(value:UiGDisplayObject, index:Int):UiGDisplayObject
	{
		var prev:Array<UiGDisplayObject> = _items.slice(0, index);
		var next:Array<UiGDisplayObject> = _items.slice(index);
		
		prev.push(value);
		value.setStage(stage);
		value.setParent(this);
		
		_items = prev.concat(next);
		
		updateDisplayList(value);
		return value;
	}
	
	public function removeChild(value:UiGDisplayObject):UiGDisplayObject
	{
		_items.remove(value);
		value.setStage(null);
		value.setParent(null);
		
		updateDisplayList(value);
		return value;
	}
	
	public function removeChildAt(index:Int):UiGDisplayObject
	{
		var prev:Array<UiGDisplayObject> = _items.slice(0, index);
		var next:Array<UiGDisplayObject> = _items.slice(index);
		
		var value:UiGDisplayObject = removeChild(next.shift());
		
		_items = prev.concat(next);
		
		value.setStage(null);
		value.setParent(null);
		
		updateDisplayList(value);
		return value;
	}
	
	public function removeChildren():Void
	{
		var item:UiGDisplayObject;
		while ( _items.length > 0 ) {
			item = _items.shift();
			item.setStage(null);
			item.setParent(null);
		}
		
		updateDisplayList();
	}
	
	override public function setStage(value:UiGStage):UiGStage 
	{
		for ( item in _items) {
			item.setStage(value);
		}
		return super.setStage(value);
	}
	
	override public function draw():Void
	{
		if ( !_renderFlags ) return;
		
		var range:Rectangle;
		var cWidth:Int 	= 0;
		var cHeight:Int = 0;
		
		for ( item in _items ) {
			if ( !item.getVisible() ) continue;
			item.draw();
			range = item.getBound();
			cWidth 	= Std.int(Math.max(cWidth, range.x + range.width));
			cHeight = Std.int(Math.max(cHeight, range.y + range.height));
		}
		
		if ( _graphics.getTexture() != null ) {
			cWidth 	= Std.int(_graphics.getTexture().frame != null ? _graphics.getTexture().frame.width : _graphics.getTexture().regin.width);
			cHeight = Std.int(_graphics.getTexture().frame != null ? _graphics.getTexture().frame.height : _graphics.getTexture().regin.height);
		}
		
		cWidth 	= Std.int(Math.min(stage.getNativeStage().stageWidth, cWidth));
		cHeight = Std.int(Math.min(stage.getNativeStage().stageHeight, cHeight));
		
		if ( cWidth > _width || cHeight > _height || _graphicFlags ) {
			if ( _snap != null ) {
				_snap.dispose();
			}
			
			width = cWidth;
			height = cHeight;
			_snap = new BitmapData(width, height, true, 0x00FF);
			if ( _graphics.getTexture() != null ) {
				_snap.copyPixels( _graphics.getTexture().bitmapdata, _graphics.getTexture().regin, new Point() );
			}
		}
		
		var point:Point = new Point();
		var rects:Array<Rectangle> = [];
		var rect:Rectangle = new Rectangle(0, 0, WIDTH, HEIGHT);
		var rectregin:Rectangle = null;
		var drawRect:Rectangle = null;
		for ( block in _blocks ) {
			var vx:Int = Math.ceil((block.x % WIDTH + block.width) / WIDTH);
			var vy:Int = Math.ceil((block.y % HEIGHT + block.height) / HEIGHT);
			
			for ( i in 0...vx ) {
				for ( j in 0...vy ) {
					rect.x = Std.int(block.x / WIDTH) * WIDTH + i * WIDTH;
					rect.y = Std.int(block.y / HEIGHT) * HEIGHT + j * HEIGHT;
					
					var isFind:Bool = false;
					for ( z in rects ) {
						if ( z.x == rect.x && z.y == rect.y ) {
							isFind = true;
							break;
						}
					}
					
					if ( !isFind ) {
						rects.push(rect.clone());
						
						rectregin = rect.clone();
						
						if ( _graphics.getTexture() != null ) {
							point.x = rect.x;
							point.y = rect.y;
							
							var cRect:Rectangle = _graphics.getTexture().frame != null ? _graphics.getTexture().frame: _graphics.getTexture().regin;
							
							rectregin.x += cRect.x;
							rectregin.y += cRect.y;
							
							_snap.copyPixels( _graphics.getTexture().bitmapdata, rectregin.intersection(cRect), point );
						} else
							_snap.fillRect( rect, 0x00FF );
					}
				}
			}
		}
		
		for ( item in _items ) {
			if ( !item.getVisible() ) continue;
			range = item.getBound().clone();
			
			for ( rect in rects ) {
				if ( rect.containsRect(range) ) {
					point.x = range.x;
					point.y = range.y;
					
					drawRect = range.clone();
					drawRect.x = 0;
					drawRect.y = 0;
					
					_snap.copyPixels(item.snap, drawRect, point, null, null, true);
				} else if ( rect.intersects(range) ) {
					drawRect = range.intersection(rect);
					if ( drawRect.y != rect.y ) {
						if ( drawRect.x != rect.x ) {
							drawRect.x = drawRect.x - range.x;
							drawRect.y = drawRect.y - range.y;

							point.x = range.x;
							point.y = range.y;
						} else {
							drawRect.x = rect.x - range.x;
							drawRect.y = drawRect.y - range.y;

							point.x = rect.x;
							point.y = range.y;
						}
					} else {
						if ( drawRect.x != rect.x ) {
							drawRect.x = drawRect.x - range.x;
							drawRect.y = rect.y - range.y;

							point.x = range.x;
							point.y = rect.y;
						} else {
							drawRect.x = rect.x - range.x;
							drawRect.y = rect.y - range.y;

							point.x = rect.x;
							point.y = rect.y;
						}
					}
					
					_snap.copyPixels(item.snap, drawRect, point, null, null, true);
				}
			}
		}
		
		_blocks = [];
		
		_renderFlags = false;
		_graphicFlags = false;
	}
	
	override public function touchTest(point:Point, isDown:Bool):UiGDisplayObject
	{
		_items.reverse();
		var dp:Point = new Point();
		var touchObj:UiGDisplayObject = null;
		for ( item in _items ) {
			if ( item.touchable ) {
				dp.x = getBound().x;
				dp.y = getBound().y;
				
				var temp:UiGDisplayObject = item.touchTest(point.subtract(dp), isDown);
				if( touchObj == null )
					touchObj = temp;
			}
		}
		_items.reverse();
		if ( touchObj != null ) return touchObj;
		return super.touchTest(point.subtract(dp), isDown);
	}
}