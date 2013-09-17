package cn.royan.hl.interfaces.uis;

import flash.geom.Point;

/**
 * ...
 * @author RoYan
 */
interface ITouchBase
{
	/**
	 * 是否检测鼠标
	 * @param	value
	 */
	function setTouchabled(value:Bool):Void;
	
	/**
	 * 获取时候检测
	 * @return
	 */
	function getTouchabled():Bool;
	
	/**
	 * 是否改变鼠标样式
	 * @param	value
	 */
	function setButtonMode(value:Bool):Void;
	
	/**
	 * 获取是否改变鼠标
	 * @return
	 */
	function getButtonMode():Bool;
	
	/**
	 * 鼠标碰撞检测
	 * @param	point
	 * @return
	 */
	function touchTest(point:Point, mouseDown:Bool):Bool;
}