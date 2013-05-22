package cn.royan.hl.services;

import cn.royan.hl.bases.PoolMap;
import cn.royan.hl.bases.DispatcherBase;
import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.interfaces.services.IServiceBase;
import cn.royan.hl.interfaces.services.IServiceMessageBase;
import cn.royan.hl.utils.SystemUtils;
import flash.utils.ByteArray;
import haxe.io.Bytes;
import haxe.io.BytesInput;

#if (!flash && !js)
import sys.net.Socket;
import sys.net.Host;
#elseif flash
import flash.net.Socket;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
#elseif js
import js.XMLSocket;
#end
import haxe.io.Bytes;
#if neko
import neko.vm.Thread;
#elseif cpp
import cpp.vm.Thread;
#end

private typedef ClientInfos = {
	var buf			:Bytes;
	var bufpos		:Int;
	var socket		:Socket;
}

class SoktService extends DispatcherBase, implements IServiceBase
{
	var callbacks:Dynamic;

	var host:String;
	var port:Int;

	var isServicing:Bool;

	#if !js
	var socket:Socket;
	#else
	var socket:XMLSocket;
	#end

	#if ( cpp || neko )
	var worker:Thread;
	var thread:Thread;
	var clientInfos:ClientInfos;
	var bufferSize:Int;
	var headerSize:Int;
	#end

	var packet:IServiceMessageBase;
	var packetType:Class<IServiceMessageBase>;

	public function new(messageType:Class<IServiceMessageBase>, host:String="", port:Int=0)
	{
		super();

		packetType = messageType;

		this.host = host;
		this.port = port;

		#if ( cpp || neko )
		bufferSize = (1 << 16);
		headerSize = 1;
		#end
	}

	public function sendRequest(url:String='', extra:Dynamic=null):Void
	{
		SystemUtils.print(url+":"+extra, PrintConst.SERVICES);
		if( getIsServicing() ){
			#if flash
			socket.writeBytes( cast(extra) );
			socket.flush();
			#else
			socket.output.writeBytes( cast(extra) );
			#end
		}else{
			if( url == "" || extra == null ) throw "host and port must be filled in";
			host = url;
			port = Std.int(extra);
		}
	}

	public function setCallbacks(value:Dynamic):Void
	{
		callbacks = value;
	}

	public function connect():Void
	{
		#if !js
			socket = new Socket();
			#if !flash
				socket.connect(new Host(host), port);
				clientInfos = {
					buf:Bytes.alloc( bufferSize ),
					bufpos:0,
					socket:socket
				}

				worker = Thread.create( runWorker );
				thread = Thread.create( runThread );

				isServicing = true;

				SystemUtils.print("[Class SoktService]:onConnect", PrintConst.SERVICES);
				if( callbacks != null && callbacks.create != null ) callbacks.create();
				else dispatchEvent(new DatasEvent(DatasEvent.DATA_CREATE));
			#else
				socket.addEventListener(Event.CONNECT, onConnect);
				socket.addEventListener(Event.CLOSE, onClose);
				socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				socket.addEventListener(ProgressEvent.SOCKET_DATA, onProgress);
				socket.connect(host, port);
			#end
		#else
			socket = new XMLSocket();
			socket.onClose 		= jsOnClose;
			socket.onConnect 	= jsOnConnect;
			socket.onData 		= jsOnData;
			socket.connect(host, port);
		#end
	}

	public function close():Void
	{
		socket.close();
	}

	public function getData():Dynamic
	{
		return packet;
	}

	public function getIsServicing():Bool
	{
		return isServicing;
	}

	public function dispose():Void
	{
		if( getIsServicing() ) socket.close();

		#if flash
		socket.removeEventListener(Event.CONNECT, onConnect);
		socket.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
		socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		socket.removeEventListener(ProgressEvent.SOCKET_DATA, onProgress);
		socket.removeEventListener(Event.CLOSE, onClose);
		#end

		socket = null;
		callbacks = null;
		removeAllEventListeners();
	}

