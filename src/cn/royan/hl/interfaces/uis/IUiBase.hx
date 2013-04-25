package cn.royan.hl.interfaces.uis;

import cn.royan.hl.geom.Range;
import cn.royan.hl.interfaces.IDisposeBase;
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
	function setColorsAndAplhas(color:Array<Dynamic>, alpha:Array<Dynamic>):Void;
	function getColors():Array<Dynamic>;
	function getAlphas():Array<Dynamic>;
	function setSize(cWidth:Float, cHeight:Float):Void;
	function setPosition(cX:Float, cY:Float):Void;
	function setRange(value:Range):Void;
	function getRange():Range;
	function getDefaultTexture():Dynamic;
	function setTexture(texture:Dynamic, frames:Int=1):Void;
	function getTexture():Dynamic;
	function setScale(value:Float):Void;
	function getScale():Float;
	function getDispatcher():EventDispatcher;
}