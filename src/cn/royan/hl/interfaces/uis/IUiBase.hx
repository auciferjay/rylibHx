package cn.royan.hl.interfaces.uis;

import cn.royan.hl.interfaces.IDisposeBase;
import cn.royan.hl.geom.Position;
import cn.royan.hl.geom.Square;
import cn.royan.hl.uis.sparrow.Sparrow;
import flash.geom.Rectangle;

import flash.events.EventDispatcher;

/**
 * ...
 * @author RoYan
 */

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
	function setSize(cWidth:Float, cHeight:Float):Void;
	function getSize():Square;
	function setPosition(cX:Float, cY:Float):Void;
	function getPosition():Position;
	function setPositionPoint(point:Position):Void;
	function setPositionRange(value:Rectangle):Void;
	function getRange():Rectangle;
	function setTexture(texture:Dynamic, frames:Int=1):Void;
	function getTexture():Dynamic;
	function setOriginalDPI(value:Int):Void;
	function getOriginalDPI():Int;
	function setScale(value:Float):Void;
	function getScale():Float;
	function getDispatcher():EventDispatcher;
}