	#if flash
	function onConnect(evt:Event):Void
	{
		SystemUtils.print("[Class SoktService]:onConnect", PrintConst.SERVICES);
		if( callbacks != null && callbacks.create != null ) callbacks.create();
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_CREATE));

		isServicing = true;
	}

	function onClose(evt:Event):Void
	{
		SystemUtils.print("[Class SoktService]:onClose", PrintConst.SERVICES);
		if( callbacks != null && callbacks.destory != null ) callbacks.destory();
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_DESTROY));

		isServicing = false;
	}

	function onIOError(evt:IOErrorEvent):Void
	{
		SystemUtils.print("[Class SoktService]:onIOError:"+evt, PrintConst.SERVICES);
		if( callbacks != null && callbacks.error != null ) callbacks.error(evt.type);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_ERROR, evt.type));

		isServicing = false;
	}

	function onSecurityError(evt:SecurityErrorEvent):Void
	{
		SystemUtils.print("[Class SoktService]:onSecurityError:"+evt, PrintConst.SERVICES);
		if( callbacks != null && callbacks.error != null ) callbacks.error(evt.type);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_ERROR, evt.type));

		isServicing = false;
	}

	function onProgress(evt:ProgressEvent):Void
	{
		SystemUtils.print("[Class SoktService]:onProgress:" + socket.bytesAvailable, PrintConst.SERVICES);
		var bytes:ByteArray = new ByteArray();
		socket.writeBytes(bytes);
		while( bytes.bytesAvailable > 0 ){
			packet = SystemUtils.getInstanceByClassName(Std.string(packetType));
			packet.writeMessageFromBytes(new BytesInput(Bytes.ofData(bytes)));

			if( callbacks != null && callbacks.doing != null ) callbacks.doing( packet );
			else dispatchEvent(new DatasEvent(DatasEvent.DATA_DOING, packet));

			packet.dispose();
			PoolMap.disposeInstance(packet);
		}
	}
	#elseif js
	function jsOnData(data:String):Void
	{
		SystemUtils.print("[Class SoktService]:onProgress:"+data.length, PrintConst.SERVICES);
		while( data.length > 0 ){
			packet = SystemUtils.getInstanceByClassName(Std.string(packetType));
			packet.writeMessageFromBytes(socket);

			if( callbacks != null && callbacks.doing != null ) callbacks.doing( packet );
			else dispatchEvent(new DatasEvent(DatasEvent.DATA_DOING, packet));

			packet.dispose();
			PoolMap.disposeInstance(packet);
		}
	}

	function jsOnClose():Void
	{
		SystemUtils.print("[Class SoktService]:onClose", PrintConst.SERVICES);
		if( callbacks != null && callbacks.destory != null ) callbacks.destory();
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_DESTROY));

		isServicing = false;
	}

	function jsOnConnect(b:Bool):Void
	{
		if ( b ) {
			SystemUtils.print("[Class SoktService]:onConnect", PrintConst.SERVICES);
			if( callbacks != null && callbacks.create != null ) callbacks.create();
			else dispatchEvent(new DatasEvent(DatasEvent.DATA_CREATE));

			isServicing = true;
		}else {
			SystemUtils.print("[Class SoktService]:onIOError", PrintConst.SERVICES);
			if( callbacks != null && callbacks.error != null ) callbacks.error("");
			else dispatchEvent(new DatasEvent(DatasEvent.DATA_ERROR));

			isServicing = false;
		}
	}
	#else
	function runThread():Void
	{
		while ( true ) {
			try {
				loopThread();
			}catch ( e:Dynamic ) {
			}
		}
	}

	function loopThread():Void
	{
		var available:Int = clientInfos.buf.length - clientInfos.bufpos;
		if ( available == 0 ) {
			var newsize:Int = clientInfos.buf.length * 2;
			if ( newsize > bufferSize ) {
				newsize = bufferSize;
				if ( clientInfos.buf.length == bufferSize )
					throw "Max buffer size reached";
			}
			var newbuf:Bytes = Bytes.alloc( newsize );
				newbuf.blit( 0, clientInfos.buf, 0, clientInfos.bufpos );
			clientInfos.buf = newbuf;
			available = newsize - clientInfos.bufpos;
		}
		var bytes:Int = cast(clientInfos.socket).input.readBytes( clientInfos.buf, clientInfos.bufpos, available );
		var pos:Int = 0;
		var len:Int = clientInfos.bufpos + bytes;
		while ( len >= headerSize ) {
			var m: { msg:String, bytes:Int } = readClientMessage( clientInfos.socket, clientInfos.buf, pos, len );
			if ( m == null ) break;
			pos += m.bytes;
			len -= m.bytes;
			work( callback( clientMessage, clientInfos.socket, m.msg ) );
		}
		if ( pos > 0 )
			clientInfos.buf.blit( 0, clientInfos.buf, pos, len );
		clientInfos.bufpos = len;
	}

	function work( fun: Void -> Void ):Void
	{
		worker.sendMessage( fun );
	}

	function runWorker() {
		while( true ) {
			var f = Thread.readMessage(true);
			try {
				f();
			} catch( e : Dynamic ) {
				onErrorHandler(e);
			}
			try {
				afterEvent();
			} catch( e : Dynamic ) {
				onErrorHandler(e);
			}
		}
	}

	function afterEvent():Void
	{

	}

	function clientMessage( c:Socket, msg:String ):Void
	{

	}

	function readClientMessage( c:Socket, buf:Bytes, pos:Int, len:Int ): {msg:String, bytes:Int }
	{
		SystemUtils.print("Listenee read:"+buf.readString(pos,len), PrintConst.SERVICES);
		var cpos:Int = pos;
		var complete:Bool = false;
		var isStart:Bool = buf.get(cpos) == 123;//
		var isMeet:Bool = false;//
		while (cpos < (pos + len) && !complete && isStart)
		{
			complete = isMeet && (buf.get(cpos) == 46);
			isMeet = buf.get(cpos) == 125;
			cpos++;
		}
		// no full message
		if ( !complete ) return null;

		var msg:String = buf.readString( pos, cpos - pos );

		if( callbacks != null && callbacks.doing != null ) callbacks.doing( msg );
			else dispatchEvent(new DatasEvent(DatasEvent.DATA_DOING, msg));
		if ( cpos < (pos + len) )
		{
			readClientMessage( c, buf, cpos, len + pos - cpos );
		}
		// got a full message, return it
		return {
			msg : msg,
			bytes : len,
		};
	}

	function onErrorHandler( e:Dynamic ):Void
	{
		SystemUtils.print(e, PrintConst.SERVICES);
		if( callbacks != null && callbacks.error != null ) callbacks.error(e);
			else dispatchEvent(new DatasEvent(DatasEvent.DATA_ERROR, e));
	}
	#end
}