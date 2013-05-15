package cn.royan.hl.interfaces.services;

import cn.royan.hl.interfaces.IDisposeBase;

import haxe.io.Input;

interface IServiceMessageBase implements IDisposeBase
{
	function writeMessageType(type:Int):Void;
	function writeMessageValue(value:Dynamic):Void;
	function writeMessageFromBytes(input:Input):Void;
	function readMessageType():Int;
	function readMessageValue():Dynamic;
	function serialize():Void;
}