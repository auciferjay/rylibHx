package cn.royan.hl.interfaces.uis;

import cn.royan.hl.interfaces.IDisposeBase;
import cn.royan.hl.geom.Position;
import cn.royan.hl.geom.Square;

import flash.display.BitmapData;
import flash.events.EventDispatcher;

interface IUiBase implements IDisposeBase
{
	function draw():Void;
	function getDefaultBackgroundColors():Array<Int>;
	function getDefaultBackgroundAlphas():Array<Float>;
	function setBackgroundColors(value:Array<Int>):Void;
	function getBackgroundColors():Array<Int>;
	function setBackgroundAlphas(value:Array<Float>):Void;
	function getBackgroundAlphas():Array<Float>;
	function setSize(cWidth:Int, cHeight:Int):Void;
	function getSize():Square;
	function setPosition(cX:Int, cY:Int):Void;
	function getPosition():Position;
	function setPositionPoint(point:Position):Void;
	function setTexture(texture:BitmapData, frames:Int=1):Void;
	function getTexture():BitmapData;
	function getDispatcher():EventDispatcher;
}