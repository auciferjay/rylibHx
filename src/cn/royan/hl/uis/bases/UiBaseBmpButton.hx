package src.cn.royan.hl.uis.bases;

import cn.royan.hl.interfaces.uis.IUiSelectBase;
import cn.royan.hl.uis.InteractiveUiBase;
import flash.events.Event;
import flash.events.MouseEvent;

import flash.display.BitmapData;

class UiBaseBmpButton extends InteractiveUiBase, implements IUiSelectBase
{
	var bgTextures:Array<BitmapData>;
	var isInGroup:Bool;
	
	public function new(texture:Dynamic < Array<BitmapData>, BitmapData > , length:UInt = 5 ) 
	{
		
	}
	
	//Public methods
	override public function getDefaultBackgroundColors():Array<UInt> 
	{
		return [[0xFFFFFF,0x00ff64],[0x00ff64,0x00c850],[0x00c850,0xe9f48e],[0xe9f48e,0xa2a29e],[0xa2a29e,0xFFFFFF]];
	}
	
	override public function getBackgroundAlphas():Array<Float> 
	{
		return [[1.0,1.0],[1.0,1.0],[1.0,1.0],[1.0,1.0],[1.0,1.0]];
	}
	
	public function setSelected(value:Bool):Void
	{
		
	}
	
	public function getSelected():Bool
	{
		return status == INTERACTIVE_STATUS_SELECTED;
	}
	
	public function setInGroup(value:Bool):Void
	{
		
	}
	
	public function clone():UiBaseBmpButton
	{
		return new UiBaseBmpButton(bgTextures);
	}
	
	//Protected methods
	function mouseMoveHandler(evt:MouseEvent):Void
	{
		
	}
	
	override private function addToStageHandler(evt:Event = Null):Void 
	{
		super.addToStageHandler(evt);
		
		addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
	}
}