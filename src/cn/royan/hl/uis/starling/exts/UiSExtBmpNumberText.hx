package cn.royan.hl.uis.starling.exts;

import cn.royan.hl.uis.starling.bases.UiSBmpdMovieClip;
import cn.royan.hl.uis.starling.bases.UiSContainerAlign;
import cn.royan.hl.utils.SystemUtils;

import starling.textures.Texture;

/**
 * ...
 * @author RoYan
 */
class UiSExtBmpNumberText extends UiSContainerAlign
{
	var instance:UiSBmpdMovieClip;
	var isAlwaysShow:Bool;
	var num:Int;
	var length:Int;
		
	public function new(texture:Array<Texture>, len:Int = 1)
	{
		super();
		
		length = len;
		instance = new UiSBmpdMovieClip(texture, 10, false);
		
		setSize( instance.getRange().width * length, instance.getRange().height );
	}
	
	public function setIsAlwaysShow(value:Bool):Void
	{
		isAlwaysShow = value;
		
		if ( isAlwaysShow ) {
			for ( i in 0...length ) {
				cast(addItem(instance.clone()), UiSBmpdMovieClip).visible = isAlwaysShow;
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
				cast(getItemAt(i), UiSBmpdMovieClip).jumpTo(1);
			}
			num = value;
			
			while( i >= 0 || j <= Math.min(items.length, str.length) ){
				cast(getItemAt(items.length - j), UiSBmpdMovieClip).visible = true;
				cast(getItemAt(items.length - j), UiSBmpdMovieClip).jumpTo(1 + Std.parseInt(str.charAt(i)));
				
				i--;
				j++;
			}
		}else {
			removeAllItems();
			
			i = 0;
			while ( i < str.length ) {
				cast(addItem(instance.clone()), UiSBmpdMovieClip).jumpTo(1 + Std.parseInt(str.charAt(i)));
				
				i++;
			}
		}
	}
	
	public function getValue():Int
	{
		return num;
	}
}