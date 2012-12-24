package cn.royan.hl.services.bases;

import cn.royan.hl.interfaces.services.IServiceMessageBase;

import haxe.io.Input;
import haxe.io.BytesData;
import haxe.io.Unsigned_char__;
import cs.UInt8;
import java.Int8;
/**
 * Defined in flash8, js
 * = Array<Int>
 * Defined in flash
 * = ByteArray
 * Defined in php
 * = NativeString
 * Defined in cs
 * = NativeArray<UInt8>
 * Defined in neko
 * = NativeString
 * Defined in cpp
 * = Array<Unsigned_char__>
 * Defined in java
 * = NativeArray<Int8>
 */

class MQTTServiceMessage implements IServiceMessageBase
{
	static public inline var CONNECT:UInt 		= 0x10;
	static public inline var CONNACK:UInt 		= 0x20;
	static public inline var PUBLISH:UInt 		= 0x30;
	static public inline var PUBACK:UInt 		= 0x40;
	static public inline var PUBREC:UInt 		= 0x50;
	static public inline var PUBREL:UInt 		= 0x60;
	static public inline var PUBCOMP:UInt 		= 0x70;
	static public inline var SUBSCRIBE:UInt 	= 0x80;
	static public inline var SUBACK:UInt 		= 0x90;
	static public inline var UNSUBSCRIBE:UInt 	= 0xA0;
	static public inline var UNSUBACK:UInt 		= 0xB0;
	static public inline var PINGREQ:UInt 		= 0xC0;
	static public inline var PINGRESP:UInt 		= 0xD0;
	static public inline var DISCONNECT:UInt 	= 0xE0;
	
	var message:BytesData;
	var fixHead:BytesData;
	var varHead:BytesData;
	var payLoad:BytesData;
	
	var index:Int;
	var type:Int;
	var dup:Int;
	var qos:Int;
	var retain:Int;
	var remainingLength:Int;
	
	public function new() 
	{
		super();
	}
	
	public function writeType(value:UInt):void
	{
		type = value;
		writeMessageType(type + (dup << 3) + (qos << 1) + retain);
	}
	
	public function writeDUP(value:UInt):void
	{
		dup = value;
		writeMessageType(type + (dup << 3) + (qos << 1) + retain);
	}
	
	public function writeQoS(value:UInt):void
	{
		qos = value;
		writeMessageType(type + (dup << 3) + (qos << 1) + retain);
	}
	
	public function writeRETAIN(value:UInt):void
	{
		retain = value;
		writeMessageType(type + (dup << 3) + (qos << 1) + retain);
	}
	
	public function writeRemainingLength(value:UInt):void
	{
		remainingLength = value;
		writeMessageType(type + (dup << 3) + (qos << 1) + retain);
	}
	
	public function readType():UInt
	{
		index = 0;
		#if flash
			message.position = index;
			index++;
			return message.readUnsignedByte() & 0xF0;
		#else if flash8
			return message[index] & 0xF0;
		#else if neko
			return message.char(index) & 0xF0;
		#else if php
			return message.char(index) & 0xF0;
		#else if cpp
			return message[index] & 0xF0;
		#else if java
			return message[index] & 0xF0;
		#else if cs
			return message[index] & 0xF0;
		#end
	}
	
	public function readDUP():UInt
	{
		index = 0;
		#if flash
			message.position = index;
			index++;
			return (message.readUnsignedByte() >> 3) & 0x01;
		#else if flash8
			return (message[index] >> 3) & 0x01;
		#else if neko
			return (message.char(index) >> 3) & 0x01;
		#else if php
			return (message.char(index) >> 3) & 0x01;
		#else if cpp
			return (message[index] >> 3) & 0x01;
		#else if java
			return (message[index] >> 3) & 0x01;
		#else if cs
			return (message[index] >> 3) & 0x01;
		#end
	}
	
