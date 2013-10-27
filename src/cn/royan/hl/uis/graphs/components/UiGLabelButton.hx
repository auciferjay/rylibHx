package cn.royan.hl.uis.graphs.components;

import cn.royan.hl.uis.graphs.components.UiGButton;
import cn.royan.hl.uis.graphs.UiGText;
import cn.royan.hl.uis.sparrow.Sparrow;

/**
 * ...
 * @author RoYan
 */
class UiGLabelButton extends UiGButton
{
	public var label(getLabel, setLabel):UiGText;
	
	private var _labelTxt:UiGText;
	
	public function new(label:String, sparrows:Array<Sparrow>) 
	{
		super(sparrows);
		
		_labelTxt = new UiGText();
		_labelTxt.text = label;
		_labelTxt.width = width;
		_labelTxt.height = height;
		addChild(_labelTxt);
	}
	
	public function getLabel():UiGText
	{
		return _labelTxt;
	}
	
	public function setLabel(value:UiGText):UiGText
	{
		_labelTxt = value;
		updateDisplayList();
		return _labelTxt;
	}
}