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
		
		header.setCallbacks( { move:moveHandler } );
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
	
	function moveHandler(obj:UiSLabelButton, touch:Touch):Void
	{
		setPosition(touch.getMovement(this).x + getRange().x, touch.getMovement(this).y + getRange().y);
	}
}