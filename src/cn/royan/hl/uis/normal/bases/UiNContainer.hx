package cn.royan.hl.uis.normal.bases;

import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.interfaces.uis.IUiContainerBase;
import cn.royan.hl.uis.normal.InteractiveUiN;
import cn.royan.hl.uis.sparrow.Sparrow;
import cn.royan.hl.uis.style.Style;
import cn.royan.hl.utils.SystemUtils;

import flash.events.Event;
import flash.display.DisplayObject;

/**
 * ...
 * @author RoYan
 */
class UiNContainer extends InteractiveUiN, implements IUiContainerBase
{
	var states:Array<String>;
	var current:String;
	
	var items:Array<IUiBase>;
	
	var showProp:Dynamic->Void;
	var hideProp:Dynamic->Dynamic->Void;
	
	var adds:Array<IUiBase>;
	var dels:Array<IUiBase>;
	
	public function new(texture:Sparrow = null)
	{
		super(texture);
		
		items = [];
		states = [];
		
		adds = [];
		dels = [];
	}
	
	override private function addToStageHandler(evt:Event = null):Void 
	{
		super.addToStageHandler(evt);
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_CHANGE));
	}
	
	override public function draw():Void 
	{
		super.draw();
		
		while ( adds.length > 0 ) {
			var item:IUiBase = adds.shift();
			addChildAt( cast(item, DisplayObject), SystemUtils.arrayIndexOf(items, item) );
			
			if ( showProp != null ) {
				showProp( item );
			}
		}
		
		while ( dels.length > 0 ) {
			var item:IUiBase = dels.shift();
			if ( hideProp != null ) {
				hideProp( item, callback( removeChild, cast(item, DisplayObject) ) );
			}else {
				removeChild(cast(item, DisplayObject));
			}
		}
	}
	
	public function addItem(item:IUiBase):IUiBase
	{
		SystemUtils.print(item, PrintConst.UIS);
		items.push(item);
		
		item.setScale(getScale());
		
		adds.push(item);
		//addChild(cast( item, DisplayObject ));
		
		viewChanged();
		
		//if ( showProp != null ) {
		//	showProp( item );
		//}
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_CHANGE));
		
		return item;
	}
	
	public function addItemAt(item:IUiBase, index:Int):IUiBase
	{
		SystemUtils.print(item+":"+index, PrintConst.UIS);
		var prev:Array<IUiBase> = items.slice(0, index);
		var next:Array<IUiBase> = items.slice(index);
		
		prev.push(item);
		
		items = prev.concat(next);
		
		item.setScale(getScale());
		
		adds.push(item);
		//addChildAt(cast( item, DisplayObject ), index);
		
		viewChanged();
		
		//if ( showProp != null ) {
		//	showProp( item );
		//}
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_CHANGE));
		
		return item;
	}
	
	public function removeItem(item:IUiBase):IUiBase
	{
		SystemUtils.print(item, PrintConst.UIS);
		
		items.remove(item);
		
		dels.push(item);
		//if ( hideProp != null ) {
		//	hideProp( item, callback( removeChild, cast(item, DisplayObject) ) );
		//}else {
		//	removeChild(cast(item, DisplayObject));
		//}
		
		viewChanged();
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_CHANGE));
		
		return item;
	}
	
	public function removeItemAt(index:Int):IUiBase
	{
		SystemUtils.print(index, PrintConst.UIS);
		var prev:Array<IUiBase> = items.slice(0, index);
		var next:Array<IUiBase> = items.slice(index);
		
		var item:IUiBase = removeItem(next.shift());
		
		items = prev.concat(next);
		
		return item;
	}
	
	public function removeAllItems(dispose:Bool=false):Void
	{
		dels = items.concat([]);
		items = [];
		//while ( items.length > 0 ) {
			//var item:IUiBase = items.shift();
			//if ( hideProp != null ) {
			//	hideProp( item, callback( removeChild, cast(item, DisplayObject) ) );
			//}else {
			//	removeChild(cast(item, DisplayObject));
			//}
		//}
		
		viewChanged();
		
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
	
	override public function setStyle(value:Style):Void 
	{
		//super.setStyle(value);
	}
	
	public function setState(value:String):Void
	{
		SystemUtils.print(value, PrintConst.UIS);
		if( SystemUtils.arrayIndexOf( states, value ) == -1 ) return;
		
		current = value;
		
		var i:Int;
		for(i in 0...numChildren){
			if( Std.is(getChildAt(i), IUiBase) ){
				var item:IUiBase = cast(getChildAt(i), IUiBase);
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
	
	public function setShow(effect:Dynamic->Void):Void
	{
		showProp = effect;
	}
	
	public function setHide(effect:Dynamic->Dynamic->Void):Void
	{
		hideProp = effect;
	}
}