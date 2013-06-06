package cn.royan.hl.uis.normal.bases;
import cn.royan.hl.uis.sparrow.Sparrow;
import flash.events.Event;

/**
 * ...
 * @author RoYan
 */
class UiNWindow extends UiNContainer
{
	var header:UiNLabelButton;
	
	public function new(texture:Sparrow = null) 
	{
		header = new UiNLabelButton("");
		
		super(texture);
		
		header.setSize(getRange().width, header.getRange().height);
		header.setCallbacks( { down:downHandler, up:upHandler } );
		header.buttonMode = false;
		addItem(header);
	}
	
	public function setHeaderHeight(value:Int):Void
	{
		header.setSize(getRange().width, value);
	}
	
	function downHandler(obj:UiNLabelButton):Void
	{
		startDrag();
	}
	
	function upHandler(obj:UiNLabelButton):Void
	{
		stopDrag();
	}
}