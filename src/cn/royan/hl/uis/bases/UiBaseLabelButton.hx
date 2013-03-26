package cn.royan.hl.uis.bases;

import cn.royan.hl.geom.Position;
import cn.royan.hl.interfaces.uis.IUiItemGroupBase;
import cn.royan.hl.interfaces.uis.IUiTextBase;
import cn.royan.hl.uis.InteractiveUiBase;
import cn.royan.hl.uis.UninteractiveUiBase;
import cn.royan.hl.utils.SystemUtils;

import flash.text.TextFormat;
import flash.display.BitmapData;
import flash.events.MouseEvent;

class UiBaseLabelButton extends InteractiveUiBase, implements IUiTextBase, implements IUiItemGroupBase
{
	//properties
	var btnLabel:String;
	var bgTextures:Array<UninteractiveUiBase>;
	var currentStatus:UninteractiveUiBase;
	var btnBackground:InteractiveUiBase;
	var textColors:Array<Dynamic>;
		
	var btnLabelText:UiBaseText;
	var isInGroup:Bool;
	
	//Contructor
	public function new(label:String='') 
	{
		super();
		
		bgColors = getDefaultBackgroundColors();
		bgAlphas = getDefaultBackgroundAlphas();
		
		btnLabel = label;
		statusLen = 5;
		bgTextures = [];
		
		var i:Int;
		for( i in 0...statusLen){
			bgTextures[i] = new UninteractiveUiBase();
			bgTextures[i].setBackgroundColors(Std.is(bgColors[i], Array)?bgColors[i]:[bgColors[i]]);
			bgTextures[i].setBackgroundAlphas(Std.is(bgAlphas[i], Array)?bgAlphas[i]:[bgAlphas[i]]);
		}
		
		textColors = getDefaultTextColor();
		
		btnBackground = new InteractiveUiBase();
		addChild(btnBackground);
		
		btnLabelText = new UiBaseText();
		btnLabelText.setText(label);
		addChild(btnLabelText);
		
		setMouseRender(true);
		
		buttonMode = true;
	}
	
	//Public methods
	override public function draw():Void
	{
		btnBackground.removeAllChildren();
		
		if( bgTextures[status] != null )
			btnBackground.addChild(bgTextures[status]);
		
		btnLabelText.setTextColor(textColors[status]);
	}
	
	override function mouseClickHandler(evt:MouseEvent):Void
	{
		if( isInGroup ){
			selected = !selected;
			status = selected?InteractiveUiBase.INTERACTIVE_STATUS_SELECTED:status;
			
			draw();
		}
		super.mouseClickHandler(evt);
	}
	
	public function getDefaultTextColor():Array<Dynamic>
	{
		return [0x000000,0xFF00FF,0xFFFFFF,0xFFFFFF,0xCCCCCC];
	}
	
	override public function getDefaultBackgroundColors():Array<Dynamic>
	{
		return [[0xFF0000,0xFF00FF],[0xFFFF00,0xFF00FF],[0xFF00FF,0x00FFFF],[0x0000FF,0xFF0000],[0xFFF000,0x000FFF]];
	}
	
	override public function getDefaultBackgroundAlphas():Array<Dynamic>
	{
		return [[1,1],[1,1],[1,1],[1,1],[1,1]];
	}
	
	public function autoSize(value:Int):Void
	{
		btnLabelText.autoSize(value);
	}
	
	public function setTextColors(value:Array<Dynamic>):Void
	{
		textColors = value.concat([]);
		draw();
	}
	
	override public function setBackgroundColors(value:Array<Dynamic>):Void
	{
		super.setBackgroundColors(value);
		var i:Int;
		for( i in 0...statusLen ){
			bgTextures[i].setBackgroundColors(Std.is(bgColors[i], Array)?bgColors[i]:[bgColors[i]]);
		}
	}
	
	override public function setBackgroundAlphas(value:Array<Dynamic>):Void
	{
		super.setBackgroundAlphas(value);
		var i:Int;
		for( i in 0...statusLen ){
			bgTextures[i].setBackgroundAlphas(Std.is(bgAlphas[i], Array)?bgAlphas[i]:[bgAlphas[i]]);
		}
	}
	
	public function setSelected(value:Bool):Void
	{
		selected = value;
		status = selected?InteractiveUiBase.INTERACTIVE_STATUS_SELECTED:InteractiveUiBase.INTERACTIVE_STATUS_NORMAL;
		draw();
	}
	
	public function getSelected():Bool
	{
		return selected;
	}
	
	override public function setTexture(value:BitmapData, frames:Int=5):Void
	{
		
	}
	
	public function setInGroup(value:Bool):Void
	{
		isInGroup = value;
	}
	
	override public function setSize(cWidth:Int, cHeight:Int):Void
	{
		super.setSize(cWidth, cHeight);
		for ( state in bgTextures ){
			state.setSize(cWidth, cHeight);
		}
		btnLabelText.setSize(cWidth, cHeight);
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