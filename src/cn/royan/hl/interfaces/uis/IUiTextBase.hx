package cn.royan.hl.interfaces.uis;

import cn.royan.hl.geom.Position;
import flash.text.TextFormat;

interface IUiTextBase extends IUiBase 
{
	function setText(value:String):Void;
	function appendText(value:String):Void;
	function getText():String;
	
	function setHTMLText(value:String):Void;
	function appendHTMLText(value:String):Void;
	function getHTMLText():String;
	
	function setTextAlign(value:Int):Void;
	function setTextColor(value:UInt):Void;
	function setTextSize(value:Int):Void;
	
	function setEmbedFont(value:Bool):Void;
	
	function setFormat(value:TextFormat):Void;
	function getFormat():TextFormat;
	function getDefaultFormat():TextFormat;
	
	function setScroll(sx:Int=0, sy:Int=0):Void;
	function getScroll():Position;
	function getMaxScroll():Position;
	
	function setMultiLine(value:Bool):Void;
}