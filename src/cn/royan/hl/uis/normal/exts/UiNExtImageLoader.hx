package cn.royan.hl.uis.normal.exts;

import cn.royan.hl.services.TakeService;
import cn.royan.hl.uis.normal.bases.UiNContainerAlign;
import cn.royan.hl.uis.normal.InteractiveUiN;
import cn.royan.hl.uis.sparrow.Sparrow;

import flash.display.BitmapData;

/**
 * ...
 * @author RoYan
 */
class UiNExtImageLoader extends UiNContainerAlign
{
	var takeService:TakeService;
	var image:InteractiveUiN;
	
	public function new(url:String="") 
	{
		super();
		
		image = new InteractiveUiN();
		addItem( image );
		
		takeService = new TakeService();
		takeService.setCallbacks( { done:doneHandler } ); 
		
		if ( url != "" ) {
			load(url);
		}
	}
	
	function doneHandler(data:BitmapData):Void
	{
		image.setTexture(Sparrow.fromBitmapData(data));
	}
	
	public function load(url:String):Void
	{
		takeService.sendRequest(url);
		takeService.connect();
	}
}