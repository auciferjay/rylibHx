package cn.royan.hl.uis.normal.bases;

import cn.royan.hl.consts.UiConst;
import cn.royan.hl.geom.Range;
import cn.royan.hl.interfaces.uis.IUiItemGroupBase;
import cn.royan.hl.interfaces.uis.IUiTextBase;
import cn.royan.hl.uis.normal.InteractiveUiN;
import cn.royan.hl.uis.normal.UninteractiveUiN;
import cn.royan.hl.uis.sparrow.Sparrow;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.text.TextFormat;
import flash.events.MouseEvent;

/**
 * ...
 * @author RoYan
 */
class UiNLabelButton extends UiNBmpdButton, implements IUiTextBase, implements IUiItemGroupBase
{
	//properties
	var isCenter:Bool;
	var btnLabel:String;
	var btnLabelText:UiNText;
	var textColors:Array<Dynamic>;
	
	//Contructor
	public function new(label:String='', texture:Dynamic=null, frames:Int=5) 
	{
		btnLabelText = new UiNText();
		btnLabelText.setText(label);
		
		super(texture, frames);
		
		containerWidth = 100;
		containerHeight = 20;
		
		bgTextures = [];
		
		btnLabel = label;
		textColors = getDefaultTextColor();
		
		addChild(btnLabelText);
		
		setMouseRender(true);
		
		buttonMode = true;
	}
	
	//Public methods
	override public function draw():Void
	{
		//if ( !isOnStage ) return;
		super.draw();
		btnLabelText.setTextColor(textColors[status]);
	}
	
	override function mouseClickHandler(evt:MouseEvent):Void
	{
		if( isInGroup ){
			selected = !selected;
			status = selected?UiConst.INTERACTIVE_STATUS_SELECTED:status;
			
			viewChanged();
		}
		super.mouseClickHandler(evt);
	}
	
	public function getDefaultTextColor():Array<Dynamic>
	{
		return [0x000000,0x666666,0xFFFFFF,0xFFFFFF,0xCCCCCC];
	}
	
	public function autoCenter():Void
	{
		isCenter = true;
		btnLabelText.autoSize(UiConst.TEXT_AUTOSIZE_LEFT);
		btnLabelText.setPosition((getRange().width - btnLabelText.getRange().width)/2, (getRange().height - btnLabelText.getRange().height)/2);
	}
	
	public function setTextSpace(r:Int, c:Int):Void
	{
		btnLabelText.setTextSpace(r, c);
	}
	
	public function setType(type:Int):Void
	{
		throw "";
	}
	
	public function setTextColors(value:Array<Dynamic>):Void
	{
		textColors = value.concat([]);
		viewChanged();
	}
	
	override public function setSize(cWidth:Float, cHeight:Float):Void
	{
		super.setSize(cWidth, cHeight);
		if ( isCenter ) {
			autoCenter();
		}else {
			btnLabelText.setSize(cWidth, cHeight);
		}
	}
	
	override public function setScale(value:Float):Void 
	{
		super.setScale(value);
		btnLabelText.setScale(value);
	}
	
	public function setTextMargin(left:Int, top:Int, right:Int, bottom:Int):Void
	{  
		btnLabelText.setSize(getRange().width - left - right, getRange().height - top - bottom);
		btnLabelText.setPosition(left, top);
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
	
	public function getScroll():Range
	{
		return btnLabelText.getScroll();
	}
	
	public function getMaxScroll():Range
	{
		return btnLabelText.getMaxScroll();
	}
	#end
	public function setMultiLine(value:Bool):Void
	{
		btnLabelText.setMultiLine(value);
	}
}