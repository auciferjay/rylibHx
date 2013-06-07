package cn.royan.hl.uis.sparrow;

import cn.royan.hl.bases.Dictionary;
import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.utils.SystemUtils;

import flash.display.Bitmap;

/**
 * ...
 * @author RoYan
 */
class SparrowManager
{
	static var gameBitmaps:Dictionary = #if flash new Dictionary(); #else {}; #end
	static var gameXMLs:Dictionary = #if flash new Dictionary(); #else {}; #end
	static var gameSparrows:Dictionary = #if flash new Dictionary(); #else {}; #end
	static var gameSparrowAtlases:Dictionary = #if flash new Dictionary(); #else {}; #end
	
	static public inline function setAtlas(type:String, bitmap:Bitmap, xml:Xml):Void
	{
		SystemUtils.print(type+":"+bitmap+":"+xml, PrintConst.UIS);
		Reflect.setField(gameBitmaps, type, bitmap);
		Reflect.setField(gameXMLs, type, xml);
	}
	
	static public inline function getAtlas(type:String):SparrowAtlas
	{
		SystemUtils.print(type, PrintConst.UIS);
		if (Reflect.field(gameSparrowAtlases, type) == null)
		{
			var texture:Sparrow = Sparrow.fromBitmap(Reflect.field(gameBitmaps,type));
			var xml:Xml = Reflect.field(gameXMLs, type);
			Reflect.setField(gameSparrowAtlases, type, new SparrowAtlas(texture, xml) );
		}
		return Reflect.field(gameSparrowAtlases, type);
	}
}