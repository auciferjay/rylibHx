package cn.royan.hl.uis.bases;

import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.interfaces.uis.IUiGroupBase;
import cn.royan.hl.interfaces.uis.IUiSelectBase;
import cn.royan.hl.events.DatasEvent;
import flash.events.Event;

class UiBaseGroupContainer extends UiBaseContainer, implements IUiGroupBase
{
	var selectedItems:Array<IUiBase>;
	var isMulti:Bool;
	var isMust:Bool;
	var maxLen:Int;
	var values:Array<Dynamic>;
	
	public function new() 
	{
		super();
		
		selectedItems = [];
		values = [];
	}
	
	//Public methods
	public function addGroupItem(item:IUiSelectBase, value:Dynamic=null):Void
	{
		item.setInGroup(true);
		
		items.push(item);
		values.push(value);
		
		item.getDispatcher().addEventListener(DatasEvent.DATA_DONE, itemSelectHandler);
		
		addChild(item);
		
		draw();
	}
	
	public function getSelectedItems():Array<IUiSelectBase>
	{
		return selectedItems;
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
	
	override public function addItem(item:IUiBase):Void 
	{
		//super.addItem(item);
	}
	
	override public function addItemAt(item:IUiBase, index:Int):Void 
	{
		//super.addItemAt(item, index);
	}
	
	override public function dispose():Void 
	{
		super.dispose();
		
		for ( item in items ) {
			item.dispose();
		}
	}
	
	//Protect methods
	override private function addToStageHandler(evt:Event = null):Void 
	{
		super.addToStageHandler(evt);
		
		for ( item in items ) {
			item.getDispatcher().addEventListener(DatasEvent.DATA_DONE, itemSelectHandler);
		}
	}
	
	override private function removeFromStageHandler(evt:Event):Void 
	{
		super.removeFromStageHandler(evt);
		
		for ( item in items ) {
			item.getDispatcher().removeEventListener(DatasEvent.DATA_DONE, itemSelectHandler);
		}
	}
	
	function itemSelectHandler(evt:DatasEvent):Void
	{
		/*
		var key:* = getKey(evt.currentTarget);
		var giveUpKey:*;
		if(values.indexOf(key) == -1){
			if(!isMust){
				values.splice(values.indexOf(key), 1);
				selectedItems[key].setSelected(false);
			}
		}else{
			if( isMulti ){
				if( maxLen > values.length )
				{
					values.push(key);
				}else{
					giveUpKey = values.shift();
					if(selectedItems[giveUpKey])
						selectedItems[giveUpKey].setSelected(false);
					values.push(key);
					selectedItems[key].setSelected(true);
				}
			}else{
				giveUpKey = values.shift();
				if(selectedItems[giveUpKey])
					selectedItems[giveUpKey].setSelected(false);
				values = [key];
				selectedItems[key].setSelected(true);
			}
		}*/
	}
}