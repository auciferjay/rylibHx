package cn.royan.hl.uis.normal.bases;

import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.interfaces.uis.IUiContainerBase;
import cn.royan.hl.interfaces.uis.IUiItemStateBase;
import cn.royan.hl.interfaces.uis.IUiContainerStateBase;
import cn.royan.hl.uis.normal.InteractiveUiN;
import cn.royan.hl.uis.sparrow.Sparrow;
import cn.royan.hl.utils.SystemUtils;

import flash.events.Event;
import flash.display.DisplayObject;

/**
 * ...
 * @author RoYan
 */
class UiNContainer extends InteractiveUiN, implements IUiContainerBase, implements IUiContainerStateBase
{
	var states:Array<String>;
	var current:String;
	
	var items:Array<IUiBase>;
	
	public function new(texture:Sparrow = null)
	{
		super(texture);
		
		items = [];
		
		states = [];
		
		//setBackgroundAlphas([0]);
	}
	
	override private function addToStageHandler(evt:Event = null):Void 
	{
		super.addToStageHandler(evt);
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_CHANGE));
	}
	
	public function addItem(item:IUiBase):Void
	{
		SystemUtils.print(item, PrintConst.UIS);
		items.push(item);
		
		item.setScale(getScale());
		
		addChild(cast( item, DisplayObject ));
		
		draw();
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_CHANGE));
	}
	
	public function addItemAt(item:IUiBase, index:Int):Void
	{
		SystemUtils.print(item+":"+index, PrintConst.UIS);
		var prev:Array<IUiBase> = items.slice(0, index);
		var next:Array<IUiBase> = items.slice(index);
		
		prev.push(item);
		
		items = prev.concat(next);
		
		item.setScale(getScale());
		
		addChildAt(cast( item, DisplayObject ), index);
		
		draw();
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_CHANGE));
	}
	
	public function removeItem(item:IUiBase):Void
	{
		SystemUtils.print(item, PrintConst.UIS);
		items.remove(item);
		removeChild(cast(item, DisplayObject));
		
		draw();
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_CHANGE));
	}
	
	public function removeItemAt(index:Int):Void
	{
		SystemUtils.print(index, PrintConst.UIS);
		var prev:Array<IUiBase> = items.slice(0, index);
		var next:Array<IUiBase> = items.slice(index);
		
		removeItem(next.shift());
		
		items = prev.concat(next);
	}
	
	public function removeAllItems():Void
	{
		while ( items.length > 0 ) {
			removeItem(items.shift());
		}
		
		draw();
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_CHANGE));
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

	override public function setScale(value:Float):Void
	{
		super.setScale(value);

		for ( item in items ) {
			item.setScale(getScale());
		}
	}
	
	public function setState(value:String):Void
	{
		SystemUtils.print(value, PrintConst.UIS);
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