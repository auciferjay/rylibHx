package cn.royan.hl.uis.graphs;

import cn.royan.hl.uis.graphs.UiGStage;

/**
 * ...
 * @author RoYan
 */
class UiGSprite extends UiGShape
{
	var buttonMode:Bool;
	
	var callbacks:Dynamic;
	
	public function new() 
	{
		super();
	}
	
	override public function setStage(value:UiGStage):Void 
	{
		super.setStage(value);
		
		stage.registBound(bound, touchHandler);
	}
	
	public function setButtonMode(value:Bool):Void
	{
		buttonMode = value;
	}
	
	public function getButtonMode():Bool
	{
		return buttonMode;
	}
	
	function touchHandler():Void
	{
		
	}
}