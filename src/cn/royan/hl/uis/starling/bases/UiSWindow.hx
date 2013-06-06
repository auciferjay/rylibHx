package cn.royan.hl.uis.starling.bases;
import starling.events.Touch;
import starling.textures.Texture;

/**
 * ...
 * @author RoYan
 */
class UiSWindow extends UiSContainer
{
	var header:UiSLabelButton;
	
	public function new(texture:Texture = null) 
	{
		header = new UiSLabelButton("");
		
		super(texture);
		
		header.setSize(getRange().width, header.getRange().height);
		header.setCallbacks( { move:moveHandler } );
		header.buttonMode = false;
		addItem(header);
	}
	
	public function setHeaderHeight(value:Int):Void
	{
		header.setSize(getRange().width, value);
	}
	
	function moveHandler(obj:UiSLabelButton, touch:Touch):Void
	{
		setPosition(touch.getMovement(this).x + getRange().x, touch.getMovement(this).y + getRange().y);
	}
}