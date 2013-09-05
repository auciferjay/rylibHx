package cn.royan.hl.uis.graphs.bases;

import cn.royan.hl.bases.PoolMap;
import cn.royan.hl.geom.Range;
import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.interfaces.uis.IUiGraphBase;
import cn.royan.hl.uis.graphs.UiGSprite;
import cn.royan.hl.uis.sparrow.Sparrow;
import cn.royan.hl.utils.SystemUtils;
import flash.sampler.NewObjectSample;

import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.BitmapData;

/**
 * ...
 * @author RoYan
 */
class UiGContainer extends UiGSprite
{
	static var WIDTH:Int 	= 256;
	static var HEIGHT:Int 	= 256;
	
	var current:String;
	var states:Array<String>;
	var items:Array<IUiGraphBase>;
	var bitmapdata:BitmapData;
	var blocks:Array<Rectangle>;
	
	public function new() 
	{
		super();
		
		states 	= [];
		items 	= [];
		blocks 	= [];
	}
	
	override public function updateDisplayList(item:IUiGraphBase = null):Void 
	{
		if ( item != null ) {
			blocks.push(item.getBound().clone());
		}
		super.updateDisplayList();
	}
	
	override public function draw():Void
	{
		if ( !updated ) return;
		
		var range:Rectangle;
		var width:Int 	= 0;
		var height:Int 	= 0;
		
		for ( item in items ) {
			range = item.getBound();
			width 	= Std.int(Math.max(width, range.x + range.width));
			height 	= Std.int(Math.max(height, range.y + range.height));
		}
		
		width 	= Std.int(Math.min(stage.getNativeStage().stageWidth, width));
		height 	= Std.int(Math.min(stage.getNativeStage().stageHeight, height));
		
		if ( width > containerWidth || height > containerHeight ) {
			if ( bitmapdata != null ) {
				bitmapdata.dispose();
			}
			
			setSize(width, height);
			bitmapdata = new BitmapData(containerWidth, containerHeight, true, 0x00FF);
			texture = Sparrow.fromBitmapData(bitmapdata);
		}
		
		var rects:Array<Rectangle> = [];
		var rect:Rectangle = new Rectangle(0, 0, WIDTH, HEIGHT);
		for ( block in blocks ) {
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
						bitmapdata.fillRect(rect, cast(0xFFFFFFFF * Math.random()));
					}
				}
			}
		}
		
		var point:Point = new Point();
		for ( item in items ) {
			if ( !item.getVisible() ) continue;
			item.draw();
			range = item.getBound();
			
			for ( rect in rects ) {
				if ( rect.containsRect(range) ) {
					point.x = range.x;
					point.y = range.y;
					
					bitmapdata.copyPixels(item.getTexture().bitmapdata, item.getTexture().regin, point, null, null, true);
				} else if ( rect.intersects(range) ) {
					var drawRect:Rectangle = range.intersection(rect);
					if ( drawRect.y != rect.y ) {
						if ( drawRect.x != rect.x ) {
							drawRect.x = 0;
							drawRect.y = 0;
							
							point.x = range.x;
							point.y = range.y;
						} else {
							drawRect.x = rect.x - range.x;
							drawRect.y = 0;
							
							point.x = rect.x;
							point.y = range.y;
						}
					} else {
						if ( drawRect.x != rect.x ) {
							drawRect.x = 0;
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
					bitmapdata.copyPixels(item.getTexture().bitmapdata, drawRect, point, null, null, true);
				}
			}
		}
		
		texture.bitmapdata = bitmapdata;
		
		blocks = [];
		
		updated = false;
	}
	
	/**
	 * 添加显示项
	 * @param	item
	 */
	public function addItem(item:IUiGraphBase):IUiGraphBase
	{
		items.push(item);
		
		item.setStage(stage);
		item.setParent(this);
		
		updateDisplayList(item);
		return item;
	}
	
	/**
	 * 添加显示项
	 * @param	item
	 * @param	index
	 */
	function addItemAt(item:IUiGraphBase, index:Int):IUiGraphBase
	{
		var prev:Array<IUiGraphBase> = items.slice(0, index);
		var next:Array<IUiGraphBase> = items.slice(index);
		
		prev.push(item);
		item.setStage(stage);
		item.setParent(this);
		
		items = prev.concat(next);
		
		updateDisplayList(item);
		return item;
	}
	
	/**
	 * 移除显示想
	 * @param	item
	 */
	function removeItem(item:IUiGraphBase):IUiGraphBase
	{
		items.remove(item);
		item.setStage(null);
		item.setParent(null);
		
		PoolMap.disposeInstance(item);
		updateDisplayList(item);
		return item;
	}
	
	/**
	 * 移除显示项
	 * @param	index
	 */
	function removeItemAt(index:Int):IUiGraphBase
	{
		var prev:Array<IUiGraphBase> = items.slice(0, index);
		var next:Array<IUiGraphBase> = items.slice(index);
		
		var item:IUiGraphBase = removeItem(next.shift());
		
		items = prev.concat(next);
		
		item.setStage(null);
		item.setParent(null);
		
		PoolMap.disposeInstance(item);
		updateDisplayList(item);
		return item;
	}
	
	/**
	 * 清空显示项
	 */
	function removeAllItems():Void
	{
		var item:IUiGraphBase;
		while ( items.length > 0 ) {
			item = items.shift();
			item.setStage(null);
			item.setParent(null);
			
			PoolMap.disposeInstance(item);
		}
		
		updateDisplayList();
	}
	
	/**
	 * 获取显示项
	 * @param	index
	 * @return
	 */
	function getItemAt(index:Int):IUiGraphBase
	{
		return items[index];
	}
	
	/**
	 * 获取显示项索引
	 * @param	item
	 * @return
	 */
	function getIndexByItem(item:IUiGraphBase):Int
	{
		for ( i in 0...items.length ) {
			if ( items[i] == item ) return i;
		}
		return -1;
	}
	
	/**
	 * 获取显示列表
	 * @return
	 */
	public function getItems():Array<IUiGraphBase>
	{
		return items;
	}
	
	public function setState(value:String):Void
	{
		SystemUtils.print(value, PrintConst.UIS);
		if( SystemUtils.arrayIndexOf( states, value ) == -1 ) return;
		
		current = value;
		
		var i:Int;
		for (item in items) {
			if ( item.getInclude() != null ) {
				if( SystemUtils.arrayIndexOf(item.getInclude(), current) != -1 ){
					item.setVisible(true);
				}else {
					item.setVisible(false);
				}
			}
			if ( item.getExclude() != null ) {
				if( SystemUtils.arrayIndexOf(item.getExclude(), current) != -1 ){
					item.setVisible(false);
				}else {
					item.setVisible(true);
				}
			}
		}
		
		updateDisplayList();
	}
	
	public function getState():String
	{
		return current;
	}
}