package starling.extensions.pixelmask;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;

extern class PixelMaskDisplayObject extends DisplayObjectContainer
{
	function new(scaleFactor:Float = -1):Void;
	
	var inverted:Bool;
	var mask:DisplayObject;
}