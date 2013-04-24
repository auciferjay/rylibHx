package cn.royan.hl.uis.normal.bases;

import cn.royan.hl.systems.DeviceCapabilities;
import cn.royan.hl.uis.normal.InteractiveUiN;

/**
 * ...
 * @author RoYan
 */
class UiNScreen extends UiNContainer
{
	var id:String;
	
	public function new() 
	{
		super();
		
		originalDPI = DeviceCapabilities.dpi;
	}
	
	public function setScreenID(value:String):Void
	{
		id = value;
	}
	
	public function getScreenID():String
	{
		return id;
	}
}