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
		
		header.setCallbacks( { down:downHandler, up:upHandler } );
		header.buttonMode = false;
		addItem(header);
	}
	
	override public function setSize(w:Float, h:Float):Void 
	{
		super.setSize(w, h);
		
		header.setSize(w, header.getRange().height);
	}
	
	override public function setScale(value:Float):Void 
	{
		super.setScale(value);
		
		header.setScale(value);
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