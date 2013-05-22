package cn.royan.hl.interfaces.services;

import cn.royan.hl.interfaces.IDisposeBase;
import haxe.io.Bytes;
import haxe.io.BytesData;

interface IServiceMessageBase implements IDisposeBase
{
	function writeMessageType(value:Int):Void;
	function writeMessageLen(value:Int):Void;
	function writeMessageData(value:BytesData):Void;
	function writeMessageFromBytes(input:Bytes):Void;
	function readMessageType():Int;
	function readMessageLen():Int;
	function readMessageData():BytesData;
	function serialize():Void;
}