package cn.royan.hl.interfaces.uis;

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
	
	function setHorizontalAlign(value:Int):Void;
	function setVerticalAlign(value:Int):Void;
	function setGaps(gapX:Int, gapY:Int):Void;
	function setMargins(left:Int, top:Int, right:Int, bottom:Int):Void;
}