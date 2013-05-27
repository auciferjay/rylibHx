package cn.royan.hl.interfaces.uis;

/**
 * ...
 * @author RoYan
 */
interface IUiItemPlayBase implements IUiBase
{
	function getIn():Void;
	function getOut():Void;
	function goTo(frame:Int):Void;
	function jumpTo(frame:Int):Void;
	function goFromTo(from:Int, to:Int):Void;
}