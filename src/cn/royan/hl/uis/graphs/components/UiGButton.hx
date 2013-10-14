package cn.royan.hl.uis.graphs.components;

import cn.royan.hl.uis.graphs.UiGDisplayObject;
import cn.royan.hl.uis.graphs.UiGGraphic;
import cn.royan.hl.uis.graphs.UiGSprite;
import cn.royan.hl.uis.sparrow.Sparrow;

import flash.display.BitmapData;
import flash.geom.Point;

/**
 * ...
 * @author RoYan
 */
class UiGButton extends UiGSprite
{
	private var _textures:Array<Sparrow>;
	
	public function new( sparrows:Array<Sparrow> ) 
	{
		super();
		
		_buttonMode = true;
		
		_textures = sparrows;
		_graphics = new UiGGraphic(_textures[0]);
		
		if ( _textures[0] != null ) {
			if ( _textures[0].frame != null ) {
				width 	= Std.int(_textures[0].frame.width);
				height 	= Std.int(_textures[0].frame.height);
			} else {
				width 	= Std.int(_textures[0].regin.width);
				height	= Std.int(_textures[0].regin.height);
			}
			
			_snap = new BitmapData(width, height, true, 0x00FF);
			_snap.copyPixels( _graphics.getTexture().bitmapdata, _graphics.getTexture().regin, new Point() );
		}
	}
}