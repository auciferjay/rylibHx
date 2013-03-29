package cn.royan.hl.resources;
import cn.royan.hl.bases.Dictionary;
import cn.royan.hl.interfaces.IDisposeBase;
import cn.royan.hl.utils.SystemUtils;
import haxe.Json;

import flash.errors.Error;
/**
 * ...
 * @author RoYan
 */

class ConfigFile implements IDisposeBase
{
	static public inline var CONFIG_FILE_TYPE_JSON:Int 	= 0;
	static public inline var CONFIG_FILE_TYPE_XML:Int 	= 1;
	static public inline var CONFIG_FILE_TYPE_TEXT:Int 	= 2;
	
	var type:Int;
	var configData:Dynamic;
	
	public function new(data:String, type:Int=CONFIG_FILE_TYPE_JSON)
	{
		this.type = type;
		
		configData = {};
		
		switch(type){
			case ConfigFile.CONFIG_FILE_TYPE_JSON:
				parseJsonToObject(data);
			case ConfigFile.CONFIG_FILE_TYPE_XML:
				parseXMLToObject(data);
			case ConfigFile.CONFIG_FILE_TYPE_TEXT:
				parseTxtToObject(data);
		}
	}
	
	public function getValue():Dynamic
	{
		return configData;
	}
	
	public function dispose():Void
	{
		configData = null;
	}
	
	function parseJsonToObject(data:String):Void
	{
		configData = Json.parse(data);
	}
	
	function parseXMLToObject(data:String):Void
	{
		var xml:Xml = Xml.parse(data);
		
		parseXMLListToObject(xml.elements(), configData);
	}
	
	function parseXMLListToObject(xmlList:Iterator<Xml>, parent:Dynamic):Void
	{
		while( xmlList.hasNext() ){
			var child:Dynamic = {};
			
			var xml:Xml = xmlList.next();
			if ( Reflect.field(parent, xml.nodeName) == null ) {
				Reflect.setField(parent, xml.nodeName, child);
			}
			else if( Std.is(Reflect.field(parent, xml.nodeName), Array) ){
				cast(Reflect.field(parent, xml.nodeName)).push( child );
			}else{
				var temp:Dynamic = Reflect.field(parent, xml.nodeName);
				Reflect.setField(parent, xml.nodeName, [temp]);
				cast(Reflect.field(parent, xml.nodeName)).push( child );
			}
			if( xml.elements() != null ){
				parseXMLListToObject(xml.elements(), child);
			}
			
			var attributes:Iterator<String> = xml.attributes();
			while (attributes.hasNext()) {
				var attribute:String = attributes.next();
				Reflect.setField(child, attribute, xml.get(attribute));
			}
		}
	}
	
	function parseTxtToObject(txt:String):Void
	{
		var valuePair:Array<String> = txt.split("&");
		var i:Int;
		var len:Int = valuePair.length;
		for( i in 0...len){
			var pair:Array<String> = valuePair[i].split("=");
			Reflect.setField(configData, pair[0], pair[1]);
		}
	}
	
	static public function getExtension(configType:Int):String
	{
		switch( configType ){
			case ConfigFile.CONFIG_FILE_TYPE_JSON:
				return ".json";
			case ConfigFile.CONFIG_FILE_TYPE_XML:
				return ".xml";
			case ConfigFile.CONFIG_FILE_TYPE_TEXT:
				return ".txt";
		}
		return ".json";
	}
}