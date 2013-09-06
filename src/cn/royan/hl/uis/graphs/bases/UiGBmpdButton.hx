package cn.royan.hl.uis.graphs.bases;

import cn.royan.hl.uis.graphs.UiGBmpdSprite;
import cn.royan.hl.uis.sparrow.Sparrow;

/**
 * ...
 * @author RoYan
 */
class UiGBmpdButton extends UiGBmpdSprite
{
	var textures:Array<Sparrow>;
	
	var status:Int;
	
	public function new( sparrows:Array<Sparrow> ) 
	{
		super(sparrows[0]);
		
		textures = sparrows;
		
		if ( textures[0].frame != null ) setSize(Std.int(textures[0].frame.width), Std.int(textures[0].frame.height));
		else setSize(Std.int(textures[0].regin.width), Std.int(textures[0].regin.height));
	}
	
	/**
	 * 获取当前材质
	 * @return
	 */
	override public function getTexture():Dynamic
	{
		return textures[status];
	}
}