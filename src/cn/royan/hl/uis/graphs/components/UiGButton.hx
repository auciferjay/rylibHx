package cn.royan.hl.uis.graphs.components;

import cn.royan.hl.consts.UiConst;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.uis.graphs.UiGDisplayObject;
import cn.royan.hl.uis.graphs.UiGGraphic;
import cn.royan.hl.uis.graphs.UiGSprite;
import cn.royan.hl.uis.sparrow.Sparrow;

import flash.ui.Mouse;
#if flash
import flash.ui.MouseCursor;
#end
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
		
		while ( _textures.length < 4 ) {
			_textures.push(_textures[_textures.length-1]);
		}
		
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
		
		addEventListener(DatasEvent.MOUSE_DOWN, mouseDownHandler);
		addEventListener(DatasEvent.MOUSE_UP, mouseUpHandler);
		
		addEventListener(DatasEvent.MOUSE_RELEASE_OUT, mouseReleaseOutHandler);
	}
	
	function mouseDownHandler(evt:DatasEvent):Void 
	{
		_graphics.setTexture(_textures[2]);
		_graphicFlags = true;
		updateDisplayList();
	}
	
	function mouseUpHandler(evt:DatasEvent):Void 
	{
		_graphics.setTexture(_textures[1]);
		_graphicFlags = true;
		updateDisplayList();
	}
	
	function mouseReleaseOutHandler(evt:DatasEvent):Void
	{
		
	}
	
	override private function mouseOverHandler(evt:DatasEvent):Void 
	{
		super.mouseOverHandler(evt);
		_graphics.setTexture(_textures[1]);
		_graphicFlags = true;
		updateDisplayList();
	}
	
	override private function mouseOutHandler(evt:DatasEvent):Void 
	{
		super.mouseOutHandler(evt);
		_graphics.setTexture(_textures[0]);
		_graphicFlags = true;
		updateDisplayList();
	}
}