	public function readQoS():UInt
	{
		index = 0;
		#if flash
			message.position = index;
			index++;
			return (message.readUnsignedByte() >> 1) & 0x03;
		#else if flash8
			return (message[index] >> 1) & 0x03;
		#else if neko
			return (message.char(index) >> 1) & 0x03;
		#else if php
			return (message.char(index) >> 1) & 0x03;
		#else if cpp
			return (message[index] >> 1) & 0x03;
		#else if java
			return (message[index] >> 1) & 0x03;
		#else if cs
			return (message[index] >> 1) & 0x03;
		#end
	}
	
	public function readRETAIN():UInt
	{
		index = 0;
		#if flash
			message.position = index;
			index++;
			return message.readUnsignedByte() & 0x01;
		#else if flash8
			return message[index] & 0x01;
		#else if neko
			return message.char(index) & 0x01;
		#else if php
			return message.char(index) & 0x01;
		#else if cpp
			return message[index] & 0x01;
		#else if java
			return message[index] & 0x01;
		#else if cs
			return message[index] & 0x01;
		#end
	}
	
	public function readRemainingLength():UInt
	{
		index = 1;
		#if flash
			message.position = index;
			index++;
			return message.readUnsignedByte();
		#else if flash8
			return message[index++];
		#else if neko
			return message.char(index++);
		#else if php
			return message.char(index++);
		#else if cpp
			return message[index++];
		#else if java
			return message[index++];
		#else if cs
			return message[index++];
		#end
	}
	
	public function writeMessageType(type:UInt):Void
	{
		if( fixHead == null )
			fixHead = new BytesData();
		
		index = 0;
		#if flash
			message.position = index;
			message.writeByte(value);
			message.writeByte(remainingLength);
			message.readBytes(fixHead);
			index += 2;
		#else if flash8
			message[index++] = value;
			message[index++] = remainingLength;
		#else if neko
			message.charAt(index++) = value;
			message.charAt(index++) = remainingLength;
		#else if php
			message.charAt(index++) = value;
			message.charAt(index++) = remainingLength;
		#else if cpp
			message[index++] = value;
			message[index++] = remainingLength;
		#else if java
			message[index++] = value;
			message[index++] = remainingLength;
		#else if cs
			message[index++] = value;
			message[index++] = remainingLength;
		#end
		
		type = value & 0xF0;
		dup = (value >> 3) & 0x01;
		qos = (value >> 1) & 0x03;
		retain = value & 0x01;
	}
	
	public function writeMessageValue(value:Dynamic):Void
	{
		index = 2;
		#if flash
			message.position = index;
			message.writeByte(value);
		#else if flash8
			var prev:Array<Int> = message.slice(0, index);
			message = prev.concat(value);
		#else if neko
			message.length = index;
			message += value;
		#else if php
			message.length = index;
			message += value;
		#else if cpp
			var prev:Array<Unsigned_char__> = message.slice(0, index);
			message = prev.concat(value);
		#else if java
			var prev:Array<Int8> = message.slice(0, index);
			message = prev.concat(value);
		#else if cs
			var prev:Array<UInt8> = message.slice(0, index);
			message = prev.concat(value);
		#end
		index += value.length;
		this.serialize();
		
		writeMessageType( type + (dup << 3) + (qos << 1) + retain );
	}
	
	public function writeMessageFromBytes(input:Input):Void
	{
		index = 0;
		#if flash
			message.position = index;
			message.writeType(input.readInt8());
		#else if flash8
			message[index++] = input.readInt8();
		#else if neko
			message.char(index++) = input.readInt8();
		#else if php
			message.char(index++) = input.readInt8();
		#else if cpp
			message[index++] = input.readInt8();
		#else if java
			message[index++] = input.readInt8();
		#else if cs
			message[index++] = input.readInt8();
		#end
		
		remainingLength = input.readUnsignedByte();
		
		input.readBytes(this, 2, remainingLength);
		this.serialize();
		
		writeMessageType( type + (dup << 3) + (qos << 1) + retain );
	}
	
	public function readMessageType():Int
	{
		return this.readType();
	}
	
	public function readMessageValue():Dynamic
	{
		return varHead;
	}
	
	public function readPayLoad():BytesData
	{
		return payLoad;
	}
	
