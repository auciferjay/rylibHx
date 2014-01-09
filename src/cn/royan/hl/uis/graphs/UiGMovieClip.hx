package cn.royan.hl.uis.graphs;

import cn.royan.hl.bases.TimerBase;
import cn.royan.hl.uis.graphs.UiGDisplayObject;
import cn.royan.hl.uis.sparrow.Sparrow;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * ...
 * @author RoYan
 */
class UiGMovieClip extends UiGSprite
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
	
	public function new( sparrows:Array<Sparrow>, fps:Int )
	{
		_currentFrame 	= 1;
		_totalFrames 	= _toFrame = sparrows.length;
		_loop 			= true;
		_sequence 		= true;
		_autoPlay 		= true;
		_textures 		= sparrows;
		_timer 			= new TimerBase( Std.int( 1000 / fps ), timerHandler );
		
		super( _textures[_currentFrame-1] );
	}
	
	override public function draw():Void 
	{
		super.draw();
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
		
		updateDisplayList();
		
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
		updateDisplayList();
	}
	
	public function prevFrame():Void
	{
		_currentFrame--;
		if( _currentFrame < 1 )
		{
			_currentFrame = _totalFrames;
		}
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
	
	override public function updateDisplayList(item:UiGDisplayObject = null):Void 
	{
		_graphics.setTexture(_textures[currentFrame - 1]);
		//_graphicFlags = true;
		_renderFlags |= UiGDisplayObject.RENDER_PICTURE;
		super.updateDisplayList(item);
	}
	/*
	override public function recycle():Void 
	{
		//super.recycle();
	}*/
}