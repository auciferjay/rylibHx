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
	
	var callbacks:Dynamic;
	
	public function new( sparrow:Sparrow ) 
	{
		super( sparrow );
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