	public function serialize():Void
	{
		type 	= this.readType();
		dup 	= this.readDUP();
		qos 	= this.readQoS();
		retain	= this.readRETAIN();
		
		fixHead = new BytesData();
		varHead = new BytesData();
		payLoad = new BytesData();
		
		index = 0;
		#if flash
			message.position = index;
			message.readBytes(fixHead, 0, 2);
		#else if flash8
			fixHead = message.slice(0, 2);
		#else if neko
			fixHead = message.substr(0, 2);
		#else if php
			fixHead = message.substr(0, 2);
		#else if cpp
			fixHead = message.slice(0, 2);
		#else if java
			fixHead = message.slice(0, 2);
		#else if cs
			fixHead = message.slice(0, 2);
		#end
		
		index = 2;
		switch( type ){
			case CONNECT://Remaining Length is the length of the variable header (12 bytes) and the length of the Payload
				#if flash
					message.position = index;
					message.readBytes(varHead, 0, 12);
					message.readBytes(payLoad);
				#else if flash8
					varHead = message.slice(index, 12+index);
				#else if neko
					varHead = message.substr(index, 12);
				#else if php
					varHead = message.substr(index, 12);
				#else if cpp
					varHead = message.slice(index, 12+index);
				#else if java
					varHead = message.slice(index, 12+index);
				#else if cs
					varHead = message.slice(index, 12+index);
				#end
				
				remainingLength = varHead.length + payLoad.length;
			case PUBLISH://Remaining Length is the length of the variable header plus the length of the payload
				var length:Int;//the length of variable header
				#if flash
					message.position = index;
					length = (message.readUnsignedBytes << 8) + message.readUnsignedBytes();
					message.readBytes(varHead, 0, length + 4);
					message.readBytes(payLoad);
				#else if flash8
					length = (message[index++] << 8) + message[index++]);
					varHead = message.slice(index, length + 4 + index);
					index += length + 4;
					payLoad = message.slice(index);
				#else if neko
					length = (message.charAt(index++) << 8) + message.charAt(index++));
					varHead = message.substr(index, length + 4 + index);
					index += length + 4;
					payLoad = message.substr(index);
				#else if php
					length = (message.charAt(index++) << 8) + message.charAt(index++));
					varHead = message.substr(index, length + 4 + index);
					index += length + 4;
					payLoad = message.substr(index);
				#else if cpp
					length = (message[index++] << 8) + message[index++]);
					varHead = message.slice(index, length + 4 + index);
					index += length + 4;
					payLoad = message.slice(index);
				#else if java
					length = (message[index++] << 8) + message[index++]);
					varHead = message.slice(index, length + 4 + index);
					index += length + 4;
					payLoad = message.slice(index);
				#else if cs
					length = (message[index++] << 8) + message[index++]);
					varHead = message.slice(index, length + 4 + index);
					index += length + 4;
					payLoad = message.slice(index);
				#end
				
				remainingLength = varHead.length + payLoad.length;
			case SUBSCRIBE://Remaining Length is the length of the variable header plus the length of the payload
			case SUBACK://Remaining Length is the length of the variable header plus the length of the payload
			case UNSUBSCRIBE://Remaining Length is the length of the variable header plus the length of the payload
				#if flash
					message.position = index;
					message.readBytes(varHead, 0, 2);
					message.readBytes(payLoad);
				#else if flash8
					varHead = message.slice(index, 2+index);
				#else if neko
					varHead = message.substr(index, 2);
				#else if php
					varHead = message.substr(index, 2);
				#else if cpp
					varHead = message.slice(index, 2+index);
				#else if java
					varHead = message.slice(index, 2+index);
				#else if cs
					varHead = message.slice(index, 2+index);
				#end
				
				remainingLength = varHead.length + payLoad.length;
			default://Remaining Length is the length of the variable header (2 bytes)
				#if flash
					message.position = index;
					message.readBytes(varHead, 0);
				#else if flash8
					varHead = message.slice(index);
				#else if neko
					varHead = message.substr(index);
				#else if php
					varHead = message.substr(index);
				#else if cpp
					varHead = message.slice(index);
				#else if java
					varHead = message.slice(index);
				#else if cs
					varHead = message.slice(index);
				#end
				
				remainingLength = varHead.length;
		}
	}
}