package cn.royan.hl.uis.graphs;

import cn.royan.hl.uis.graphs.UiGDisplayObject;

import flash.text.TextFormat;
import flash.text.TextField;
import flash.display.BitmapData;

/**
 * ...
 * @author RoYan
 */
class UiGText extends UiGDisplayObject
{
	public var text(getText, setText):String;
	public var htmlText(getHtmlText, setHtmlText):String;
	public var format(getFormat, setFormat):TextFormat;
	
	private var _text:String;
	private var _htmlText:String;
	private var _format:TextFormat;
	
	private var _textfield:TextField;
	
	public function new() 
	{
		super();
		
		_text = "";
		_htmlText = "";
		
		_textfield = new TextField();
		
		width = 100;
		height = 100;
	}
	
	override public function draw():Void 
	{
		if ( !_renderFlags ) return;
		if ( _invaildBound ) _snap = new BitmapData(width, height, true, 0x00FF);
		
		_textfield.width = width;
		_textfield.height = height;
		
		if ( _text.length > 0 )
			_textfield.text = _text;
		if ( _htmlText.length > 0 )
			_textfield.htmlText = _htmlText;
		
		if( _format != null )
			_textfield.setTextFormat(_format);
		
		_snap.draw(_textfield);
		
		_invaildBound = false;
		_renderFlags = false;
	}
	
	public function getText():String
	{
		return _text;
	}
	
	public function setText(value:String):String
	{
		_text = value;
		updateDisplayList();
		return _text;
	}
	
	public function getHtmlText():String
	{
		return _htmlText;
	}
	
	public function setHtmlText(value:String):String
	{
		_htmlText = value;
		updateDisplayList();
		return _htmlText;
	}
	
	public function getFormat():TextFormat
	{
		return _format;
	}
	
	public function setFormat(value:TextFormat):TextFormat
	{
		_format = value;
		updateDisplayList();
		return _format;
	}
}