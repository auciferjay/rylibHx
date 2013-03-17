package cn.royan.hl.interfaces.uis;

/**
 * ...
 * @author RoYan
 */

interface IUiItemGroupBase implements IUiBase
{
	function setSelected(value:Bool):Void;
	function getSelected():Bool;
	function setInGroup(value:Bool):Void;
}