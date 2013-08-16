package cn.royan.hl.uis.starling.units;

import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.interfaces.uis.IUiContainerBase;

import flash.display.BitmapData;

/**
 * ...
 * @author RoYan
 */
class UiSContainerUnit
{
	var isUpdated:Bool;
	var items:Array<IUiBase>;
	var containerWidth:Int;
	var containerHeight:Int;
	var bitmapdata:BitmapData;
	
	public function new() 
	{
		items = [];
		
		containerWidth 	= 0;
		containerHeight = 0;
	}
	
	public function draw():BitmapData
	{
		for ( item in items ) {
			containerWidth 	= Math.max(containerWidth, item.getRange().x, item.getRange.width);
			containerHeight = Math.max(containerHeight, item.getRange().y, item.getRange.height);
		}
		if ( bitmapdata != null ) {
			bitmapdata.dispose();
		}
		bitmapdata = new BitmapData(containerWidth, containerHeight, true, 0x00000000);
		for ( item in items ) {
			
		}
	}
	
	/**
	 * 添加显示项
	 * @param	item
	 */
	public function addItem(item:IUiBase):IUiBase
	{
		isUpdated = true;
		items.push(item);
		
		return item;
	}
	
	/**
	 * 添加显示项
	 * @param	item
	 * @param	index
	 */
	function addItemAt(item:IUiBase, index:Int):IUiBase
	{
		isUpdated = true;
		var prev:Array<IUiBase> = items.slice(0, index);
		var next:Array<IUiBase> = items.slice(index);
		
		prev.push(item);
		
		items = prev.concat(next);
		
		return item;
	}
	
	/**
	 * 移除显示想
	 * @param	item
	 */
	function removeItem(item:IUiBase):IUiBase
	{
		isUpdated = true;
		items.remove(item);
		return item;
	}
	
	/**
	 * 移除显示项
	 * @param	index
	 */
	function removeItemAt(index:Int):IUiBase
	{
		isUpdated = true;
		var prev:Array<IUiBase> = items.slice(0, index);
		var next:Array<IUiBase> = items.slice(index);
		
		var item:IUiBase = removeItem(next.shift());
		
		items = prev.concat(next);
		
		return item;
	}
	
	/**
	 * 清空显示项
	 */
	function removeAllItems():Void
	{
		isUpdated = true;
		items = [];
	}
	
	/**
	 * 获取显示项
	 * @param	index
	 * @return
	 */
	function getItemAt(index:Int):IUiBase
	{
		return items[index]
	}
	
	/**
	 * 获取显示项索引
	 * @param	item
	 * @return
	 */
	function getIndexByItem(item:IUiBase):Int
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
	public function getItems():Array<IUiBase>
	{
		return items;
	}
}