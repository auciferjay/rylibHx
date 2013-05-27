package cn.royan.hl.interfaces.uis;

/**
 * ...
 * @author RoYan
 */
interface IUiContainerBase implements IUiBase
{
	function addItem(item:IUiBase):Void;
	function addItemAt(item:IUiBase, index:Int):Void;
	
	function removeItem(item:IUiBase):Void;
	function removeItemAt(index:Int):Void;
	function removeAllItems():Void;
	
	function getItemAt(index:Int):IUiBase;
	function getIndexByItem(item:IUiBase):Int;
	function getItems():Array<IUiBase>;
}