package src.cn.royan.hl.uis.bases;

import cn.royan.hl.geom.Position;
import cn.royan.hl.interfaces.uis.IUiSelectBase;
import cn.royan.hl.interfaces.uis.IUiTextBase;
import cn.royan.hl.uis.InteractiveUiBase;

class UiBaseLabelButton extends InteractiveUiBase, implements IUiTextBase, IUiSelectBase
{
	//properties
	var btnLabelText:UiBaseText;
	var isInGroup:Bool;
	
	//Contructor
	public function new() 
	{
		super();
	}
	
	//Public methods
	public function setSelected(value:Bool):Void
	{
		
	}
	
	public function getSelected():Bool
	{
		return status == INTERACTIVE_STATUS_SELECTED;
	}
	
	public function setInGroup(value:Bool):Void
	{
		isInGroup = value;
	}
	
	public function setText(value:String):Void
	{
		btnLabelText.setText(value);
	}
	
	public function appendText(value:String):Void
	{
		btnLabelText.appendText(value);
	}
	
	public function getText():String
	{
		return btnLabelText.getText();
	}
	
	public function setHTMLText(value:String):Void
	{
		btnLabelText.setHTMLText(value);
	}
	
	public function appendHTMLText(value:String):Void
	{
		btnLabelText.appendHTMLText(value);
	}
	
	public function getHTMLText():String
	{
		return btnLabelText.getHTMLText();
	}
	
	public function setTextAlign(value:Int):Void
	{
		btnLabelText.setTextAlign(value);
	}
	
	public function setTextColor(value:UInt):Void
	{
		btnLabelText.setTextColor(value);
	}
	
	public function setTextSize(value:Int):Void
	{
		btnLabelText.setTextSize(value);
	}
	
	public function setEmbedFont(value:Bool):Void
	{
		btnLabelText.setEmbedFont(value);
	}
	
	public function setFormat(value:TextFormat):Void
	{
		btnLabelText.setFormat(value);
	}
	
	public function getFormat():TextFormat
	{
		return btnLabelText.getFormat();
	}
	
	public function getDefaultFormat():TextFormat
	{
		return btnLabelText.getDefaultFormat();
	}
	
	public function setScroll(sx:Int = 0, sy:Int = 0):Void
	{
		btnLabelText.setScroll(sx, sy);
	}
	
	public function getScroll():Position
	{
		return btnLabelText.getScroll();
	}
	
	public function getMaxScroll():Position
	{
		return btnLabelText.getMaxScroll();
	}
	
	public function setMultiLine(value:Bool):Void
	{
		btnLabelText.setMultiLine(value);
	}
	
	override public function setSize(w:Int, h:Int):Void 
	{
		super.setSize(w, h);
		btnLabelText.setSize(w, h);
	}
}