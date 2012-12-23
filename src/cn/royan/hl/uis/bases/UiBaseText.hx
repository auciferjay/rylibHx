package src.cn.royan.hl.uis.bases;

import cn.royan.hl.interfaces.uis.IUiTextBase;
import cn.royan.hl.uis.InteractiveUiBase;

class UiBaseText extends InteractiveUiBase, implements IUiTextBase
{

	public function new() 
	{
		
	}
	
	public function setText(value:String):Void;
	public function appendText(value:String):Void;
	public function getText():String;
	
	public function setHTMLText(value:String):Void;
	public function appendHTMLText(value:String):Void;
	public function getHTMLText():String;
	
	public function setTextAlign(value:Int):Void;
	public function setTextColor(value:UInt):Void;
	public function setTextSize(value:Int):Void;
	
	public function setEmbedFont(value:Bool):Void;
	
	public function setFormat(value:TextFormat):Void;
	public function getFormat():TextFormat;
	public function getDefaultFormat():TextFormat;
	
	public function setScroll(sx:Int=0, sy:Int=0):Void;
	public function getScroll():Array<Int>;
	public function getMaxScroll():Array<Int>;
	
	public function setMultiLine(value:Bool):Void;
}