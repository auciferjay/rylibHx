package cn.royan.hl.uis.starling;

import cn.royan.hl.bases.Dictionary;
import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.utils.SystemUtils;

import flash.Vector;
import flash.xml.XML;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import flash.display.Bitmap;

/**
 * ...
 * @author ...
 */
class TextureManager
{
	static var gameBitmaps:Dictionary = #if flash new Dictionary(); #else {}; #end
	static var gameXMLs:Dictionary = #if flash new Dictionary(); #else {}; #end
	static var gameTextures:Dictionary = #if flash new Dictionary(); #else {}; #end
	static var gameTextureAtlases:Dictionary = #if flash new Dictionary(); #else {}; #end
	
	static public inline function setAtlas(type:String, bitmap:Bitmap, xml:XML):Void
	{
		SystemUtils.print(type+":"+bitmap+":"+xml, PrintConst.UIS);
		Reflect.setField(gameBitmaps, type, bitmap);
		Reflect.setField(gameXMLs, type, xml);
		
		if( Reflect.field(gameTextureAtlases, type) == null ) {
			Reflect.field(gameTextureAtlases, type).dispose();
			Reflect.deleteField(gameTextureAtlases, type);
		}
	}
	
	static public inline function getTexture(type:String, name:String, isNew:Bool = false):Texture
	{
		SystemUtils.print(type, PrintConst.UIS);
		if (Reflect.field(gameTextureAtlases, type) == null)
		{
			var texture:Texture = Texture.fromBitmap(Reflect.field(gameBitmaps,type));
			var xml:XML = Reflect.field(gameXMLs, type);
			Reflect.setField(gameTextureAtlases, type, new TextureAtlas(texture, xml) );
		}
		if( Reflect.field(gameTextures, type+"_"+name) == null || isNew ){
			Reflect.setField(gameTextures, type+"_"+name, Reflect.field(gameTextureAtlases, type).getTexture(name));
		}
		return Reflect.field(gameTextures, type+"_"+name);
	}
	
	static public inline function getTextures(type:String, name:String, isNew:Bool = false):Vector<Texture>
	{
		SystemUtils.print(type, PrintConst.UIS);
		if (Reflect.field(gameTextureAtlases, type) == null)
		{
			var texture:Texture = Texture.fromBitmap(Reflect.field(gameBitmaps,type));
			var xml:XML = Reflect.field(gameXMLs, type);
			Reflect.setField(gameTextureAtlases, type, new TextureAtlas(texture, xml) );
		}
		if( Reflect.field(gameTextures, type+"_"+name) == null || isNew ){
			Reflect.setField(gameTextures, type+"_"+name, Reflect.field(gameTextureAtlases, type).getTextures(name));
		}
		return Reflect.field(gameTextures, type+"_"+name);
	}
	
	static public inline function disposeTextures(type:String, name:String):Void
	{
		if ( Reflect.field(gameTextures, type + "_" + name) != null )
		{
			if ( Std.is( Reflect.field(gameTextures, type + "_" + name), Vector) )
			{
				var list:Vector<Texture> = Reflect.field(gameTextures, type + "_" + name);
				for( i in 0...list.length){
					list[i].dispose();
					list[i] = null;
				}
			}else{
				Reflect.field(gameTextures, type+"_"+name).dispose();
				Reflect.deleteField(gameTextures, type + "_" + name);
			}
		}
	}
}