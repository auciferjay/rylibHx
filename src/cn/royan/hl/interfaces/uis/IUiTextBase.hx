package cn.royan.hl.interfaces.uis;

import cn.royan.hl.geom.Range;

import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

/**
 * ...
 * 基础文本显示接口，所有文本显示类继承此接口，继承自基础显示接口
 * <p>IUiTextBase->IUiBase</p>
 * @author RoYan
 */
interface IUiTextBase implements IUiBase 
{
	/**
	 * 设置文本间隔
	 * @param	r	字距
	 * @param	c	行距
	 */
	function setTextSpace(r:Int, c:Int):Void;
	
	/**
	 * 设置文本类型 
	 * @param	type	TEXT_TYPE_INPUT / TEXT_TYPE_PASSWORD
	 */
	function setType(type:Int):Void;
	
	/**
	 * 设置文本内容
	 * @param	value
	 */
	function setText(value:String):Void;
	
	/**
	 * 追加文本内容
	 * @param	value
	 */
	function appendText(value:String):Void;
	
	/**
	 * 获取文本内容
	 * @return
	 */
	function getText():String;
	
	/**
	 * 设置文本HTML内容
	 * @param	value
	 */
	function setHTMLText(value:String):Void;
	
	/**
	 * 追加文本HTML内容
	 * @param	value
	 */
	function appendHTMLText(value:String):Void;
	
	/**
	 * 获取文本HTML内容
	 * @return
	 */
	function getHTMLText():String;
	
	/**
	 * 设置文本对齐方式
	 * @param	value	TEXT_ALIGN_LEFT / TEXT_ALIGN_CENTER / TEXT_ALIGN_RIGHT
	 */
	function setTextAlign(value:Int):Void;
	
	/**
	 * 设置文本整体颜色
	 * @param	value
	 */
	function setTextColor(value:Int):Void;
	
	/**
	 * 设置文本整体大小
	 * @param	value
	 */
	function setTextSize(value:Int):Void;
	
	/**
	 * 设置绑定字体
	 * @param	value
	 */
	function setEmbedFont(value:Bool):Void;
	
	/**
	 * 设置文本样式
	 * @param	value
	 * @param	begin
	 * @param	end
	 */
	function setFormat(value:TextFormat, begin:Int = -1, end:Int = -1):Void;
	
	/**
	 * 获取文本样式
	 * @param	begin
	 * @param	end
	 * @return
	 */
	function getFormat(begin:Int = -1, end:Int = -1):TextFormat;
	
	/**
	 * 设置默认样式
	 * @param	value
	 */
	function setDefaultFormat(value:TextFormat):Void;
	
	/**
	 * 获取默认样式
	 * @return
	 */
	function getDefaultFormat():TextFormat;
	
	/**
	 * 设置分行显示
	 * @param	value
	 */
	function setMultiLine(value:Bool):Void;
}