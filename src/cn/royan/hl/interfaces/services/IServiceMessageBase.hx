package cn.royan.hl.interfaces.services;

import cn.royan.hl.interfaces.IDisposeBase;
import haxe.io.Input;
import haxe.io.BytesData;

interface IServiceMessageBase implements IDisposeBase
{
	function writeMessageType(value:Int):Void;
	function writeMessageLen(value:Int):Void;
	function writeMessageData(value:BytesData):Void;
	function writeMessageFromInput(input:Input):Void;
	function readMessageType():Int;
	function readMessageLen():Int;
	function readMessageData():BytesData;
	function serialize():Void;
}