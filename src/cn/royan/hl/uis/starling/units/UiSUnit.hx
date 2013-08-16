package cn.royan.hl.uis.starling.units;

import cn.royan.hl.geom.Range;
import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.uis.sparrow.Sparrow;
import flash.events.EventDispatcher;

/**
 * ...
 * @author RoYan
 */
class UiSUnit
{
	var bgTexture:Sparrow;
	
	public function new(texture:Sparrow)
	{
		bgTexture = texture;
		setSize(Std.int(bgTexture.regin.width), Std.int(bgTexture.regin.height));
	}
	
	/**
	 * 设置尺寸
	 * @param	cWidth
	 * @param	cHeight
	 */
	function setSize(cWidth:Float, cHeight:Float):Void;
	
	/**
	 * 设置位置
	 * @param	cX
	 * @param	cY
	 */
	function setPosition(cX:Float, cY:Float):Void;
	
	/**
	 * 设置范围
	 * @param	value	{width:..., height:..., x:..., y:...}
	 */
	function setRange(value:Range):Void;
	
	/**
	 * 获取范围
	 * @return	{width:..., height:..., x:..., y:...}
	 */
	function getRange():Range;
	
	/**
	 * 设置材质
	 * @param	texture		Sparrow/Texture(Starling)
	 * @param	frames
	 */
	function setTexture(texture:Dynamic, frames:Int = 1):Void;
	
	/**
	 * 获取当前材质
	 * @return
	 */
	function getTexture():Dynamic;
}