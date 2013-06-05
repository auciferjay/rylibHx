package cn.royan.hl.uis.starling.bases;

import cn.royan.hl.consts.UiConst;
import cn.royan.hl.geom.Range;
import cn.royan.hl.interfaces.uis.IUiTextBase;
import cn.royan.hl.uis.starling.InteractiveUiS;

import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import starling.text.TextField;
import starling.utils.HAlign;

/**
 * ...
 * @author RoYan
 */
class UiSText extends InteractiveUiS, implements IUiTextBase
{
	var inputText:TextField;
	var fontSize:Float;
	
	public function new(label:String="", fontN:String="", fontS:Int=12, fontC:UInt=0x00, fontB:Bool=false) 
	{
		super();
		
		fontSize = fontS;
		
		inputText = new TextField(100, 20, label, fontN, fontSize, fontC, fontB);
		addChild( inputText );
	}
	
	override public function setSize(w:Float, h:Float):Void
	{
		super.setSize(w, h);
		
		inputText.width = containerWidth * getScale();
		inputText.height = containerHeight * getScale();
	}
	
	override public function setScale(value:Float):Void 
	{
		super.setScale(value);
		
		inputText.fontSize 	= fontSize * scale;
		inputText.width 	= containerWidth * scale;
		inputText.height 	= containerHeight * scale;
	}
	
	public function setTextSpace(r:Int, c:Int):Void
	{
		inputText.kerning = true;
	}
	
	public function setType(type:Int):Void
	{
	}
	
	public function autoSize(value:Int):Void
	{
		
	}
	
	public function setText(value:String):Void
	{
		inputText.text = value;
	}
	
	public function appendText(value:String):Void
	{
		inputText.text += value;
	}
	
	public function getText():String
	{
		return inputText.text;
	}
	
	public function setHTMLText(value:String):Void
	{
		
	}
	
	public function appendHTMLText(value:String):Void
	{
		
	}
	
	public function getHTMLText():String
	{
		return "";
	}
	
	public function setTextAlign(value:Int):Void
	{
		inputText.hAlign = switch(value) {
				case UiConst.TEXT_ALIGN_CENTER:
					HAlign.CENTER;
				case UiConst.TEXT_ALIGN_RIGHT:
					HAlign.RIGHT;
				default:
					HAlign.LEFT;
			}
	}
	
	public function setTextColor(value:Int):Void
	{
		inputText.color = value;
	}
	
	public function setTextSize(value:Int):Void
	{
		fontSize = value;
		
		inputText.fontSize = fontSize;
	}
	
	public function setEmbedFont(value:Bool):Void
	{
		
	}
	
	public function setFormat(value:TextFormat, begin:Int=-1, end:Int=-1):Void
	{
		
	}
	
	public function getFormat(begin:Int=-1, end:Int=-1):TextFormat
	{
		return null;
	}
	
	public function setDefaultFormat(value:TextFormat):Void
	{
		
	}
	
	public function getDefaultFormat():TextFormat
	{
		return null;
	}
	
	public function setScroll(sx:Int = 0, sy:Int = 0):Void
	{
		
	}
	
	public function getScroll():Range
	{
		return null;
	}
	
	public function getMaxScroll():Range
	{
		return null;
	}
	
	public function setMultiLine(value:Bool):Void
	{
		
	}
	
	public function setMaxChars(value:Int):Void
	{
		
	}
}