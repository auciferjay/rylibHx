package cn.royan.hl.uis.graphs;
import cn.royan.hl.uis.sparrow.Sparrow;
import flash.display.BitmapData;
import flash.geom.Point;

/**
 * ...
 * @author RoYan
 */
class UiGShape extends UiGDisplayObject
{
	public function new(texture:Sparrow = null) 
	{
		super();
		
		_touchable = false;
		
		_graphics = new UiGGraphic(texture);
		
		if ( texture != null ) {
			if ( texture.frame != null ) {
				width 	= Std.int(texture.frame.width);
				height 	= Std.int(texture.frame.height);
			} else {
				width 	= Std.int(texture.regin.width);
				height	= Std.int(texture.regin.height);
			}
			
			var point:Point = new Point();
				point.x = _graphics.getTexture().frame != null ? -_graphics.getTexture().frame.x: 0;
				point.y = _graphics.getTexture().frame != null ? -_graphics.getTexture().frame.y: 0;
			
			_snap = new BitmapData(width, height, true, 0x00FF);
			_snap.copyPixels( _graphics.getTexture().bitmapdata, _graphics.getTexture().regin, point );
		}
	}
}