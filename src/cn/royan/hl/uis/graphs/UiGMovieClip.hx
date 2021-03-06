package cn.royan.hl.uis.graphs;

import cn.royan.hl.bases.TimerBase;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.uis.graphs.UiGDisplayObject;
import cn.royan.hl.uis.sparrow.Sparrow;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

/**
 * ...
 * @author RoYan
 */
class UiGMovieClip extends UiGDisplayObject
{
	public var currentFrame(getCurrentFrame, null):Int;
	public var totalFrames(getTotalFrames, null):Int;
	
	private var _currentFrame:Int;
	private var _totalFrames:Int;
	private var _textures:Array<Sparrow>;
	private var _timer:TimerBase;
	private var _toFrame:Int;
	private var _loop:Bool;
	private var _autoPlay:Bool;
	private var _sequence:Bool;
	
	public var buttonMode(getButtonMode, setButtonMode):Bool;
	public var dropTarget(getDropTarget, never):UiGDisplayObject;
	public var useHandCursor(default, setUseHandCursor):Bool;
	
	private var _cursorCallbackOut:Dynamic->Void;
	private var _cursorCallbackOver:Dynamic->Void;
	private var _dropTarget:UiGDisplayObject;
	private var _buttonMode:Bool;
	
	public function new( sparrows:Array<Sparrow>, fps:Int )
	{
		super();
		
		_currentFrame 	= 1;
		_totalFrames 	= _toFrame = sparrows.length;
		_loop 			= true;
		_sequence 		= true;
		_autoPlay 		= true;
		_textures 		= sparrows;
		_timer 			= new TimerBase( Std.int( 1000 / fps ), timerHandler );
		
		_touchable = true;
		
		_graphics = new UiGGraphic(_textures[_currentFrame-1]);
		
		if ( _textures[_currentFrame-1] != null ) {
			if ( _textures[_currentFrame-1].frame != null ) {
				width 	= Std.int(_textures[_currentFrame-1].frame.width);
				height 	= Std.int(_textures[_currentFrame-1].frame.height);
			} else {
				width 	= Std.int(_textures[_currentFrame-1].regin.width);
				height	= Std.int(_textures[_currentFrame-1].regin.height);
			}
		}
		
		addEventListener(DatasEvent.MOUSE_OVER, mouseOverHandler);
		addEventListener(DatasEvent.MOUSE_OUT, mouseOutHandler);
	}
	
	function mouseOverHandler(evt:DatasEvent):Void
	{
		#if flash
		Mouse.cursor = _buttonMode?MouseCursor.BUTTON:MouseCursor.AUTO;
		#end
	}
	
	function mouseOutHandler(evt:DatasEvent):Void
	{
		#if flash
		Mouse.cursor = MouseCursor.AUTO;
		#end
	}
	
	public function getDropTarget():UiGDisplayObject
	{
		return _dropTarget;
	}
	
	public function setUseHandCursor(value:Bool):Bool
	{
		return useHandCursor;
	}
	
	public function setButtonMode(value:Bool):Bool
	{
		_buttonMode = value;
		return _buttonMode;
	}
	
	public function getButtonMode():Bool
	{
		return _buttonMode;
	}
	
	/**
	 * 顺序播放
	 */
	public function getIn():Void
	{
		goFromTo(1, _totalFrames);
	}
	
	/**
	 * 倒叙播放
	 */
	public function getOut():Void
	{
		goFromTo(_totalFrames, 1);
	}

	/**
	 * 播放到..
	 * @param	frame
	 */
	public function goTo(frame:Int):Void
	{
		goFromTo(_currentFrame, frame);
	}
	
	/**
	 * 跳至...
	 * @param	frame
	 */
	public function jumpTo(frame:Int):Void
	{
		_loop = false;
		_currentFrame = frame;
		
		updateTexture();
		updateDisplayList();
	}

	/**
	 * 从某一帧开始播放至另一帧
	 * @param	from
	 * @param	to
	 */
	public function goFromTo(from:Int, to:Int):Void
	{
		if( from == to ) return;
		
		_loop = false;
		_sequence = from <= to;
		_currentFrame 	= from;
		_toFrame 		= to;
		
		_timer.start();
	}
	
	/**
	 * 播放
	 */
	public function play():Void
	{
		_timer.start();
	}
	
	/**
	 * 停止
	 */
	public function stop():Void
	{
		_timer.stop();
		_currentFrame = 1;
		updateTexture();
		updateDisplayList();
	}
	
	/**
	 * 暂停
	 */
	public function pause():Void
	{
		_timer.stop();
	}
	
	public function nextFrame():Void
	{
		_currentFrame++;
		if( _currentFrame > _totalFrames )
		{
			_currentFrame = 1;
		}
		updateTexture();
		updateDisplayList();
	}
	
	public function prevFrame():Void
	{
		_currentFrame--;
		if( _currentFrame < 1 )
		{
			_currentFrame = _totalFrames;
		}
		updateTexture();
		updateDisplayList();
	}
	
	function timerHandler():Void
	{
		if( _sequence )
		{
			_currentFrame++;
			if( _currentFrame > _totalFrames )
			{
				if( _loop ) _currentFrame = 1;
				else _timer.stop();
			}
		}
		else
		{
			_currentFrame--;
			if( _currentFrame < 0 )
			{
				if( _loop ) _currentFrame = _totalFrames - 1;
				else _timer.stop();
			}
		}
		
		if( _currentFrame == _toFrame - 1 && !_loop ){
			_timer.stop();
		}
		
		updateTexture();
		updateDisplayList();
	}
	
	public function getCurrentFrame():Int
	{
		return _currentFrame;
	}
	
	public function getTotalFrames():Int
	{
		return _totalFrames;
	}
	
	function updateTexture():Void
	{
		_graphics.setTexture(_textures[currentFrame - 1]);
		_renderFlags |= UiGDisplayObject.RENDER_PICTURE;
	}
}