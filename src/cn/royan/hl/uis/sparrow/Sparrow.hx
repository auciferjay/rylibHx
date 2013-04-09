package cn.royan.hl.uis.sparrow;
import cn.royan.hl.interfaces.IDisposeBase;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;

/**
 * ...
 * @author RoYan
 */
class Sparrow implements IDisposeBase
{
	public function new(source:BitmapData, rect:Rectangle=null)
	{
		bitmapdata = source;
		
		regin = rect;
		if ( regin == null ) regin = new Rectangle(0, 0, bitmapdata.width, bitmapdata.height);
	}
	
	public function dispose():Void
	{
		bitmapdata.dispose();
	}
	
	public var bitmapdata(getBitmapdata, null):BitmapData;
	function getBitmapdata():BitmapData
	{
		return bitmapdata;
	}
	
	public var regin:Rectangle;
	public var frame:Rectangle;
	
	static public function fromSparrow(texture:Sparrow, region:Rectangle=null, frame:Rectangle=null):Sparrow
	{
		var sparrow:Sparrow = new Sparrow(texture.bitmapdata, region);
			sparrow.frame = frame;
		return sparrow;
	}
	
	static public function fromBitmap(bitmap:Bitmap):Sparrow
	{
		return fromBitmapData(bitmap.bitmapData);
	}
	
	static public function fromBitmapData(bitmapdata:BitmapData):Sparrow
	{
		var sparrow:Sparrow = new Sparrow(bitmapdata);
		return sparrow;
	}
}