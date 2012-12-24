package cn.royan.hl.interfaces.services;

import cn.royan.hl.interfaces.IDisposeBase;

import flash.utils.IDataInput;

interface IServiceMessageBase extends 
{
	function writeMessageType(type:Int):Void;
	function writeMessageValue(value:Dynamic):Void;
	function writeMessageFromBytes(input:IDataInput):Void;
	function readMessageType():Int;
	function readMessageValue():Dynamic;
	function serialize():Void;
}