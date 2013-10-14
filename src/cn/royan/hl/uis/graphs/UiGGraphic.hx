package cn.royan.hl.uis.graphs;

import cn.royan.hl.uis.sparrow.Sparrow;

/**
 * ...
 * @author RoYan
 */
class UiGGraphic
{
	private var _texture:Sparrow;
	
	public function new(texture:Sparrow = null) 
	{
		_texture = texture;
	}
	
	public function setTexture(value:Sparrow):Void
	{
		_texture = value;
	}
	
	public function getTexture():Sparrow
	{
		return _texture;
	}
	
	public function clean():Void
	{
		_texture.dispose();
		_texture = null;
	}
}