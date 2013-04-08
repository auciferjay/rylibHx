package cn.royan.hl.uis.normal.exts;

import cn.royan.hl.uis.normal.bases.UiBaseContainerAlign;
import cn.royan.hl.uis.normal.bases.UiBaseBmpdMovieClip;
import flash.display.BitmapData;

/**
 * ...
 * @author RoYan
 */

class UiExtBmpNumberText extends UiBaseContainerAlign
{

	private var isAlwaysShow:Bool;
	private var num:Int;
		
	public function new(texture:BitmapData, length:Int = 1)
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
			cast(getItemAt(i), UiBaseBmpdMovieClip).jumpTo(1);
			cast(getItemAt(i), UiBaseBmpdMovieClip).visible = isAlwaysShow;
		}
		num = value;
		
		var str:String = Std.string(value);
		var i:Int = str.length;
		var j:Int = 1;
		while( i >= 0 || j <= Math.min(items.length, str.length) ){
			cast(getItemAt(items.length - j), UiBaseBmpdMovieClip).visible = true;
			cast(getItemAt(items.length - j), UiBaseBmpdMovieClip).jumpTo(1 + Std.parseInt(str.charAt(i)));
			
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