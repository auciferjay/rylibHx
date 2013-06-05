package cn.royan.hl.uis.starling.bases;

import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.interfaces.uis.IUiContainerGroupBase;
import cn.royan.hl.interfaces.uis.IUiItemGroupBase;
import cn.royan.hl.utils.SystemUtils;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.textures.Texture;

/**
 * ...
 * @author RoYan
 */
class UiSContainerGroup extends UiSContainerAlign, implements IUiContainerGroupBase
{
	var isMulti:Bool;
	var isMust:Bool;
	var maxLen:Int;
	var keys:Array<Dynamic>;
	var selects:Array<IUiItemGroupBase>;
	var values:Array<Dynamic>;
	
	public function new(texture:Texture = null) 
	{
		super(texture);
		
		maxLen = 2;
		isMust = true;
		isMulti = true;
		
		selects = [];
		values = [];
		keys = [];
	}
	
	//Public methods
	public function addGroupItem(item:IUiItemGroupBase, key:Dynamic = null):IUiItemGroupBase
	{
		item.setInGroup(true);
		
		items.push(item);
		untyped keys.push(key != null ? key : cast(item));
		
		item.setCallbacks({click:itemSelectHandler});
		
		item.setScale(getScale());

		addChild(cast( item, DisplayObject ));
		
		draw();
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new Event(DatasEvent.DATA_CHANGE));
		
		return item;
	}
	
	public function addGroupItemAt(item:IUiItemGroupBase, index:Int, key:Dynamic = null):IUiItemGroupBase
	{
		item.setInGroup(true);
		
		var prev:Array<IUiBase> = items.slice(0, index);
		var next:Array<IUiBase> = items.slice(index);
		
		var pkey:Array<Dynamic> = keys.slice(0, index);
		var nkey:Array<Dynamic> = keys.slice(index);
		
		prev.push(item);
		untyped pkey.push(key != null ? key : cast(item));
		
		items = prev.concat(next);
		keys = pkey.concat(nkey);
		
		item.setCallbacks({click:itemSelectHandler});

		item.setScale(getScale());

		addChild(cast( item, DisplayObject ));
		
		draw();
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new Event(DatasEvent.DATA_CHANGE));
		
		return item;
	}
	
	public function removeGroupItem(item:IUiItemGroupBase):IUiItemGroupBase
	{
		var index:Int = SystemUtils.arrayIndexOf(items, item);
		if ( index != -1 ) {
			keys.splice(index, 1);
		}
		items.remove(item);
		
		removeChild(cast(item, DisplayObject));
		
		draw();
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new Event(DatasEvent.DATA_CHANGE));
		
		return item;
	}
	
	public function removeGroupItemAt(index:Int):IUiItemGroupBase
	{
		var prev:Array<IUiBase> = items.slice(0, index);
		var next:Array<IUiBase> = items.slice(index);
		
		var item:IUiItemGroupBase = removeGroupItem(cast(prev.pop(), IUiItemGroupBase));
		
		items = prev.concat(next);
		
		return item;
	}
	
	public function removeAllGroupItems():Void
	{
		while ( items.length > 0 ) {
			var item:IUiBase = items.shift();
			removeItem(item);
		}
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new Event(DatasEvent.DATA_CHANGE));
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
	
	public function setValues(array:Array<Dynamic>):Void
	{
		var i:Int;
		for( i in 0...values.length){
			getValue(values[i]).setSelected(false);
		}
		values = array;
		for(i in 0...array.length){
			getValue(array[i]).setSelected(true);
		}
	}
	
	function getValue(key:Dynamic):IUiItemGroupBase
	{
		for ( i in 0...keys.length )
		{
			if( keys[i] == key )
			{
				return cast items[i];
			}
		}
		return null;
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
	
	function itemSelectHandler(obj:IUiItemGroupBase, touch:Touch):Void
	{
		var key:Dynamic = getKey(obj);
		var giveUpKey:Dynamic = null;
		var index:Int = SystemUtils.arrayIndexOf(values, key);
		var giveUpIndex:Int = -1;
		var current:IUiItemGroupBase = cast(items[SystemUtils.arrayIndexOf(items, obj)]);
		if ( index == -1 ) {
			if ( isMulti ) {
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
				
				dispatchEvent(new Event(DatasEvent.DATA_DOING, values));
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
				
				dispatchEvent(new Event(DatasEvent.DATA_DOING, values));
			}
		}else{//找到(取消)
			if( !isMust ){//不是必须的
				values.splice(index, 1);
				selects.splice(index, 1);
				current.setSelected(false);
				
				dispatchEvent(new Event(DatasEvent.DATA_DOING, values));
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
			item.setCallbacks({click:itemSelectHandler});
		}
	}
	
	override public function addItem(item:IUiBase):IUiBase { return null; }
	
	override public function addItemAt(item:IUiBase, index:Int):IUiBase { return null; }
	
	override public function removeItem(item:IUiBase):IUiBase { return null; }
	
	override public function removeItemAt(index:Int):IUiBase { return null; }
	
	override public function removeAllItems():Void {}
}