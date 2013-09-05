package cn.royan.hl.interfaces.uis;

import cn.royan.hl.geom.Range;
import cn.royan.hl.uis.graphs.UiGStage;
import cn.royan.hl.uis.sparrow.Sparrow;
import cn.royan.hl.uis.style.Style;
import cn.royan.hl.interfaces.IDisposeBase;

import flash.geom.Rectangle;

/**
 * ...
 * @author RoYan
 */
interface IUiGraphBase implements IDisposeBase
{
	/**
	 * 设置舞台
	 */
	function setStage(value:UiGStage):Void;
	
	/**
	 * 设置父容器
	 * @param	value
	 */
	function setParent(value:IUiGraphBase):Void;
	
	/**
	 * 更新显示
	 */
	function updateDisplayList(item:IUiGraphBase = null):Void;
	
	/**
	 * 是否更新
	 */
	function isUpdate():Bool;
	
	/**
	 * 画布刷新
	 */
	function draw():Void;

	/**
	 * 设置尺寸
	 * @param	cWidth
	 * @param	cHeight
	 */
	function setSize(cWidth:Int, cHeight:Int):Void;
	
	/**
	 * 设置位置
	 * @param	cX
	 * @param	cY
	 */
	function setPosition(cX:Int, cY:Int):Void;
	
	/**
	 * 获取感应范围
	 * @return
	 */
	function getBound():Rectangle;
	
	/**
	 * 获取当前材质
	 * @return
	 */
	function getTexture():Sparrow;
	
	/**
	 * 设置X缩放比例
	 * @param	value
	 */
	function setScaleX(value:Float):Void;
	
	/**
	 * 获取X缩放比列
	 * @return
	 */
	function getScaleX():Float;
	
	/**
	 * 设置X缩放比例
	 * @param	value
	 */
	function setScaleY(value:Float):Void;
	
	/**
	 * 获取X缩放比列
	 * @return
	 */
	function getScaleY():Float;
	
	/**
	 * 设置角度
	 * @param	value
	 */
	function setRotation(value:Float):Void;
	
	/**
	 * 获取角度
	 * @return
	 */
	function getRotation():Float;
	
	/**
	 * 设置透明度
	 * @param	value
	 */
	function setAlpha(value:Float):Void;
	
	/**
	 * 获取透明度
	 * @return
	 */
	function getAlpha():Float;
	
	/**
	 * 设置显示
	 * @param	value
	 */
	function setVisible(value:Bool):Void;
	
	/**
	 * 过去显示
	 * @return
	 */
	function getVisible():Bool;
	
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