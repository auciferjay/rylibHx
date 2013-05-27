package cn.royan.hl.interfaces.uis;

/**
 * ...
 * @author RoYan
 */
interface IUiScrollBarBase implements IUiBase
{
	function getValue():Int;
	function setValue(value:Int):Void;
	function setType(type:Int):Void;
	function setThumbTexture(texture:Dynamic):Void;
	function setMinTexture(texture:Dynamic):Void;
	function setMaxTexture(texture:Dynamic):Void;
	function setBackgroundTextrue(texture:Dynamic):Void;
}