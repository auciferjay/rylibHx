package cn.royan.hl.interfaces.services;

import cn.royan.hl.interfaces.IDisposeBase;
#if flash
import flash.utils.IDataInput;
#else
import haxe.io.Input;
#end

interface IServiceMessageBase implements IDisposeBase
{
	function writeMessageType(type:Int):Void;
	function writeMessageValue(value:Dynamic):Void;
	#if flash
	function writeMessageFromBytes(input:IDataInput):Void;
	#else
	function writeMessageFromBytes(input:Input):Void;
	#end
	function readMessageType():Int;
	function readMessageValue():Dynamic;
	function serialize():Void;
}