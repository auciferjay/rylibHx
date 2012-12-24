package cn.royan.hl.interfaces.services;

import cn.royan.hl.interfaces.IDisposeBase;

import flash.events.IEventDispatcher;

interface IServiceBase extends IEventDispatcher, IDisposeBase
{
	function sendRequest(url:String='', extra:Dynamic=null):Void;
	function setCallbacks(value:Dynamic):Void;
	function connect():Void;
	function close():Void;
	function getData():Dynamic;
	function getIsServicing():Bool;
}