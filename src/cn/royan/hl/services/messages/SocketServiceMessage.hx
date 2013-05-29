package cn.royan.hl.services.messages;

import cn.royan.hl.bases.PoolMap;
import cn.royan.hl.interfaces.services.IServiceMessageBase;
import cn.royan.hl.utils.SystemUtils;
import cn.royan.hl.consts.PrintConst;

import haxe.io.BytesInput;
import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.Input;

/**
 * ...
 * @author RoYan
 */
class SocketServiceMessage extends Bytes, implements IServiceMessageBase
{
	static inline var ignores:Array<String> = ["b", "length", "data", "type", "len"];

	var type:Int;
	var len:Int;
	var data:Bytes;

	public function new() {
		#if flash
		super(1, new BytesData());
		#elseif neko
		super(1, BytesData.ofString("0"));
		#elseif cpp
		super(1, new Array<haxe.io.Unsigned_char__>() );
		#end
	}

	public function writeMessageType(value:Int):Void
	{
		type = value;
		set(0, type);
	}

	public function writeMessageLen(value:Int):Void
	{
		len = value;
		length = 1 + 2 + len;
		#if neko
		var temp:String = "";
		for ( i in 0...length ) {
			temp += "0";
		}
		b = BytesData.ofString(temp);
		#end

		set(1, len >> 8);
		set(2, len & 0xFF);
	}

	public function writeMessageData(value:BytesData):Void
	{
		data = Bytes.ofData(value);
		writeMessageLen(data.length);
		#if neko
		for ( i in 0...len ) {
			set( 3 + i, data.get(i) );
		}
		#else
		blit(3, data, 0, len);
		#end
	}

	public function writeMessageFromBytes(input:Bytes):Void
	{
		if ( type == 0 )
			type = input.get(0);

		var top:Int = input.get(1);
		len = (top << 8 ) + input.get(2);
		length = 1 + 2 + len;

		data = Bytes.alloc(len);
		data.blit(0, input, 3, len);

		set(0, type);
		set(1, len >> 8);
		set(2, len & 0xFF);
		#if neko
		for ( i in 0...len ) {
			set( 3 + i, data.get(i) );
		}
		#else
		blit(3, data, 0, len);
		#end

		var datainput:BytesInput = new BytesInput(data);
		var unserializer:Unserializer = new Unserializer();
		var fields:Array<String> = getSortedFields();
		for ( field in fields ) {
			if ( !Reflect.isFunction( Reflect.field(this, field) ) && SystemUtils.arrayIndexOf(ignores, field) == -1 ) {
				Reflect.setField(this, field, unserializer.unserialize( datainput ) );
				SystemUtils.print(field+":"+Reflect.field(this, field), PrintConst.SERVICES);
			}
		}
	}

	static public function fromBytes(input:Bytes):SocketServiceMessage 
	{
		var type:Int = input.get(0);
		SystemUtils.print(type, PrintConst.SERVICES);
		var message:SocketServiceMessage = Type.createInstance(MessageManager.getMessageByType(type), []);
			message.writeMessageType(type);
			message.writeMessageFromBytes(input);
		return message;
	}

	public function readMessageType():Int
	{
		if ( type == 0 )
			type = get(0);
		return type;
	}

	public function readMessageLen():Int
	{
		if ( len == 0 ) 
			len = (get(1) << 8) + get(2);
		return len;
	}

	public function readMessageData():BytesData
	{
		if ( data == null )
			data = sub(1, length - 1);
		return data.getData();
	}

	public function serialize():Void
	{
		var serializer:Serializer = new Serializer();
		var fields:Array<String> = getSortedFields();
		for ( field in fields ) {
			if ( !Reflect.isFunction( Reflect.field(this, field) ) && SystemUtils.arrayIndexOf(ignores, field) == -1 ) {
				SystemUtils.print(field + ":" + Reflect.field(this, field), PrintConst.SERVICES);
				serializer.serialize( Reflect.field(this, field) );
			}
		}

		writeMessageData(serializer.getBytes());

	}

	function getSortedFields():Array<String>
	{
		var fields:Array<String> = Type.getInstanceFields(Type.getClass(this));
			fields.sort( function(a:String, b:String):Int
			{
				a = a.toLowerCase();
				b = b.toLowerCase();
				if (a < b) return -1;
				if (a > b) return 1;
				return 0;
			} );
		return fields;
	}

	public function dispose():Void
	{
		type = 0;
		data = null;
	}
}