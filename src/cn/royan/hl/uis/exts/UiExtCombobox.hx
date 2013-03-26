package cn.royan.hl.uis.exts;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.interfaces.uis.IUiItemGroupBase;
import cn.royan.hl.uis.bases.UiBaseContainerGroup;
import cn.royan.hl.uis.bases.UiBaseLabelButton;
import cn.royan.hl.uis.bases.UiBaseScrollPane;
import cn.royan.hl.uis.InteractiveUiBase;
import cn.royan.hl.utils.SystemUtils;

/**
 * ...
 * @author RoYan
 */
typedef ItemType = {
	var label:String;
	var value:Dynamic;
}
 
class UiExtCombobox extends InteractiveUiBase
{
	var group:UiBaseContainerGroup;
	var listView:UiBaseScrollPane;
	var items:Array<ItemType>;
	var title:UiBaseLabelButton;
	
	public function new() 
	{
		super();
		
		title = new UiBaseLabelButton("Select");
		title.setCallbacks({click:titleClickHandler});
		title.setSize(50, 20);
		addChild(title);
		
		group = new UiBaseContainerGroup();
		#if !flash
		group.addEventListener(DatasEvent.DATA_DOING, groupDoingHandler);
		#end
		group.setIsMust(true);
		group.setIsMulti(false);
		items = [];
		
		listView = new UiBaseScrollPane(group, UiBaseScrollPane.SCROLL_TYPE_VERICAL_ONLY);
		//addChild(listView);
	}
	
	function titleClickHandler(obj:UiBaseLabelButton):Void
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
	
	override public function setSize(w:Int, h:Int):Void 
	{
		super.setSize(w, h);
		
		title.setSize(w, h);
		group.setSize(w, h * 6);
		listView.setSize(w, h * 3);
		listView.setPosition(0, h);
	}
	
	public function addItem(item:ItemType):Void
	{
		var instance:UiBaseLabelButton = new UiBaseLabelButton(item.label);
			instance.setSize(getSize().width, 20);
		items.push(item);
		
		group.addGroupItem(instance, item.value);
	}
	
	public function addItemAt(item:ItemType, index:Int):Void
	{
		var instance:UiBaseLabelButton = new UiBaseLabelButton(item.label);
		
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