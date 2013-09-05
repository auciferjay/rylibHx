package cn.royan.hl.uis.graphs;

import cn.royan.hl.bases.TimerBase;
import cn.royan.hl.uis.graphs.bases.UiGContainer;

import flash.geom.Rectangle;
import flash.display.Stage;

/**
 * ...
 * @author RoYan
 */
class UiGStage extends UiGContainer
{
	var timer:TimerBase;
	var nativeStage:Stage;
	
	var bounds:Array<Rectangle>;
	
	public function new(rootStage:Stage) 
	{
		super();
		
		stage = this;
		
		bounds = [];
		
		timer = new TimerBase(20, draw);
		
		nativeStage = rootStage;
	}
	
	public function getNativeStage():Stage
	{
		return nativeStage;
	}
	
	public function registBound(bound:Rectangle, touch:Void->Void):Void
	{
		
	}
}