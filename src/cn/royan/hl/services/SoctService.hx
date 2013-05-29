package cn.royan.hl.services;

import cn.royan.hl.bases.DispatcherBase;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.interfaces.services.IServiceBase;
import cn.royan.hl.utils.SystemUtils;

#if cpp
import cpp.vm.Thread;
import cpp.vm.Lock;
#elseif neko
import neko.vm.Thread;
import neko.vm.Lock;
#end
import sys.net.Host;
import sys.net.Socket;
import haxe.io.Bytes;
import haxe.io.Output;
import haxe.io.Eof;
import haxe.io.Error;
import haxe.Stack;

/**
 * ...
 * Socket服务
 * @author RoYan
 */
private typedef ThreadInfos = {
	var id:Int;
	var thread:Thread;
	var sockets:Array<Socket>;
}

private typedef ClientInfos = {
	var socket:Socket;
	var unid:Int;
	var thread:ThreadInfos;
	var buffer:Bytes;
	var bufferpos:Int;
}

class SoctService extends DispatcherBase, implements IServiceBase
{
	static var __id:Int = 0;

	var callbacks:Dynamic;

	var host:String;
	var port:Int;

	var isServicing:Bool;

	var threads:Array<ThreadInfos>;
	var sock:Socket;
	var worker:Thread;
	var timer:Thread;
	var listener:Thread;
	var listen:Int;
	var nthreads:Int;
	var connectLag:Float;
	var errorOutput:Output;
	var initialBufferSize:Int;
	var maxBufferSize:Int;
	var messageHeaderSize:Int;
	var updateTime:Float;
	var maxSockPerThread:Int;

	public function new(host:String="", port:Int=0) 
	{
		super();

		//packetType = messageType;

		this.host = host;
		this.port = port;

		threads = new Array();
		nthreads = if( Sys.systemName() == "Windows" ) 150 else 10;
		messageHeaderSize = 1;
		listen = 10;
		connectLag = 0.5;
		errorOutput = Sys.stderr();
		initialBufferSize = (1 << 10);
		maxBufferSize = (1 << 16);
		maxSockPerThread = 64;
		updateTime = 1;
	}

