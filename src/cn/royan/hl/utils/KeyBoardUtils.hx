package cn.royan.hl.utils;

import cn.royan.hl.bases.Dictionary;

import flash.display.DisplayObject;
import flash.events.KeyboardEvent;

/**
 * ...
 * 键盘工具类
 * @author RoYan
 */
class KeyBoardUtils
{
	static var keyObj:KeyBoardUtils;
    static var keys:Dictionary;
	
	function new() {
		
	}
	
	/**
	 * 初始化
	 * @param	display
	 */
	static public function init(display:DisplayObject):Void
	{
		if ( keyObj == null ) {
			keys = #if flash new Dictionary(); #else {}; #end
			
			display.stage.addEventListener( KeyboardEvent.KEY_DOWN, KeyBoardUtils.keyDownHandler, false, 99, true );
			display.stage.addEventListener( KeyboardEvent.KEY_UP, KeyBoardUtils.keyUpHandler, false, 99, true );
			
			keyObj = new KeyBoardUtils();
		}
	}
	
	/**
	 * 检测键位状态
	 * @param	code
	 * @return
	 */
	static public function isDown(code:UInt):Bool
	{
		return Reflect.field( keys, Std.string(code) );
	}
	
	static function keyDownHandler(evt:KeyboardEvent):Void
	{
		Reflect.setField( keys, Std.string(evt.keyCode), true );
	}
	
	static function keyUpHandler(evt:KeyboardEvent):Void
	{
		Reflect.deleteField( keys, Std.string(evt.keyCode) );
	}
}