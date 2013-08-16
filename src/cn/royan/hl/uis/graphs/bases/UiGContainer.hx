package cn.royan.hl.uis.graphs.bases;

import cn.royan.hl.geom.Range;
import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.interfaces.uis.IUiGraphBase;
import cn.royan.hl.uis.graphs.InteractiveUiG;
import cn.royan.hl.uis.sparrow.Sparrow;
import cn.royan.hl.utils.SystemUtils;

import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.BitmapData;

/**
 * ...
 * @author RoYan
 */
class UiGContainer extends InteractiveUiG
{
	var states:Array<String>;
	var items:Array<IUiGraphBase>;
	var bitmapdata:BitmapData;
	var current:String;
	
	public function new() 
	{
		super();
		
		states = [];
		items = [];
		
		containerWidth 	= 0;
		containerHeight = 0;
	}
	
	override public function draw():Void
	{
		if ( !updated ) return;
		
		var range:Range = { };
		var width:Int 	= 0;
		var height:Int 	= 0;
		for ( item in items ) {
			range = item.getRange();
			width = Std.int(Math.max(width, range.x + range.width));
			height = Std.int(Math.max(height, range.y + range.height));
		}
		
		if ( width != containerWidth || height != containerHeight ) {
			if ( bitmapdata != null ) {
				bitmapdata.dispose();
			}
			
			containerWidth	= width;
			containerHeight = height;
			bitmapdata = new BitmapData(containerWidth, containerHeight, true, 0x00FF);
		} else {
			bitmapdata.fillRect(new Rectangle(0,0,containerWidth, containerHeight), 0x00FFFFFF);
		}
		
		var point:Point = new Point();
		for ( item in items ) {
			if ( !item.getVisible() ) continue;
			item.draw();
			range = item.getRange();
			point.x = range.x;
			point.y = range.y;
			bitmapdata.copyPixels(item.getTexture().bitmapdata, item.getTexture().regin, point, null, null, true);
		}
		
		bgTexture = Sparrow.fromBitmapData(bitmapdata);
		
		updated = false;
	}
	
	/**
	 * 添加显示项
	 * @param	item
	 */
	public function addItem(item:IUiGraphBase):IUiGraphBase
	{
		items.push(item);
		
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
		
		items = prev.concat(next);
		
		return item;
	}
	
	/**
	 * 移除显示想
	 * @param	item
	 */
	function removeItem(item:IUiGraphBase):IUiGraphBase
	{
		items.remove(item);
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
		
		return item;
	}
	
	/**
	 * 清空显示项
	 */
	function removeAllItems():Void
	{
		items = [];
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
	}
	
	public function getState():String
	{
		return current;
	}
}