package cn.royan.hl.uis.starling.exts;

import cn.royan.hl.uis.starling.bases.UiSBmpdMovieClip;
import cn.royan.hl.uis.starling.bases.UiSContainerAlign;
import starling.textures.Texture;

/**
 * ...
 * @author RoYan
 */
class UiSExtBmpNumberText extends UiSContainerAlign
{
	private var isAlwaysShow:Bool;
	private var num:Int;
		
	public function new(texture:Array<Texture>, length:Int = 1)
	{
		super();
		
		var instance:UiSBmpdMovieClip = new UiSBmpdMovieClip(texture);
		
		for( i in 0...length ){
			cast(addItem(instance.clone()), UiSBmpdMovieClip).visible = isAlwaysShow;
		}
	}
	
	public function setIsAlwaysShow(value:Bool):Void
	{
		isAlwaysShow = value;
	}
	
	public function setValue(value:Int):Void
	{
		for( i in 0...items.length ){
			cast(getItemAt(i), UiSBmpdMovieClip).jumpTo(1);
			cast(getItemAt(i), UiSBmpdMovieClip).visible = isAlwaysShow;
		}
		num = value;
		
		var str:String = Std.string(value);
		var i:Int = str.length;
		var j:Int = 1;
		while( i >= 0 || j <= Math.min(items.length, str.length) ){
			cast(getItemAt(items.length - j), UiSBmpdMovieClip).visible = true;
			cast(getItemAt(items.length - j), UiSBmpdMovieClip).jumpTo(1 + Std.parseInt(str.charAt(i)));
			
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