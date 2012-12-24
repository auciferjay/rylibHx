package cn.royan.hl.uis.bases;

import cn.royan.hl.interfaces.uis.IUiPlayBase;
import cn.royan.hl.uis.InteractiveUiBase;

import flash.display.BitmapData;

class UiBaseBmpdMovieClip extends InteractiveUiBase, implements IUiPlayBase
{
	//properties
	var bgTextures:Array<BitmapData>;
	
	//Constructor
	public function new() 
	{
		super();
	}

	public function getIn():Void
	{

	}

	public function getOut():Void
	{

	}

	public function goTo(frame:Int):Void
	{

	}

	public function jumpTo(frame:Int):Void
	{

	}

	public function goFromTo(from:Int, to:Int):Void
	{
		
	}
	
}