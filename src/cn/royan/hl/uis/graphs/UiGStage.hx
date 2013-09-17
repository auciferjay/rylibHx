package cn.royan.hl.uis.graphs;

import cn.royan.hl.uis.graphs.bases.UiGContainer;
import cn.royan.hl.utils.SystemUtils;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.display.Stage;
import haxe.Timer;

/**
 * ...
 * @author RoYan
 */
class UiGStage extends UiGContainer
{
	var nativeStage:Stage;
	
	public function new(rootStage:Stage) 
	{
		super();
		
		stage = this;
		
		nativeStage = rootStage;
		
		for (touchEventType in touchEventTypes())
            nativeStage.addEventListener(touchEventType, onTouch, false, 0, true);
        
		// register other event handlers
		nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, onKey, false, 0, true);
		nativeStage.addEventListener(KeyboardEvent.KEY_UP, onKey, false, 0, true);
		nativeStage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave, false, 0, true);
	}
	
	public function getNativeStage():Stage
	{
		return nativeStage;
	}
        
	private function onKey(evt:KeyboardEvent):Void
	{
		
	}
	
	private function onResize(evt:Event):Void
	{
		
	}

	private function onMouseLeave(evt:Event):Void
	{
		
	}
        
	private function onTouch(evt:Event):Void
	{
		var globalX:Int = 0;
		var globalY:Int = 0;
		var isDown:Bool	= false;
		if ( Std.is( evt, MouseEvent ) ) {
			globalX = Std.int(cast(evt, MouseEvent).stageX);
			globalY = Std.int(cast(evt, MouseEvent).stageY);
			
			isDown = cast(evt, MouseEvent).buttonDown;
		}else {
			
		}
		var point:Point = new Point(globalX, globalY);
		touchTest(point, isDown);
	}
	
	private function touchEventTypes():Array<String>
	{
		var types:Array<String> = [MouseEvent.MOUSE_DOWN,  MouseEvent.MOUSE_MOVE, MouseEvent.MOUSE_UP];
		return types;
	}
}