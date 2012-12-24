package cn.royan.hl.interfaces.uis;

interface IUiGroupBase
{
	function addGroupItem(item:IUiSelectBase, value:Dynamic=null):Void;
	function getSelectedItems():Array<IUiBase>;
	function getValues():Array<Dynamic>;
	function setIsMust(value:Bool):Void;
	function setIsMulti(value:Bool):Void;
	function setMaxLen(value:Int):Void;
}