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
	
	static public inline function getSparrow(type:String, name:String, isNew:Bool = false):Sparrow
	{
		SystemUtils.print(type, PrintConst.UIS);
		if (Reflect.field(gameSparrowAtlases, type) == null)
		{
			var texture:Sparrow = Sparrow.fromBitmap(Reflect.field(gameBitmaps,type));
			var xml:Xml = Reflect.field(gameXMLs, type);
			Reflect.setField(gameSparrowAtlases, type, new SparrowAtlas(texture, xml) );
		}
		if( Reflect.field(gameSparrows, type+"|"+name) == null || isNew ){
			Reflect.setField(gameSparrows, type+"|"+name, Reflect.field(gameSparrowAtlases, type).getSparrow(name));
		}
		return Reflect.field(gameSparrows, type+"|"+name);
	}
	
	static public inline function getSparrows(type:String, name:String, isNew:Bool = false):Array<Sparrow>
	{
		SystemUtils.print(type, PrintConst.UIS);
		if (Reflect.field(gameSparrowAtlases, type) == null)
		{
			var texture:Sparrow = Sparrow.fromBitmap(Reflect.field(gameBitmaps,type));
			var xml:Xml = Reflect.field(gameXMLs, type);
			Reflect.setField(gameSparrowAtlases, type, new SparrowAtlas(texture, xml) );
		}
		if( Reflect.field(gameSparrows, type+"|"+name) == null || isNew ){
			Reflect.setField(gameSparrows, type+"|"+name, Reflect.field(gameSparrowAtlases, type).getSparrows(name));
		}
		return Reflect.field(gameSparrows, type+"|"+name);
	}
	
	static public inline function disposeSparrow(type:String, name:String):Void
	{
		if ( Reflect.field(gameSparrows, type + "|" + name) != null )
		{
			if ( Std.is( Reflect.field(gameSparrows, type + "|" + name), Array) )
			{
				var list:Array<Sparrow> = Reflect.field(gameSparrows, type + "|" + name);
				for( i in 0...list.length){
					list[i].dispose();
					list[i] = null;
				}
			}else{
				Reflect.field(gameSparrows, type+"|"+name).dispose();
			}
			
			Reflect.deleteField(gameSparrows, type + "|" + name);
			
			var atlases:Array<String> = [];
			for( texture in Reflect.fields(gameSparrows) ){
				var atlasT:String = texture.split("|")[0];
				//if( atlases.indexOf(atlasT) == -1 )
					atlases.push(atlasT);
			}
			for ( atlas in Reflect.fields(gameSparrowAtlases) ) {
				var isFind:Bool = false;
				for ( item in atlases ) {
					if ( item == atlas ) {
						isFind = true;
					}
				}
				if( !isFind ){
					Reflect.field(gameSparrowAtlases, atlas).dispose();
					Reflect.deleteField(gameSparrowAtlases, atlas);
				}
			}
		}
	}
}