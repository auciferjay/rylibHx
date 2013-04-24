package cn.royan.hl.uis.normal.exts;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.interfaces.uis.IUiItemGroupBase;
import cn.royan.hl.uis.normal.bases.UiNContainerGroup;
import cn.royan.hl.uis.normal.bases.UiNLabelButton;
import cn.royan.hl.uis.normal.bases.UiNScrollPane;
import cn.royan.hl.uis.normal.InteractiveUiN;
import cn.royan.hl.utils.SystemUtils;

/**
 * ...
 * @author RoYan
 */
typedef ItemType = {
	var label:String;
	var value:Dynamic;
}
 
class UiNExtCombobox extends InteractiveUiN
{
	var group:UiNContainerGroup;
	var listView:UiNScrollPane;
	var items:Array<ItemType>;
	var title:UiNLabelButton;
	
	public function new() 
	{
		super();
		
		title = new UiNLabelButton("Select");
		title.setCallbacks({click:titleClickHandler});
		title.setSize(50, 20);
		addChild(title);
		
		group = new UiNContainerGroup();
		#if !flash
		group.addEventListener(DatasEvent.DATA_DOING, groupDoingHandler);
		#end
		group.setIsMust(true);
		group.setIsMulti(false);
		items = [];
		
		listView = new UiNScrollPane(group, UiNScrollPane.SCROLL_TYPE_VERICAL_ONLY);
		//addChild(listView);
	}
	
	function titleClickHandler(obj:UiNLabelButton):Void
	{
		if ( contains(listView) )
			removeChild(listView);
		else {
			#if flash
			group.addEventListener(DatasEvent.DATA_DOING, groupDoingHandler);
			#end
			addChild(listView);
		}
	}
	
	function groupDoingHandler(evt:DatasEvent):Void
	{
		title.setText(items[group.getValues()[0]].label);
		removeChild(listView);
	}
	
	override public function setSize(w:Float, h:Float):Void 
	{
		super.setSize(w, h);
		
		title.setSize(w, h);
		group.setSize(w, h * 6);
		listView.setSize(w, h * 3);
		listView.setPosition(0, h);
	}
	
	public function addItem(item:ItemType):Void
	{
		var instance:UiNLabelButton = new UiNLabelButton(item.label);
			instance.setSize(getSize().width, 20);
		items.push(item);
		
		group.addGroupItem(instance, item.value);
	}
	
	public function addItemAt(item:ItemType, index:Int):Void
	{
		var instance:UiNLabelButton = new UiNLabelButton(item.label);
		
		var prev:Array<ItemType> = items.slice(0, index);
		var next:Array<ItemType> = items.slice(index);
		
		prev.push(item);
		items = prev.concat(next);
		
		group.addGroupItemAt(instance, index, item.value);
	}
	
	public function removeItem(item:ItemType):Void
	{
		var index:Int = SystemUtils.arrayIndexOf(items, item);
		items.remove(item);
		
		group.removeGroupItemAt(index);
	}
	
	public function removeItemAt(index:Int):Void
	{
		var prev:Array<ItemType> = items.slice(0, index);
		var next:Array<ItemType> = items.slice(index);
		
		prev.pop();
		
		items = prev.concat(next);
		
		group.removeGroupItemAt(index);
	}
	
	public function removeAllItems():Void
	{
		items = [];
		group.removeAllGroupItems();
	}
	
	public function getItemAt(index:Int):ItemType
	{
		return items[index];
	}
	
	public function getIndexByItem(item:ItemType):Int
	{
		return SystemUtils.arrayIndexOf(items, item);
	}
	
	public function getItems():Array<ItemType>
	{
		return items;
	}
	
	public function getSelectedItems():Array<ItemType>
	{
		var selects:Array<IUiItemGroupBase> = group.getSelectedItems();
		var result:Array<ItemType> = [];
		for ( item in selects ) {
			var index:Int = group.getIndexByGroupItem(item);
			result.push(items[index]);
		}
		
		return result;
	}
	
	public function getValues():Array<Dynamic>
	{
		return group.getValues();
	}
	
	public function setIsMust(value:Bool):Void
	{
		group.setIsMust(value);
	}
	
	public function setIsMulti(value:Bool):Void
	{
		group.setIsMulti(value);
	}
	
	public function setMaxLen(value:Int):Void
	{
		group.setMaxLen(value);
	}
}