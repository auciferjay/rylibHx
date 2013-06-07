package cn.royan.hl.uis.sparrow;

import cn.royan.hl.bases.Dictionary;
import cn.royan.hl.interfaces.IDisposeBase;
import cn.royan.hl.utils.SystemUtils;

import flash.display.BitmapData;
import flash.geom.Rectangle;

/**
 * ...
 * @author RoYan
 */
class SparrowAtlas implements IDisposeBase
{
	var mSparrowAtlas:Sparrow;
	var mSparrowRegions:Dictionary;
    var mSparrowFrames:Dictionary;
	
	var sNames:Array<String>;
	
	public function new( texture:Sparrow, xml:Xml ) 
	{
		mSparrowAtlas = texture;
		
		mSparrowRegions = #if flash new Dictionary(); #else {}; #end
		mSparrowFrames	= #if flash new Dictionary(); #else {}; #end
		
		sNames = [];
		
		parseAtlasXml(xml);
	}
	
	function parseAtlasXml(xml:Xml):Void
	{
		var xmlList:Iterator<Xml> = xml.firstElement().elementsNamed("SubTexture");
		
		while ( xmlList.hasNext() ) {
			var subTexture:Xml		= xmlList.next();
			var name:String        	= subTexture.get("name");
			var x:Float           	= Std.parseFloat(subTexture.get("x"));
			var y:Float          	= Std.parseFloat(subTexture.get("y"));
			var width:Float       	= Std.parseFloat(subTexture.get("width"));
			var height:Float      	= Std.parseFloat(subTexture.get("height"));
			var frameX:Float      	= Std.parseFloat(subTexture.get("frameX"));
			var frameY:Float      	= Std.parseFloat(subTexture.get("frameY"));
			var frameWidth:Float  	= Std.parseFloat(subTexture.get("frameWidth"));
			var frameHeight:Float 	= Std.parseFloat(subTexture.get("frameHeight"));
			
			var region:Rectangle = new Rectangle(x, y, width, height);
			var frame:Rectangle  = frameWidth > 0 && frameHeight > 0 ?
					new Rectangle(frameX, frameY, frameWidth, frameHeight) : null;
			
			addRegion( name, region, frame );
		}
	}
	
	/** Retrieves a subtexture by name. Returns <code>null</code> if it is not found. */
	public function getSparrow(name:String):Sparrow
	{
		var region:Rectangle = Reflect.field(mSparrowRegions, name);
		
		if (region == null) return null;
		else return Sparrow.fromSparrow(mSparrowAtlas, region, Reflect.field(mSparrowFrames, name));
	}
	
	/** Returns all textures that start with a certain string, sorted alphabetically
	 *  (especially useful for "MovieClip"). */
	public function getSparrows(prefix:String="", result:Array<Sparrow>=null):Array<Sparrow>
	{
		if (result == null) result = [];
		
		for (name in getNames(prefix, sNames)) 
			result.push(getSparrow(name)); 

		sNames = [];
		return result;
	}
	
	/** Returns all texture names that start with a certain string, sorted alphabetically. */
	public function getNames(prefix:String="", result:Array<String>=null):Array<String>
	{
		if (result == null) result = [];
		
		for (name in Reflect.fields(mSparrowRegions))
			if (name.indexOf(prefix) == 0)
				result.push(name);
		
		//result.sort(Array.CASEINSENSITIVE);
		return result;
	}
	
	/** Returns the region rectangle associated with a specific name. */
	public function getRegion(name:String):Rectangle
	{
		return Reflect.field(mSparrowRegions, name);
	}
	
	/** Returns the frame rectangle of a specific region, or <code>null</code> if that region 
	 *  has no frame. */
	public function getFrame(name:String):Rectangle
	{
		return Reflect.field(mSparrowFrames, name);
	}
	
	/** Adds a named region for a subtexture (described by rectangle with coordinates in 
	 *  pixels) with an optional frame. */
	public function addRegion(name:String, region:Rectangle, frame:Rectangle=null):Void
	{
		Reflect.setField(mSparrowRegions, name, region);
		Reflect.setField(mSparrowFrames, name, frame);
	}
	
	/** Removes a region with a certain name. */
	public function removeRegion(name:String):Void
	{
		Reflect.deleteField(mSparrowRegions, name);
		Reflect.deleteField(mSparrowFrames, name);
	}
	
	/** The base texture that makes up the atlas. */
	public var sparrow(getTexture, null):Sparrow;
	function getTexture():Sparrow
	{ 
		return mSparrowAtlas; 
	}
	
	public function dispose():Void
	{
		mSparrowAtlas.dispose();
	}
}