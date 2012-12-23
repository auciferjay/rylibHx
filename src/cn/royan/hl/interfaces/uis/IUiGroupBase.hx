package cn.royan.hl.interfaces.uis;

interface IUiGroupBase
{
	function addGroupItem(item:Dynamic, key:Dynamic=Null):Void;
	function getValues():Array<Dynamic>;
	function setIsMust(value:Bool):Void;
	function setIsMulti(value:Bool):Void;
	function setMaxLen(value:Int):Void;
}