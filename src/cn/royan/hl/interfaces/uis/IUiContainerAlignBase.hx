package cn.royan.hl.interfaces.uis;

/**
 * ...
 * @author RoYan
 */

interface IUiContainerAlignBase implements IUiBase
{
	function setHorizontalAlign(value:Int):Void;
	function setVerticalAlign(value:Int):Void;
	function setGaps(gapX:Int, gapY:Int):Void;
	function setContentAlign(value:Int):Void;
	function setMargins(left:Int, top:Int, right:Int, bottom:Int):Void;
}