package cn.royan.hl.uis.sparrow;
import cn.royan.hl.bases.Dictionary;
import cn.royan.hl.utils.SystemUtils;
import flash.display.Bitmap;

/**
 * ...
 * @author RoYan
 */
class SparrowManager
{
	static var gameBitmaps:Dictionary = new Dictionary();
	static var gameXMLs:Dictionary = new Dictionary();
	static var gameSparrows:Dictionary = new Dictionary();
	static var gameSparrowAtlases:Dictionary = new Dictionary();
	
	static public inline function setAtlas(type:String, bitmap:Bitmap, xml:Xml):Void
	{
		Reflect.setField(gameBitmaps, type, bitmap);
		Reflect.setField(gameXMLs, type, xml);
	}
	
	static public inline function getAtlas(type:String):SparrowAtlas
	{
		if (Reflect.field(gameSparrowAtlases, type) == null)
		{
			var texture:Sparrow = Sparrow.fromBitmap(Reflect.field(gameBitmaps,type));
			var xml:Xml = Reflect.field(gameXMLs, type);
			Reflect.setField(gameSparrowAtlases, type, new SparrowAtlas(texture, xml) );
		}
		return Reflect.field(gameSparrowAtlases, type);
	}
}