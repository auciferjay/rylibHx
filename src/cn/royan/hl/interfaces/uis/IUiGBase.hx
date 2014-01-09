package cn.royan.hl.interfaces.uis;

import cn.royan.hl.uis.graphs.UiGDisplayObjectContainer;
import cn.royan.hl.uis.graphs.UiGStage;
import cn.royan.hl.uis.sparrow.Sparrow;
import flash.geom.Rectangle;

/**
 * ...
 * @author RoYan
 */
interface IUiGBase
{
	function getBound():Rectangle;
	
	function setStage(value:UiGStage):UiGStage;
	function getStage():UiGStage;
	
	function setParent(value:UiGDisplayObjectContainer):UiGDisplayObjectContainer;
	function getParent():UiGDisplayObjectContainer;
	
	function setRotation(value:Float):Float;
	function getRotation():Float;
	
	function setVisible(value:Bool):Bool;
	function getVisible():Bool;
	
	function setAlpha(value:Float):Float;
	function getAlpha():Float;
	
	function setScaleX(value:Float):Float;
	function getScaleX():Float;
	
	function setScaleY(value:Float):Float;
	function getScaleY():Float;
	
	function setWidth(value:Int):Int;
	function getWidth():Int;
	
	function setHeight(value:Int):Int;
	function getHeight():Int;
	
	function setX(value:Int):Int;
	function getX():Int;
	
	function setY(value:Int):Int;
	function getY():Int;
	
	function recycle():Void;
	function dispose():Void;
	
	function registSparrow(type:String, name:String, isNew:Bool=false):Sparrow;
	function registSparrows(type:String, name:String, isNew:Bool=false):Array<Sparrow>;
}