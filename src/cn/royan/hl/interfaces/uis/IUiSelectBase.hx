package cn.royan.hl.interfaces.uis;

import cn.royan.hl.interfaces.IDisposeBase;

import flash.events.EventDispatcher;

interface IUiSelectBase extends IDisposeBase
{
	function setSelected(value:Bool):Void;
	function getSelected():Bool;
	function setInGroup(value:Bool):Void;
	function getDispatcher():EventDispatcher;
}