package cn.royan.hl.utils;
import cn.royan.hl.bases.Dictionary;
import flash.display.DisplayObject;
import flash.events.KeyboardEvent;

/**
 * ...
 * @author RoYan
 */
class KeyBoardUtils
{
	static var keyObj:KeyBoardUtils;
    static var keys:Dictionary;
	
	static public function init(display:DisplayObject):Void
	{
		if ( keyObj == null ) {
			keys = new Dictionary();
			
			display.stage.addEventListener( KeyboardEvent.KEY_DOWN, KeyBoardUtils.keyDownHandler, false, 99, true );
			display.stage.addEventListener( KeyboardEvent.KEY_UP, KeyBoardUtils.keyUpHandler, false, 99, true );
			
			keyObj = new KeyBoardUtils();
		}
	}
	
	static public function isDown():Bool
	{
		
	}
	
	static function keyDownHandler(evt:KeyboardEvent):Void
	{
		keys[evt.keyCode] = true;
	}
	
	static function keyUpHandler(evt:KeyboardEvent):Void
	{
		delete keys[evt.keyCode];
	}
}