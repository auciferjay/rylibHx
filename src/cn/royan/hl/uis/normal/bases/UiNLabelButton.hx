package cn.royan.hl.uis.normal.bases;

import cn.royan.hl.geom.Position;
import cn.royan.hl.interfaces.uis.IUiItemGroupBase;
import cn.royan.hl.interfaces.uis.IUiTextBase;
import cn.royan.hl.uis.normal.InteractiveUiN;
import cn.royan.hl.uis.normal.UninteractiveUiN;
import cn.royan.hl.uis.sparrow.Sparrow;

import flash.geom.Rectangle;
import flash.text.TextFormat;
import flash.events.MouseEvent;

class UiNLabelButton extends UiNBmpdButton, implements IUiTextBase, implements IUiItemGroupBase
{
	//properties
	var btnLabel:String;
	var btnLabelText:UiNText;
	var textColors:Array<Dynamic>;
	
	//Contructor
	public function new(label:String='', texture:Sparrow=null) 
	{
		super(texture);
		
		bgTextures = [];
		
		bgColors = getDefaultBackgroundColors();
		bgAlphas = getDefaultBackgroundAlphas();
		
		btnLabel = label;
		textColors = getDefaultTextColor();
		
		btnLabelText = new UiNText();
		btnLabelText.setText(label);
		addChild(btnLabelText);
		
		setMouseRender(true);
		
		buttonMode = true;
	}
	
	//Public methods
	override public function draw():Void
	{
		super.draw();
		btnLabelText.setTextColor(textColors[status]);
	}
	
	override function mouseClickHandler(evt:MouseEvent):Void
	{
		if( isInGroup ){
			selected = !selected;
			status = selected?InteractiveUiN.INTERACTIVE_STATUS_SELECTED:status;
			
			draw();
		}
		super.mouseClickHandler(evt);
	}
	
	public function getDefaultTextColor():Array<Dynamic>
	{
		return [0x000000,0xFF00FF,0xFFFFFF,0xFFFFFF,0xCCCCCC];
	}
	
	public function autoSize(value:Int):Void
	{
		btnLabelText.autoSize(value);
	}
	
	public function setType(type:Int):Void
	{
		
	}
	
	public function setTextColors(value:Array<Dynamic>):Void
	{
		textColors = value.concat([]);
		draw();
	}
	
	override public function setSize(cWidth:Int, cHeight:Int):Void
	{
		super.setSize(cWidth, cHeight);
	}
	
	public function setTextMargin(t:Int, r:Int, b:Int, l:Int ):Void
	{
		btnLabelText.setPosition(t, r);
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
}