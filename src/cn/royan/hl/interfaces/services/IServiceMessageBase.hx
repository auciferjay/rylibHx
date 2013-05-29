package cn.royan.hl.interfaces.services;

import cn.royan.hl.interfaces.IDisposeBase;

import haxe.io.Bytes;
import haxe.io.BytesData;

/**
 * ...
 * 交互数据接口，继承自可销毁接口
 * <p>IServiceMessageBase->IDisposeBase</p>
 * @author RoYan
 */
interface IServiceMessageBase implements IDisposeBase
{
	/**
	 * 设置数据类型
	 * @param	value
	 */
	function writeMessageType(value:Int):Void;
	
	/**
	 * 获取数据类型
	 * @return
	 */
	function readMessageType():Int;
	
	/**
	 * 设置数据长度
	 * @param	value
	 */
	function writeMessageLen(value:Int):Void;
	
	/**
	 * 获取数据长度
	 * @return
	 */
	function readMessageLen():Int;
	
	/**
	 * 设置数据值
	 * @param	value
	 */
	function writeMessageData(value:BytesData):Void;
	
	/**
	 * 获取数据值
	 * @return
	 */
	function readMessageData():BytesData;
	
	/**
	 * 从输入值解析
	 * @param	input
	 */
	function writeMessageFromBytes(input:Bytes):Void;
	
	/**
	 * 序列化
	 */
	function serialize():Void;
}