	public function sendRequest(url:String='', extra:Dynamic=null):Void
	{
		SystemUtils.print(url, PrintConst.SERVICES);
		if( getIsServicing() ){
			//socket.output.write( cast(extra) );
			for( thread in threads ) {
				for ( sock in thread.sockets ) {
					if ( Std.string(sock.custom.unid) == url ) {
						sendData(sock, cast(extra) );
						return ;
					}
				}
			}
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
		try{
			sock = new Socket();
			sock.bind(new Host(host),port);
			sock.listen(listen);

			isServicing = true;

			listener = Thread.create(runListener);
			worker = Thread.create(runWorker);
			timer = Thread.create(runTimer);

			for( i in 0...nthreads ) {
				var t:ThreadInfos = {
					id:i,
					thread:null,
					sockets : new Array()
				};
				threads.push(t);
				t.thread = Thread.create(callback(runThread,t));
			}

			if( callbacks != null && callbacks.done != null ) callbacks.done();
			else dispatchEvent(new DatasEvent(DatasEvent.DATA_DONE));
		}catch(e:Dynamic){
			logError(e);
		}
	}

	public function close():Void
	{
		isServicing = false;

		sock.close();

		if( callbacks != null && callbacks.destory != null ) callbacks.destory(null);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_DESTROY));
	}

	public function getData():Dynamic 
	{
		return null;
	}

	public function getIsServicing():Bool
	{
		return isServicing;
	}

	public function dispose():Void
	{
		if ( getIsServicing() ) sock.close();

		sock = null;
		callbacks = null;
		removeAllEventListeners();
	}

	function runListener():Void
	{
		while( getIsServicing() ) {
			try {
				addSocket(sock.accept());
			} catch( e : Dynamic ) {
				logError(e);
			}
		}
	}

	function runThread(t:ThreadInfos):Void
	{
		while( getIsServicing() ) {
			try {
				loopThread(t);
			} catch( e : Dynamic ) {
				logError(e);
			}
		}
	}

	function loopThread(t:ThreadInfos):Void
	{
		if( t.sockets.length > 0 )
			for( s in Socket.select(t.sockets,null,null,connectLag).read ) {
				var infos:ClientInfos = s.custom;
				try {
					readClientData(infos);
				} catch( e : Dynamic ) {
					t.sockets.remove(s);
					if( !Std.is(e,Eof) && !Std.is(e,Error) )
						logError(e);
					work(callback(doClientDisconnected,s));
				}
			}
		while( getIsServicing() ) {
			var m : { s : Socket, cnx : Bool } = Thread.readMessage(t.sockets.length == 0);
			if( m == null )
				break;
			if( m.cnx )
				t.sockets.push(m.s);
			else if( t.sockets.remove(m.s) ) {
				var infos : ClientInfos = m.s.custom;
				work(callback(doClientDisconnected,m.s));
			}
		}
	}

	function runWorker():Void
	{
		while( getIsServicing() ) {
			var f = Thread.readMessage(true);
			try {
				f();
			} catch( e : Dynamic ) {
				logError(e);
			}
			try {
				afterEvent();
			} catch( e : Dynamic ) {
				logError(e);
			}
		}
	}

	function runTimer():Void
	{
		var l = new Lock();
		while( getIsServicing() ) {
			l.wait(updateTime);
			work(update);
		}
	}

	function work(f:Void->Void):Void
	{
		worker.sendMessage(f);
	}

	function readClientData(c:ClientInfos):Void
	{
		var available = c.buffer.length - c.bufferpos;
		if( available == 0 ) {
			var newsize = c.buffer.length * 2;
			if( newsize > maxBufferSize ) {
				newsize = maxBufferSize;
				if( c.buffer.length == maxBufferSize )
					throw "Max buffer size reached";
			}
			var newbuf = Bytes.alloc(newsize);
			newbuf.blit(0,c.buffer,0,c.bufferpos);
			c.buffer = newbuf;
			available = newsize - c.bufferpos;
		}
		var bytes = c.socket.input.readBytes(c.buffer,c.bufferpos,available);
		var pos = 0;
		var len = c.bufferpos + bytes;
		while( len >= messageHeaderSize ) {
			var m = readClientMessage(c.buffer, pos, len, c.socket);
			if( m == null )
				break;
			pos += m.bytes;
			len -= m.bytes;
			work(callback(clientMessage, m.msg));
		}
		if( pos > 0 )
			c.buffer.blit(0, c.buffer, pos, len);
		c.bufferpos = len;
	}

	function doClientDisconnected(s:Socket):Void
	{
		try s.close() catch( e : Dynamic ) {};
		clientDisconnected(s);
	}

	function logError(e:Dynamic):Void
	{
		var stack = Stack.exceptionStack();
		if( Thread.current() == worker )
			onError(e,stack);
		else
			work( callback(onError,e,stack) );
	}

	function addClient(sock:Socket):Void
	{
		var infos:ClientInfos = {
			unid: __id++,
			thread: threads[Std.random(nthreads)],
			socket: sock,
			buffer: Bytes.alloc(initialBufferSize),
			bufferpos: 0,
		};

		clientConnected(sock);

		sock.custom = infos;
		infos.thread.thread.sendMessage({ s : sock, cnx : true });
	}

	function addSocket(s:Socket):Void
	{
		s.setBlocking(false);
		work(callback(addClient,s));
	}

	function sendData(s:Socket, data:Bytes):Void
	{
		SystemUtils.print("Listener send:"+data.length, PrintConst.SERVICES);
		try {
			s.output.write(data);
		} catch( e:Dynamic ) {
			logError(e);
			stopClient(s);
		}
	}

	function stopClient(s:Socket):Void
	{
		var infos:ClientInfos = s.custom;
		try s.shutdown(true,true) catch( e : Dynamic ) { };
		infos.thread.thread.sendMessage({ s : s, cnx : false });
	}

	function onError( e:Dynamic, stack ) {
		var estr = try Std.string(e) catch( e2 : Dynamic ) "???" + try "["+Std.string(e2)+"]" catch( e : Dynamic ) "";
		errorOutput.writeString( estr + "\n" + Stack.toString(stack) );
		errorOutput.flush();

		if( callbacks != null && callbacks.error != null ) callbacks.error(e);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_ERROR, e));

		isServicing = false;
	}

	function clientConnected(s:Socket):Void
	{
		SystemUtils.print("add Client:"+sock, PrintConst.SERVICES);
		if( callbacks != null && callbacks.create != null ) callbacks.create(s);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_CREATE));
	}

	function clientDisconnected(s:Socket):Void
	{
		SystemUtils.print("remove Client:"+sock, PrintConst.SERVICES);
		if( callbacks != null && callbacks.destory != null ) callbacks.destory(s);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_DESTROY));
	}

	function readClientMessage( buf:Bytes, pos:Int, len:Int, ?s:Socket ): { msg : String, bytes : Int }
	{
		SystemUtils.print("Listener read:"+len, PrintConst.SERVICES);
		if( buf.get(pos) == 60 && buf.readString(pos,len)=="<policy-file-request/>\x00" )
			s.write( makePolicyFile() );
		else {
			if( callbacks != null && callbacks.done != null ) callbacks.doing({bytes:buf.sub(pos,len),unid:s.custom.unid});
			else dispatchEvent(new DatasEvent(DatasEvent.DATA_DOING, {bytes:buf.sub(pos,len),unid:s.custom.unid}));
		}
		return {
			msg : null,
			bytes : len,
		};
	}

	function makePolicyFile():String
	{
		var str = "<cross-domain-policy>";
			str += '<allow-access-from domain="*" to-ports="*"/>';
			str += "</cross-domain-policy>\x00";
		return str;
	}

	function clientMessage(msg:String):Void{}

	function update():Void{}

	function afterEvent():Void{}
}