package cn.royan.hl.interfaces.uis;

/**
 * ...
 * @author RoYan
 */

interface IUiItemStateBase implements IUiBase
{
	function setExclude(args:Array<String>):Void;
	function getExclude():Array<String>;
	function setInclude(args:Array<String>):Void;
	function getInclude():Array<String>;
}