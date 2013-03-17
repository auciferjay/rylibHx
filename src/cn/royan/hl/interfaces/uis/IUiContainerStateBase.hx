package cn.royan.hl.interfaces.uis;

/**
 * ...
 * @author RoYan
 */

interface IUiContainerStateBase implements IUiBase
{
	function setState(value:String):Void;
	function getState():String;
}