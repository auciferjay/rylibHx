package cn.royan.hl.uis.graphs;

import cn.royan.hl.interfaces.uis.IUiGBase;
import cn.royan.hl.uis.graphs.UiGDisplayObject;
import cn.royan.hl.uis.graphs.UiGStage;
import cn.royan.hl.uis.sparrow.Sparrow;
import cn.royan.hl.utils.SystemUtils;
import flash.geom.Matrix;

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
	
	private var _stageSnap:BitmapData;
	
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
			_blocks.push(item.getRelativePosition());
		}
		super.updateDisplayList();
	}
	
	public function addChild(value:UiGDisplayObject):UiGDisplayObject
	{
		_items.push(value);
		
		value.setParent(this);
		
		updateDisplayList(value);
		return value;
	}
	
	public function addChildAt(value:UiGDisplayObject, index:Int):UiGDisplayObject
	{
		var prev:Array<UiGDisplayObject> = _items.slice(0, index);
		var next:Array<UiGDisplayObject> = _items.slice(index);
		
		prev.push(value);
		value.setParent(this);
		
		_items = prev.concat(next);
		
		updateDisplayList(value);
		return value;
	}
	
	public function removeChild(value:UiGDisplayObject, needDispose:Bool=false):UiGDisplayObject
	{
		_items.remove(value);
		
		if ( needDispose ) value.dispose();
		
		value.setParent(null);
		
		updateDisplayList(value);
		return value;
	}
	
	public function removeChildAt(index:Int, needDispose:Bool=false):UiGDisplayObject
	{
		var prev:Array<UiGDisplayObject> = _items.slice(0, index);
		var next:Array<UiGDisplayObject> = _items.slice(index);
		
		var value:UiGDisplayObject = removeChild(next.shift());
		
		_items = prev.concat(next);
		
		if ( needDispose ) value.dispose();
		
		value.setParent(null);
		
		updateDisplayList(value);
		return value;
	}
	
	public function removeChildren(needDispose:Bool=false):Void
	{
		var item:UiGDisplayObject;
		while ( _items.length > 0 ) {
			item = _items.shift();
			
			if ( needDispose ) item.dispose();
			
			item.setParent(null);
		}
		
		updateDisplayList();
	}
	
	public function getNumChildren():Int
	{
		return _items.length;
	}
	
	override public function draw():Void
	{
		if ( _renderFlags == 0 ) return;

		var range:Rectangle;
		var point:Point = new Point();
		var rects:Array<Rectangle> = [];
		var rect:Rectangle = new Rectangle(0, 0, WIDTH, HEIGHT);
		var drawRect:Rectangle = null;
		var texture:Sparrow;
		var isFull:Bool = false;
		if ( _stageSnap == null ) _stageSnap = stage.getSnap();
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
						rects.push(new Rectangle(rect.x, rect.y, rect.width, rect.height));
						
						_stageSnap.fillRect(rect, 0x00FF);
					}
				}
			}
			
			isFull = rects.length >= vx * vx;
		}
		
		var item:UiGDisplayObject;
		for ( i in 0..._items.length ) {
			item = _items[i];
			if ( !item.getVisible() ) continue;
			item.draw();
			
			if ( item.getGraphics().getTexture() == null ) continue;
			
			range = item.getRelativePosition();
			texture = item.getGraphics().getTexture();
			
			if ( isFull ) {
				point.x = range.x - (texture.frame != null?texture.frame.x:0);
				point.y = range.y - (texture.frame != null?texture.frame.y:0);
				
				drawRect = new Rectangle(texture.regin.x, texture.regin.y, texture.regin.width, texture.regin.height);
				
				_stageSnap.copyPixels(texture.bitmapdata, drawRect, point, null, null, true);
					
				continue;
			}
			
			for ( rect in rects ) {
				if ( rect.containsRect(range) ) {//contains changed rect
					point.x = range.x - (texture.frame != null?texture.frame.x:0);
					point.y = range.y - (texture.frame != null?texture.frame.y:0);
					
					drawRect = new Rectangle(texture.regin.x, texture.regin.y, texture.regin.width, texture.regin.height);
					
					_stageSnap.copyPixels(texture.bitmapdata, drawRect, point, null, null, true);
				} else if ( rect.intersects(range) ) {
					//drawRect = range.intersection(rect);
					var offset:Rectangle = texture.frame != null?texture.frame:new Rectangle();
					if ( range.y >= rect.y ) {//top
						if ( range.x <= rect.x ) {//left top
							point.x = range.x - (texture.frame != null?texture.frame.x:0);
							point.y = range.y - (texture.frame != null?texture.frame.y:0);
							
							drawRect = new Rectangle(texture.regin.x, texture.regin.y, texture.regin.width, texture.regin.height);
							drawRect.width = Math.min(drawRect.width, rect.x + rect.width - range.x + offset.x);
							drawRect.height = Math.min(drawRect.height, rect.y + rect.height - range.y + offset.y);
						} else {//right top
							point.x = rect.x;
							point.y = range.y - (texture.frame != null?texture.frame.y:0);
							
							drawRect = new Rectangle(texture.regin.x, texture.regin.y, texture.regin.width, texture.regin.height);
							if ( rect.x - range.x + offset.x > 0 ) {
								drawRect.x += rect.x - range.x + offset.x;
								drawRect.width -= rect.x - range.x + offset.x;
							}
							
							drawRect.height = Math.min(drawRect.height, rect.y + rect.height - range.y + offset.y);
						}
					} else {//bottom
						if ( range.x <= rect.x ) {//left bottom
							point.x = range.x - (texture.frame != null?texture.frame.x:0);
							point.y = rect.y;
							
							drawRect = new Rectangle(texture.regin.x, texture.regin.y, texture.regin.width, texture.regin.height);
							if ( rect.y - range.y + offset.y > 0 ) {
								drawRect.y += rect.y - range.y + offset.y;
								drawRect.height -= rect.y - range.y + offset.y;
							}
							
							drawRect.width = Math.min(drawRect.width, rect.x + rect.width - range.x + offset.x);
						} else {//right bottom
							point.x = rect.x;
							point.y = rect.y;
							
							drawRect = new Rectangle(texture.regin.x, texture.regin.y, texture.regin.width, texture.regin.height);
							if ( rect.x - range.x + offset.x > 0 ) {
								drawRect.x += rect.x - range.x + offset.x;
								drawRect.width -= rect.x - range.x + offset.x;
							} else {
								drawRect.width = Math.min(drawRect.width, rect.x + rect.width - range.x + offset.x);
							}
							
							if ( rect.y - range.y + offset.y > 0 ) {
								drawRect.y += rect.y - range.y + offset.y;
								drawRect.height -= rect.y - range.y + offset.y;
							} else {
								drawRect.height = Math.min(drawRect.height, rect.y + rect.height - range.y + offset.y);
							}
						}
					}
					_stageSnap.copyPixels(texture.bitmapdata, drawRect, point, null, null, true);
				}
			}
		}
		_blocks = [];
		_renderFlags = 0;
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