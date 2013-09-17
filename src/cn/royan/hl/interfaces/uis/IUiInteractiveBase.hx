package cn.royan.hl.interfaces.uis;

import flash.geom.Point;

/**
 * ...
 * @author RoYan
 */
interface IUiInteractiveBase
{
	function hitTest(point:Point):Bool;
	
	function setButtonMode(value:Bool):Void;
	
	function getButtonMode():Bool;
}