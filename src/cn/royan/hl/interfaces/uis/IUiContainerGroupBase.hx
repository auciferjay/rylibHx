package cn.royan.hl.interfaces.uis;

/**
 * ...
 * @author RoYan
 */

interface IUiContainerGroupBase implements IUiBase
{
	function addGroupItem(item:IUiItemGroupBase, key:Dynamic = null):Void;
	function addGroupItemAt(item:IUiItemGroupBase, index:Int, key:Dynamic = null):Void;
	
	function removeGroupItem(item:IUiItemGroupBase):Void;
	function removeGroupItemAt(index:Int):Void;
	function removeAllGroupItems():Void;
	
	function getGroupItemAt(index:Int):IUiItemGroupBase;
	function getIndexByGroupItem(item:IUiItemGroupBase):Int;
	function getGroupItems():Array<IUiItemGroupBase>;
	
	function getSelectedItems():Array<IUiItemGroupBase>;
	function getValues():Array<Dynamic>;
	
	function setIsMust(value:Bool):Void;
	function setIsMulti(value:Bool):Void;
	function setMaxLen(value:Int):Void;
}