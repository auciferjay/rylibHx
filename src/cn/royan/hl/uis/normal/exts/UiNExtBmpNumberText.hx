package cn.royan.hl.uis.normal.exts;

import cn.royan.hl.uis.normal.bases.UiNContainerAlign;
import cn.royan.hl.uis.normal.bases.UiNBmpdMovieClip;

import starling.textures.Texture;
import flash.display.BitmapData;

/**
 * ...
 * @author RoYan
 */
class UiNExtBmpNumberText extends UiNContainerAlign
{
	var instance:UiNBmpdMovieClip;
	var isAlwaysShow:Bool;
	var num:Int;
	var length:Int;
		
	public function new(texture:Array<Texture>, len:Int = 1)
	{
		super();
		
		length = len;
		instance = new UiNBmpdMovieClip(texture, 10, false, 10, 1, 10);
	}
	
	public function setIsAlwaysShow(value:Bool):Void
	{
		isAlwaysShow = value;
		
		if ( isAlwaysShow ) {
			for ( i in 0...length ) {
				cast(addItem(instance.clone()), UiNBmpdMovieClip).visible = isAlwaysShow;
			}
		}
	}
	
	public function setValue(value:Int):Void
	{
		var str:String = Std.string(value);
		var i:Int = str.length;
		var j:Int = 1;
		
		if ( isAlwaysShow ) {
			for( i in 0...items.length ){
				cast(getItemAt(i), UiNBmpdMovieClip).jumpTo(1);
			}
			num = value;
			
			while( i >= 0 || j <= Math.min(items.length, str.length) ){
				cast(getItemAt(items.length - j), UiNBmpdMovieClip).visible = true;
				cast(getItemAt(items.length - j), UiNBmpdMovieClip).jumpTo(1 + Std.parseInt(str.charAt(i)));
				
				i--;
				j++;
			}
		}else {
			removeAllItems();
			
			i = 0;
			while ( i < str.length ) {
				cast(addItem(instance.clone()), UiNBmpdMovieClip).jumpTo(1 + Std.parseInt(str.charAt(i)));
				
				i++;
			}
		}
	}
	
	public function getValue():Int
	{
		return num;
	}
}