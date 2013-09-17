package cn.royan.hl.uis.graphs;

import cn.royan.hl.consts.UiConst;
import cn.royan.hl.interfaces.uis.ITouchBase;
import cn.royan.hl.uis.graphs.UiGStage;
import cn.royan.hl.uis.sparrow.Sparrow;
import cn.royan.hl.utils.SystemUtils;

import flash.ui.Mouse;
import flash.ui.MouseCursor;
import flash.geom.Point;

/**
 * ...
 * @author RoYan
 */
class UiGBmpdSprite extends UiGBmpdShape, implements ITouchBase
{
	var buttonMode:Bool;
	var touchabled:Bool;
	
	var touchstats:Array<Int>;
	
	var callbacks:Dynamic;
	
	public function new( sparrow:Sparrow ) 
	{
		super( sparrow );
		
		touchstats 	= [];
	}
	
	public function setTouchabled(value:Bool):Void
	{
		touchabled = value;
	}
	
	public function getTouchabled():Bool
	{
		return touchabled;
	}
	
	public function setButtonMode(value:Bool):Void
	{
		buttonMode = value;
	}
	
	public function getButtonMode():Bool
	{
		return buttonMode;
	}
	
	public function touchTest(point:Point, mouseDown:Bool):Bool
	{
		if ( touchabled && hitTest(point) ) {
			Mouse.cursor = buttonMode?MouseCursor.BUTTON:MouseCursor.AUTO;
			
			checkTouchStats(mouseDown?UiConst.TOUCHSTATS_IN_DOWN:UiConst.TOUCHSTATS_IN_UP);
			return true;
		}
		Mouse.cursor = MouseCursor.AUTO;
		checkTouchStats(mouseDown?UiConst.TOUCHSTATS_OUT_DOWN:UiConst.TOUCHSTATS_OUT_UP);
		return false;
	}
	
	private function checkTouchStats(value:Int):Void
	{
		if ( touchstats.length > 0 && touchstats[touchstats.length - 1] != value )
			touchstats.push(value);
		
		if ( value == UiConst.TOUCHSTATS_OUT_DOWN || value == UiConst.TOUCHSTATS_OUT_UP ) {
			
			SystemUtils.print(touchstats);
			
			touchstats = [];
		}
	}
}