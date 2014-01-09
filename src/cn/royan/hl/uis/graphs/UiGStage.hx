package cn.royan.hl.uis.graphs;

import cn.royan.hl.bases.TimerBase;
import cn.royan.hl.consts.UiConst;
import cn.royan.hl.uis.graphs.UiGDisplayObjectContainer;
import flash.display.BitmapData;
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
	
	var nativeStage:Stage;
	
	var bounds:Array<Rectangle>;
	
	var snap:BitmapData;
	
	public function new(rootStage:Stage) 
	{
		super();
		
		stage = this;
		
		bounds = [];
		
		_graphics = new UiGGraphic();
		
		nativeStage = rootStage;
		
		width = nativeStage.stageWidth;
		height = nativeStage.stageHeight;
		
		snap = new BitmapData(width, height , true, 0x00FF);
		
		for (touchEventType in mouseChanges)
            nativeStage.addEventListener(touchEventType, onTouch, false, 0, true);
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
		var touchObj:UiGDisplayObject = touchTest(point, isDown);
		if ( touchObj != null )
			touchObj.checkTouchStats(isDown?UiConst.TOUCHSTATS_IN_DOWN:UiConst.TOUCHSTATS_IN_UP);
	}
	
	public function getSnap():BitmapData
	{
		return snap;
	}
	
	public function getNativeStage():Stage
	{
		return nativeStage;
	}
	/*
	override public function recycle():Void 
	{
		//super.recycle();
		
		for ( item in _items ) {
			item.recycle();
		}
		
		if ( _childrensnap == null ) return;
		_childrensnap.dispose();
		_childrensnap = null;
	}*/
}