package cn.royan.hl.uis.graphs;

import cn.royan.hl.uis.graphs.UiGStage;
import cn.royan.hl.uis.sparrow.Sparrow;

/**
 * ...
 * @author RoYan
 */
class UiGBmpdSprite extends UiGBmpdShape
{
	var buttonMode:Bool;
	
	public function new() 
	{
		super();
	}
	
	override public function setStage(value:UiGStage):Void 
	{
		super.setStage(value);
		
		stage.registBound(bound, touchHandler);
	}
	
	public function getButtonMode():Bool
	{
		return buttonMode;
	}
	
	function touchHandler():Void
	{
		
	}
}