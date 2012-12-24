package cn.royan.hl.interfaces.uis;

import cn.royan.hl.interfaces.IDisposeBase;
import cn.royan.hl.interfaces.uis.IUiBase;

import flash.events.EventDispatcher;

interface IUiSelectBase implements IDisposeBase, implements IUiBase
{
	function setSelected(value:Bool):Void;
	function getSelected():Bool;
	function setInGroup(value:Bool):Void;
	function getDispatcher():EventDispatcher;
}