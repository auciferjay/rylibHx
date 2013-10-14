package cn.royan.hl.uis.graphs;

import cn.royan.hl.bases.TimerBase;
import cn.royan.hl.uis.graphs.UiGDisplayObjectContainer;
import flash.geom.Point;

import flash.geom.Rectangle;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TouchEvent;

/**
 * ...
 * @author RoYan
 */
class UiGStage extends UiGDisplayObjectContainer
{
	private static var mouseChanges:Array<String> = [ MouseEvent.MOUSE_DOWN,  MouseEvent.MOUSE_MOVE, MouseEvent.MOUSE_UP ];
	//private static var touchChanges:Array<String> = [ TouchEvent.TOUCH_OUT, TouchEvent.TOUCH_OVER, TouchEvent.TOUCH_ROLL_OUT, TouchEvent.TOUCH_ROLL_OVER ];
	
	var nativeStage:Stage;
	
	var bounds:Array<Rectangle>;
	
	public function new(rootStage:Stage) 
	{
		super();
		
		stage = this;
		
		bounds = [];
		
		_graphics = new UiGGraphic();
		
		nativeStage = rootStage;
		
		for (touchEventType in mouseChanges)
            nativeStage.addEventListener(touchEventType, onTouch, false, 0, true);
        
		// register other event handlers
		//nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, onKey, false, 0, true);
		//nativeStage.addEventListener(KeyboardEvent.KEY_UP, onKey, false, 0, true);
		//nativeStage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave, false, 0, true);
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
	
	public function getNativeStage():Stage
	{
		return nativeStage;
	}
}