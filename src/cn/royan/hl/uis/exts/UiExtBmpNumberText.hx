package cn.royan.hl.uis.exts;

import browser.display.BitmapData;
import cn.royan.hl.uis.bases.UiBaseContainerAlign;
import cn.royan.hl.uis.bases.UiBaseBmpdMovieClip;

/**
 * ...
 * @author RoYan
 */

class UiExtBmpNumberText extends UiBaseContainerAlign
{

	private var isAlwaysShow:Bool;
	private var num:int;
		
	public function new(texture:BitmapData, length:int = 1)
	{
		super();
		
		var instance:UiBaseBmpdMovieClip = new UiBaseBmpdMovieClip(texture, 10, false, 10, 1, 10);
		
		for( i in 0...length ){
			cast(addItem(instance.clone()), UiBaseBmpdMovieClip).visible = isAlwaysShow;
		}
	}
	
	public function setIsAlwaysShow(value:Bool):Void
	{
		isAlwaysShow = value;
	}
	
	public function setValue(value:Int):Void
	{
		for( i in 0...items.length ){
			(getItemAt(i) as UiBaseBmpdMovieClip).jumpTo(1);
			(getItemAt(i) as UiBaseBmpdMovieClip).visible = isAlwaysShow;
		}
		num = value;
		
		var str:String = value.toString();
		var i:Int = str.length;
		var j:Int = 1;
		while( i >= 0 || j <= Math.min(items.length, str.length) ){
			(getItemAt(items.length - j) as UiBaseBmpdMovieClip).visible = true;
			(getItemAt(items.length - j) as UiBaseBmpdMovieClip).jumpTo(1 + Std.parseInt(str.charAt(i)));
			
			i--;
			j++;
		}
		
		draw();
	}
	
	public function getValue():Int
	{
		return num;
	}
}