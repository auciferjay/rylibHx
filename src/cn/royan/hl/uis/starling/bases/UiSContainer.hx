package cn.royan.hl.uis.starling.bases;

import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.interfaces.uis.IUiContainerBase;
import cn.royan.hl.interfaces.uis.IUiContainerStateBase;
import cn.royan.hl.interfaces.uis.IUiItemStateBase;
import cn.royan.hl.uis.starling.InteractiveUiS;
import cn.royan.hl.utils.SystemUtils;
import starling.events.Event;
import starling.display.DisplayObject;
import starling.textures.Texture;

/**
 * ...
 * @author RoYan
 */
class UiSContainer extends InteractiveUiS, implements IUiContainerBase, implements IUiContainerStateBase
{
	var states:Array<String>;
	var current:String;
	
	var items:Array<IUiBase>;
	
	public function new(texture:Texture = null)
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
		else dispatchEvent(new Event(DatasEvent.DATA_CHANGE));
	}
	
	public function addItem(item:IUiBase):Void
	{
		items.push(item);
		
		setScale(getScale());
		
		addChild(cast( item, DisplayObject ));
		
		draw();
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new Event(DatasEvent.DATA_CHANGE));
	}
	
	public function addItemAt(item:IUiBase, index:Int):Void
	{
		var prev:Array<IUiBase> = items.slice(0, index);
		var next:Array<IUiBase> = items.slice(index);
		
		prev.push(item);
		
		items = prev.concat(next);
		
		setScale(getScale());
		
		addChildAt(cast( item, DisplayObject ), index);
		
		draw();
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new Event(DatasEvent.DATA_CHANGE));
	}
	
	public function removeItem(item:IUiBase):Void
	{
		items.remove(item);
		removeChild(cast(item, DisplayObject));
		
		draw();
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new Event(DatasEvent.DATA_CHANGE));
	}
	
	public function removeItemAt(index:Int):Void
	{
		var prev:Array<IUiBase> = items.slice(0, index);
		var next:Array<IUiBase> = items.slice(index);
		
		removeItem(next.shift());
		
		//if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		//else dispatchEvent(new Event(DatasEvent.DATA_CHANGE));
		
		items = prev.concat(next);
	}
	
	public function removeAllItems():Void
	{
		while ( items.length > 0 ) {
			removeItem(items.shift());
		}
		
		draw();
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new Event(DatasEvent.DATA_CHANGE));
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