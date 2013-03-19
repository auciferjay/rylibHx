package cn.royan.hl.uis.bases;

import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.interfaces.uis.IUiItemGroupBase;
import cn.royan.hl.interfaces.uis.IUiContainerGroupBase;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.utils.SystemUtils;
import flash.events.MouseEvent;

import flash.display.DisplayObject;
import flash.display.BitmapData;

class UiBaseContainerGroup extends UiBaseContainerAlign, implements IUiContainerGroupBase
{
	var isMulti:Bool;
	var isMust:Bool;
	var maxLen:Int;
	var keys:Array<Dynamic>;
	var selects:Array<IUiItemGroupBase>;
	var values:Array<Dynamic>;
	
	public function new(texture:BitmapData = null) 
	{
		super(texture);
		
		maxLen = 2;
		isMust = true;
		isMulti = true;
		keys = [];
		
		selects = [];
		values = [];
	}
	
	//Public methods
	public function addGroupItem(item:IUiItemGroupBase, key:Dynamic = null):Void
	{
		item.setInGroup(true);
		
		items.push(item);
		keys.push(key);
		
		item.getDispatcher().addEventListener(MouseEvent.CLICK, itemSelectHandler);
		
		container.addChild(cast( item, DisplayObject ));
		
		draw();
	}
	
	public function addGroupItemAt(item:IUiItemGroupBase, index:Int, key:Dynamic = null):Void
	{
		var prev:Array<IUiBase> = items.slice(0, index);
		var next:Array<IUiBase> = items.slice(index);
		
		var pkey:Array<Dynamic> = keys.slice(0, index);
		var nkey:Array<Dynamic> = keys.slice(index);
		
		prev.push(item);
		pkey.push(key);
		
		items = prev.concat(next);
		keys = pkey.concat(nkey);
		
		item.getDispatcher().addEventListener(MouseEvent.CLICK, itemSelectHandler);
		
		container.addChild(cast( item, DisplayObject ));
		
		draw();
	}
	
	public function removeGroupItem(item:IUiItemGroupBase):Void
	{
		var index:Int = SystemUtils.arrayIndexOf(items, item);
		if ( index != -1 ) {
			keys.splice(index, 1);
		}
		items.remove(item);
		
		item.getDispatcher().removeEventListener(MouseEvent.CLICK, itemSelectHandler);
		container.removeChild(cast(item, DisplayObject));
		
		draw();
	}
	
	public function removeGroupItemAt(index:Int):Void
	{
		var prev:Array<IUiBase> = items.slice(0, index);
		var next:Array<IUiBase> = items.slice(index);
		
		removeItem(prev.pop());
		
		items = prev.concat(next);
	}
	
	public function removeAllGroupItems():Void
	{
		while ( items.length > 0 ) {
			var item:IUiBase = items.shift();
				item.getDispatcher().removeEventListener(MouseEvent.CLICK, itemSelectHandler);
			removeItem(item);
		}
	}
	
	public function getGroupItemAt(index:Int):IUiItemGroupBase
	{
		return cast(super.getItemAt(index));
	}
	
	public function getIndexByGroupItem(item:IUiItemGroupBase):Int
	{
		return cast(super.getIndexByItem(item));
	}
	
	public function getGroupItems():Array<IUiItemGroupBase>
	{
		return cast(super.getItems());
	}
	
	public function getSelectedItems():Array<IUiItemGroupBase>
	{
		return selects;
	}
	
	public function getValues():Array<Dynamic>
	{
		return values;
	}
	
	public function setIsMust(value:Bool):Void
	{
		isMust = value;
	}
	
	public function setIsMulti(value:Bool):Void
	{
		isMulti = value;
	}
	
	public function setMaxLen(value:Int):Void
	{
		maxLen = value;
	}
	
	override public function dispose():Void 
	{
		super.dispose();
		
		for ( item in items ) {
			item.dispose();
		}
	}
	
	function itemSelectHandler(evt:MouseEvent):Void
	{
		var key:Dynamic = getKey( cast(evt.currentTarget) );
		var giveUpKey:Dynamic = null;
		var index:Int = SystemUtils.arrayIndexOf(values, key);
		var giveUpIndex:Int = 0;
		var current:IUiItemGroupBase = cast(items[SystemUtils.arrayIndexOf(keys, key)]);
		if ( index == -1 ) {
			if( isMulti ){
				if( maxLen <= values.length )
				{
					giveUpKey = values[0];
					giveUpIndex = SystemUtils.arrayIndexOf(keys, giveUpKey);
					
					if ( items[giveUpIndex] != null ) {
						selects.shift();
						values.shift();
						cast(items[giveUpIndex]).setSelected(false);
					}
				}
				
				values.push(key);
				selects.push(current);
				current.setSelected(true);
				
				dispatchEvent(new DatasEvent(DatasEvent.DATA_CHANGE));
			}else{
				giveUpKey = values[0];
				giveUpIndex = SystemUtils.arrayIndexOf(keys, giveUpKey);
				
				if ( items[giveUpIndex] != null ) {
					selects.shift();
					values.shift();
					cast(items[giveUpIndex]).setSelected(false);
				}
				
				values = [key];
				selects = [current];
				current.setSelected(true);
				
				dispatchEvent(new DatasEvent(DatasEvent.DATA_CHANGE));
			}
		}else{//找到(取消)
			if( !isMust ){//不是必须的
				values.splice(index, 1);
				selects.splice(index, 1);
				current.setSelected(false);
				
				dispatchEvent(new DatasEvent(DatasEvent.DATA_CHANGE));
			}
		}
	}
	
	function getKey(value:IUiItemGroupBase):Dynamic
	{
		var index:Int = SystemUtils.arrayIndexOf(items, value);
		if ( index != -1 ) {
			return keys[index];
		}
		return null;
	}
	
	//Protect methods
	override private function addToStageHandler(evt:Event = null):Void 
	{
		super.addToStageHandler(evt);
		
		for ( item in items ) {
			item.getDispatcher().addEventListener(MouseEvent.CLICK, itemSelectHandler);
		}
	}
	
	override private function removeFromStageHandler(evt:Event):Void 
	{
		super.removeFromStageHandler(evt);
		
		for ( item in items ) {
			item.getDispatcher().removeEventListener(MouseEvent.CLICK, itemSelectHandler);
		}
	}
	
	override public function addItem(item:IUiBase):Void {}
	
	override public function addItemAt(item:IUiBase, index:Int):Void {}
	
	override public function removeItem(item:IUiBase):Void {}
	
	override public function removeItemAt(index:Int):Void {}
	
	override public function removeAllItems():Void {}
}