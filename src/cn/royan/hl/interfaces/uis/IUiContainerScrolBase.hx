package cn.royan.hl.interfaces.uis;

/**
 * ...
 * @author RoYan
 */
interface IUiContainerScrolBase implements IUiBase
{
	function setScrollerSize(cWidth:Int, cHeight:Int):Void;
	function setScrollerType(type:Int):Void;
	function setScrollerThumbTexture(texture:Dynamic):Void;
	function setScrollerMinTexture(texture:Dynamic):Void;
	function setScrollerMaxTexture(texture:Dynamic):Void;
	function setScrollerBackgroundTextrue(texture:Dynamic):Void;
}