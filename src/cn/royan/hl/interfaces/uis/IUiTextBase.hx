package cn.royan.hl.interfaces.uis;

import cn.royan.hl.geom.Range;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

/**
 * ...
 * @author RoYan
 */

interface IUiTextBase implements IUiBase 
{
	function setTextSpace(r:Int, c:Int):Void;
	function setType(type:Int):Void;
	
	function setText(value:String):Void;
	function appendText(value:String):Void;
	function getText():String;
	
	function setHTMLText(value:String):Void;
	function appendHTMLText(value:String):Void;
	function getHTMLText():String;
	
	function setTextAlign(value:Int):Void;
	function setTextColor(value:Int):Void;
	function setTextSize(value:Int):Void;
	
	function setEmbedFont(value:Bool):Void;
	
	function setFormat(value:TextFormat, begin:Int=-1, end:Int=-1):Void;
	function getFormat(begin:Int=-1, end:Int=-1):TextFormat;
	function setDefaultFormat(value:TextFormat):Void;
	function getDefaultFormat():TextFormat;
	#if flash
	function setScroll(sx:Int=0, sy:Int=0):Void;
	function getScroll():Range;
	function getMaxScroll():Range;
	#end
	function setMultiLine(value:Bool):Void;
}