package cn.royan.hl.uis.bases;

import cn.royan.hl.geom.Position;
import cn.royan.hl.interfaces.uis.IUiSelectBase;
import cn.royan.hl.interfaces.uis.IUiTextBase;
import cn.royan.hl.uis.InteractiveUiBase;

import flash.text.TextFormat;

class UiBaseLabelButton extends InteractiveUiBase, implements IUiTextBase, implements IUiSelectBase
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
	override public function getDefaultBackgroundColors():Array<Int> 
	{
		return [0xFFFFFF,0x00ff64,0x00ff64,0x00c850,0x00c850,0xe9f48e,0xe9f48e,0xa2a29e,0xa2a29e,0xFFFFFF];
	}
	
	override public function getBackgroundAlphas():Array<Float> 
	{
		return [1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0];
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
	
	public function setTextColor(value:Int):Void
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
	
	public function setFormat(value:TextFormat, begin:Int=-1, end:Int=-1):Void
	{
		btnLabelText.setFormat(value,begin,end);
	}
	
	public function getFormat(begin:Int=-1, end:Int=-1):TextFormat
	{
		return btnLabelText.getFormat(begin,end);
	}
	
	public function setDefaultFormat(value:TextFormat):Void
	{
		btnLabelText.setDefaultFormat(value);
	}
	
	public function getDefaultFormat():TextFormat
	{
		return btnLabelText.getDefaultFormat();
	}
	#if flash
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
	#end
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