package cn.royan.hl.uis.starling.exts;

import cn.royan.hl.services.TakeService;
import cn.royan.hl.uis.starling.bases.UiSContainerAlign;
import cn.royan.hl.uis.starling.InteractiveUiS;
import starling.textures.Texture;

import flash.display.BitmapData;

/**
 * ...
 * @author RoYan
 */
class UiSExtImageLoader extends UiSContainerAlign
{
	var takeService:TakeService;
	var image:InteractiveUiS;
	
	public function new(url:String="") 
	{
		super();
		
		image = new InteractiveUiS();
		addItem( image );
		
		takeService = new TakeService();
		takeService.setCallbacks( { done:doneHandler } ); 
		
		if ( url != "" ) {
			load(url);
		}
	}
	
	function doneHandler(data:BitmapData):Void
	{
		image.setTexture(Texture.fromBitmapData(data));
	}
	
	public function load(url:String):Void
	{
		takeService.sendRequest(url);
		takeService.connect();
	}
}