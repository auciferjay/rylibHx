package cn.royan.hl.interfaces.uis;

import cn.royan.hl.interfaces.IDisposeBase;

interface IUiPlayBase extends IDisposeBase
{
	function getIn():Void;
	function getOut():Void;
	function goTo(frame:Int):Void;
	function jumpTo(frame:Int):Void;
	function goFromTo(from:Int, to:Int):Void;
}