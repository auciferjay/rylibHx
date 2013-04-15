package cn.royan.hl.uis.normal.bases;
import cn.royan.hl.bases.DispatcherBase;
import cn.royan.hl.uis.normal.InteractiveUiN;
import cn.royan.hl.events.DatasEvent;

import flash.display.Sprite;
import flash.text.TextField;

/**
 * ...
 * @author RoYan
 */

class UiNLoader extends InteractiveUiN
{
	var loaderData:DispatcherBase;
	var currentFileName:TextField;
	var progressTxt:TextField;
	var progressBar:Sprite;
		
	public function new(loader:DispatcherBase=null) 
	{
		super();
		
		if( loader != null ) setLoaderData( loader );
		if( getChildByName("__progress") != null )
			progressBar = cast( getChildByName("__progress"), Sprite );
		if( getChildByName("__progressTxt") != null )
			progressTxt = cast( getChildByName("__progressTxt"), TextField);
		if( getChildByName("__currentFile") != null )
			currentFileName = cast( getChildByName("__currentFile"), TextField);
	}
	
	public function setLoaderData(loader:DispatcherBase):Void
	{
		loaderData = loader;
		loaderData.addEventListener(DatasEvent.DATA_DOING, loaderProgressHandler);
		loaderData.addEventListener(DatasEvent.DATA_DONE, loaderCompleteHandler);
	}
	
	public function loaderProgress(data: { var loaded:Int; var total:Int; } ):Void
	{
		
	}
	
	public function loaderComplete():Void
	{
		
	}
	
	function loaderProgressHandler(evt:DatasEvent):Void
	{
		
	}
	
	function loaderCompleteHandler(evt:DatasEvent):Void
	{
		
	}
}