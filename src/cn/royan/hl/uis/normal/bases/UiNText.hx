package cn.royan.hl.uis.normal.bases;

import cn.royan.hl.geom.Range;
import cn.royan.hl.interfaces.uis.IUiTextBase;
import cn.royan.hl.uis.normal.InteractiveUiN;

import flash.text.TextFieldType;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;

class UiNText extends InteractiveUiN, implements IUiTextBase
{
	static public inline var TEXT_ALIGN_LEFT:Int 	= 0;
	static public inline var TEXT_ALIGN_CENTER:Int 	= 1;
	static public inline var TEXT_ALIGN_RIGHT:Int	= 2;
	
	static public inline var TEXT_AUTOSIZE_NONE:Int = 0;
	static public inline var TEXT_AUTOSIZE_LEFT:Int = 1;
	static public inline var TEXT_AUTOSIZE_CENTER:Int = 2;
	static public inline var TEXT_AUTOSIZE_RIGHT:Int = 3;
	
	static public inline var TEXT_TYPE_INPUT:Int = 0;
	static public inline var TEXT_TYPE_PASSWORD:Int = 1;
	
	var inputText:TextField;
	var defaultSize:Float;
	
	public function new(label:String="") 
	{
		super();
		
		defaultSize = 12;
		
		inputText = new TextField();
		inputText.text = label;
		inputText.mouseEnabled 	= false;
		inputText.selectable	= false;
		inputText.height		= 20;
		inputText.width			= 100;
		addChild( inputText );

		containerWidth			= 100;
		containerHeight			= 20;
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
		
		var format:TextFormat = inputText.defaultTextFormat;
			format.size = Std.int(defaultSize * getScale());
			format.color = inputText.textColor;

		inputText.defaultTextFormat = format;
		inputText.setTextFormat(format);
		
		inputText.width 	= containerWidth * getScale();
		inputText.height 	= containerHeight * getScale();
	}
	#if (flash || js)
	public function setRestrict(value:String):Void
	{
		inputText.restrict = value;
	}
	#end
	
	public function setTextSpace(r:Int, c:Int):Void
	{
		var format:TextFormat = inputText.defaultTextFormat;
			format.kerning = true;
			format.leading = c;
			format.letterSpacing = r;
			format.color = inputText.textColor;
		inputText.defaultTextFormat = format;
	}
	
	public function setType(type:Int):Void
	{
		switch( type ) {
			case TEXT_TYPE_INPUT:
				inputText.type = TextFieldType.INPUT;
			case TEXT_TYPE_PASSWORD:
				inputText.type = TextFieldType.INPUT;
				inputText.displayAsPassword = true;
		}
		
		inputText.mouseEnabled 	= true;
		inputText.selectable	= true;
	}
	
	public function autoSize(value:Int):Void
	{
		switch( value ) {
			case TEXT_AUTOSIZE_NONE:
				inputText.autoSize = TextFieldAutoSize.NONE;
			case TEXT_AUTOSIZE_LEFT:
				inputText.autoSize = TextFieldAutoSize.LEFT;
			case TEXT_AUTOSIZE_CENTER:
				inputText.autoSize = TextFieldAutoSize.CENTER;
			case TEXT_AUTOSIZE_RIGHT:
				inputText.autoSize = TextFieldAutoSize.RIGHT;
		}
		
		setSize(Std.int(inputText.textWidth), Std.int(inputText.textHeight));
	}
	
	public function setText(value:String):Void
	{
		inputText.text = value;
	}
	
	public function appendText(value:String):Void
	{
		inputText.appendText(value);
	}
	
	public function getText():String
	{
		return inputText.text;
	}
	
	public function setHTMLText(value:String):Void
	{
		inputText.htmlText = value;
	}
	
	public function appendHTMLText(value:String):Void
	{
		inputText.htmlText += value;
	}
	
	public function getHTMLText():String
	{
		return inputText.htmlText;
	}
	
	public function setTextAlign(value:Int):Void
	{
		var format:TextFormat = inputText.defaultTextFormat;
			format.align = switch(value) {
				case TEXT_ALIGN_CENTER:
					TextFormatAlign.CENTER;
				case TEXT_ALIGN_RIGHT:
					TextFormatAlign.RIGHT;
				default:
					TextFormatAlign.LEFT;
			}
		inputText.defaultTextFormat = format;
	}
	
	public function setTextColor(value:Int):Void
	{
		inputText.textColor = value;
	}
	
	public function setTextSize(value:Int):Void
	{
		defaultSize = value;
		
		var format:TextFormat = inputText.defaultTextFormat;
			format.size = value;
		inputText.defaultTextFormat = format;
	}
	
	public function setEmbedFont(value:Bool):Void
	{
		inputText.embedFonts = value;
	}
	
	public function setFormat(value:TextFormat, begin:Int=-1, end:Int=-1):Void
	{
		inputText.setTextFormat(value,begin,end);
	}
	
	public function getFormat(begin:Int=-1, end:Int=-1):TextFormat
	{
		#if ( flash || js )
			return inputText.getTextFormat(begin, end);
		#else
			return null;
		#end
	}
	
	public function setDefaultFormat(value:TextFormat):Void
	{
		inputText.defaultTextFormat = value;
	}
	
	public function getDefaultFormat():TextFormat
	{
		return inputText.defaultTextFormat;
	}
	#if flash
	public function setScroll(sx:Int = 0, sy:Int = 0):Void
	{
		inputText.scrollH = sx;
		inputText.scrollV = sy;
	}
	
	public function getScroll():Range
	{
		return { x:inputText.scrollH, y:inputText.scrollV };
	}
	
	public function getMaxScroll():Range
	{
		return { x:inputText.maxScrollH, y:inputText.maxScrollV };
	}
	#end
	public function setMultiLine(value:Bool):Void
	{
		inputText.multiline = value;
		inputText.wordWrap = value;
	}
	
	public function setMaxChars(value:Int):Void
	{
		inputText.maxChars = value;
	}
}