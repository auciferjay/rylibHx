package cn.royan.hl.interfaces.uis;

import cn.royan.hl.geom.Range;
import cn.royan.hl.interfaces.IDisposeBase;

import flash.geom.Rectangle;
import flash.events.EventDispatcher;

/**
 * ...
 * 基础显示接口，所有显示类继承此接口，继承自可销毁接口
 * <p>IUiBase->IDisposeBase</p>
 * @author RoYan
 */
interface IUiBase implements IDisposeBase
{
	/**
	 * 画布刷新
	 */
	function draw():Void;
	
	/**
	 * 设置毁掉函数
	 * @param	value {click:..., up:..., down:..., over:..., out:...}
	 */
	function setCallbacks(value:Dynamic):Void;
	
	/**
	 * 设置背景颜色以及对应透明度
	 * @param	color 	[0xFFFFFF, 0xFFFF00, 0xFF0000]/[[0xFFFFFF, 0xFFFF00, 0xFF0000],[0xFFFFFF, 0xFFFF00, 0xFF0000]]
	 * @param	alpha 	[1, .5, 0]/[[1, .5, 0],[1, .5, 0]]
	 */
	function setColorsAndAplhas(color:Array<Dynamic>, alpha:Array<Dynamic>):Void;
	
	/**
	 * 获取背景颜色
	 * @return [0xFFFFFF, 0xFFFF00, 0xFF0000]/[[0xFFFFFF, 0xFFFF00, 0xFF0000],[0xFFFFFF, 0xFFFF00, 0xFF0000]]
	 */
	function getColors():Array<Dynamic>;
	
	/**
	 * 获取背景透明度
	 * @return [1, .5, 0]/[[1, .5, 0],[1, .5, 0]]
	 */
	function getAlphas():Array<Dynamic>;
	
	/**
	 * 设置边框样式
	 * @param	thick 	粗细度
	 * @param	color 	颜色值
	 * @param	alpha 	透明度
	 * @param	rx		x轴半径
	 * @param	ry		y轴半径
	 */
	function setBorder(thick:Int, color:Int, alpha:Float, rx:Int = 0, ry:Int = 0):Void;
	
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
	 * 获取默认材质
	 * @return Sparrow/Texture(Starling)
	 */
	function getDefaultTexture():Dynamic;
	
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
	
	/**
	 * 设置缩放比例
	 * @param	value
	 */
	function setScale(value:Float):Void;
	
	/**
	 * 获取缩放比列
	 * @return
	 */
	function getScale():Float;
	
	/**
	 * 设置样式名称
	 * @param 	value
	 */
	function setStyleName(value:String):Void;
	/**
	 * 获取事件发送者
	 * @return
	 */
	function getDispatcher():EventDispatcher;
	
	/**
	 * 设置容器状态对应隐藏列表
	 * @param	args
	 */
	function setExclude(args:Array<String>):Void;
	
	/**
	 * 获取容器状态对应隐藏列表
	 * @return
	 */
	function getExclude():Array<String>;
	
	/**
	 * 设置容器状态对应显示列表
	 * @param	args
	 */
	function setInclude(args:Array<String>):Void;
	
	/**
	 * 获取容器状态对应显示列表
	 * @return
	 */
	function getInclude():Array<String>;
}