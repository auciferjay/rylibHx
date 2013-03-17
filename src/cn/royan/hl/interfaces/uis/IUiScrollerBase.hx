package cn.royan.hl.interfaces.uis;

/**
 * ...
 * @author RoYan
 */

interface IUiScrollerBase extends IUiBase
{
	function show(v:Bool, h:Bool):Void;
	function setSize(cWidth:Int, cHeight:Int):Void;
	function setContainerSize(cWidth:Int, cHeight:Int):Void;
	function setType(type:Int):Void;
	function setThumbTexture(texture:Dynamic):Void;
	function setMinTexture(texture:Dynamic):Void;
	function setMaxTexture(texture:Dynamic):Void;
	function setBackgroundTextrue(texture:Dynamic):Void;
}