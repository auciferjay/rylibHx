package cn.royan.hl.uis.bases;

import cn.royan.hl.interfaces.uis.IUiSelectBase;
import cn.royan.hl.uis.InteractiveUiBase;
import flash.events.Event;
import flash.events.MouseEvent;

import flash.display.BitmapData;

class UiBaseBmpdButton extends InteractiveUiBase, implements IUiSelectBase
{
	var bgTextures:Array<BitmapData>;
	var isInGroup:Bool;
	
	public function new(texture:Dynamic, length:Int=5 )
	{
		super();
	}
	
	//Public methods
	override public function getDefaultBackgroundColors():Array<Int> 
	{
		return [0xFFFFFF,0x00ff64,0x00ff64,0x00c850];
	}
	
	override public function getBackgroundAlphas():Array<Float> 
	{
		return [1.0,1.0,1.0,1.0];
	}
	
	public function setSelected(value:Bool):Void
	{
		
	}
	
	public function getSelected():Bool
	{
		return status == InteractiveUiBase.INTERACTIVE_STATUS_SELECTED;
	}
	
	public function setInGroup(value:Bool):Void
	{
		
	}
	
	public function clone():UiBaseBmpdButton
	{
		return new UiBaseBmpdButton(bgTextures);
	}
	
	//Protected methods
	function mouseMoveHandler(evt:MouseEvent):Void
	{
		
	}
	
	override private function addToStageHandler(evt:Event = null):Void 
	{
		super.addToStageHandler(evt);
		
		addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
	}
}