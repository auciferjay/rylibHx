package cn.royan.hl.interfaces.uis;

import cn.royan.hl.interfaces.IDisposeBase;
import cn.royan.hl.geom.Position;
import cn.royan.hl.geom.Square;

import flash.display.BitmapData;
import flash.events.EventDispatcher;

interface IUiBase implements IDisposeBase
{
	function draw():Void;
	function setCallbacks(value:Dynamic):Void;
	function getDefaultBackgroundColors():Array<Dynamic>;
	function getDefaultBackgroundAlphas():Array<Dynamic>;
	function setBackgroundColors(value:Array<Dynamic>):Void;
	function getBackgroundColors():Array<Dynamic>;
	function setBackgroundAlphas(value:Array<Dynamic>):Void;
	function getBackgroundAlphas():Array<Dynamic>;
	function setSize(cWidth:Int, cHeight:Int):Void;
	function getSize():Square;
	function setPosition(cX:Int, cY:Int):Void;
	function getPosition():Position;
	function setPositionPoint(point:Position):Void;
	function setTexture(texture:BitmapData, frames:Int=1):Void;
	function getTexture():BitmapData;
	function getDispatcher():EventDispatcher;
}