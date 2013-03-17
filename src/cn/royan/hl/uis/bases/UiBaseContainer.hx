package cn.royan.hl.uis.bases;

import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.interfaces.uis.IUiContainerBase;
import cn.royan.hl.interfaces.uis.IUiItemStateBase;
import cn.royan.hl.interfaces.uis.IUiContainerStateBase;
import cn.royan.hl.uis.InteractiveUiBase;
import cn.royan.hl.utils.SystemUtils;

import flash.display.DisplayObject;
import flash.display.BitmapData;

/**
 * ...
 * @author RoYan
 */

class UiBaseContainer extends InteractiveUiBase,implements IUiContainerBase, implements IUiContainerStateBase
{
	var states:Array<String>;
	var current:String;
	
	var items:Array<IUiBase>;
	var container:InteractiveUiBase;
	
	public function new(texture:BitmapData = null)
	{
		super(texture);
		
		items = [];
		
		states = [];
		
		container = new InteractiveUiBase();
		addChild(container);
		
		setBackgroundAlphas([0]);
	}
	
	public function addItem(item:IUiBase):Void
	{
		items.push(item);
		
		container.addChild(cast( item, DisplayObject ));
		
		draw();
	}
	
	public function addItemAt(item:IUiBase, index:Int):Void
	{
		var prev:Array<IUiBase> = items.slice(0, index);
		var next:Array<IUiBase> = items.slice(index);
		
		prev.push(item);
		
		items = prev.concat(next);
		
		container.addChild(cast( item, DisplayObject ));
		
		draw();
	}
	
	public function removeItem(item:IUiBase):Void
	{
		items.remove(item);
		container.removeChild(cast(item, DisplayObject));
		
		draw();
	}
	
	public function removeItemAt(index:Int):Void
	{
		var prev:Array<IUiBase> = items.slice(0, index);
		var next:Array<IUiBase> = items.slice(index);
		
		removeItem(prev.pop());
		
		items = prev.concat(next);
	}
	
	public function removeAllItems():Void
	{
		while ( items.length > 0 ) {
			removeItem(items.shift());
		}
		
		draw();
	}
	
	public function getItemAt(index:Int):IUiBase
	{
		return items[index];
	}
	
	public function getIndexByItem(item:IUiBase):Int
	{
		for ( i in 0...items.length ) {
			if ( items[i] == item ) return i;
		}
		return -1;
	}
	
	public function getItems():Array<IUiBase>
	{
		return items;
	}
	
	public function setState(value:String):Void
	{
		if( SystemUtils.arrayIndexOf( states, value ) == -1 ) return;
		
		current = value;
		
		var i:Int;
		for(i in 0...numChildren){
			if( Std.is(getChildAt(i), IUiItemStateBase) ){
				var item:IUiItemStateBase = cast(getChildAt(i), IUiItemStateBase);
				if ( item.getInclude() != null ) {
					if( SystemUtils.arrayIndexOf(item.getInclude(), current) != -1 ){
						cast(item, DisplayObject).visible = true;
					}else {
						cast(item, DisplayObject).visible = false;
					}
				}
				if ( item.getExclude() != null ) {
					if( SystemUtils.arrayIndexOf(item.getExclude(), current) != -1 ){
						cast(item, DisplayObject).visible = false;
					}else {
						cast(item, DisplayObject).visible = true;
					}
				}
			}
		}
	}
	
	public function getState():String
	{
		return current;
	}
}