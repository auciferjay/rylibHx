package cn.royan.hl.resources;
import cn.royan.hl.bases.Dictionary;
import cn.royan.hl.interfaces.IDisposeBase;
import cn.royan.hl.utils.SystemUtils;

import flash.xml.XML;
import flash.xml.XMLList;
import flash.xml.XMLNode;
import flash.xml.XMLDocument;
import flash.errors.Error;
/**
 * ...
 * @author RoYan
 */

class ConfigFile implements IDisposeBase
{
	static public inline var CONFIG_FILE_TYPE_JSON:UInt = 0;
	static public inline var CONFIG_FILE_TYPE_XML:UInt 	= 1;
	static public inline var CONFIG_FILE_TYPE_TEXT:UInt = 2;
	
	var type:Int;
	var configData:Dictionary;
	
	public function new(data:String, type:Int=CONFIG_FILE_TYPE_JSON)
	{
		this.type = type;
		
		configData = new Dictionary();
		
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
		
	}
	
	function parseXMLToObject(data:String):Void
	{
		try{
			var xml:XML = new XML(data);
			SystemUtils.print("[Class ConfigFile]:XML To Object");
			
			parseXMLListToObject(xml.children(), configData);
			SystemUtils.readObject(configData);
			
		}catch(e:Error){
			var xmlDoc:XMLDocument = new XMLDocument();
				xmlDoc.ignoreWhite = true;
				xmlDoc.parseXML(data);
			
			parseXMLNodeToObject(xmlDoc, configData);
			SystemUtils.print("[Class ConfigFile]:XMLDocument To Object");
//			PoolMap.disposeInstance(xmlDoc);
			xmlDoc = null;
		}
	}
	
	function parseXMLListToObject(xmlList:XMLList, parent:Dynamic):Void
	{
		var i:Int = 0;
		var len:Int = xmlList.length();
		for( i in 0...len ){
			var child:Dynamic = new Dictionary();
			
			if( Reflect.field(parent, xmlList[i].name()) == null ){
				Reflect.setField(parent, xmlList[i].name(), child);
			}
			else if( Std.is(Reflect.field(parent, xmlList[i].name()), Array) ){
				cast(Reflect.field(parent, xmlList[i].name())).push( child );
			}else{
				var temp:Dynamic = Reflect.field(parent, xmlList[i].name());
				Reflect.setField(parent, xmlList[i].name(), [temp]);
				cast(Reflect.field(parent, xmlList[i].name())).push( child );
			}
			if( xmlList[i].children().length() > 0 ){
				parseXMLListToObject(xmlList[i].children(), child);
			}
			
			var j:Int = 0;
			var len2:Int = xmlList[i].attributes().length();
			for (j in 0...len2) {
				Reflect.setField(child, xmlList[i].attributes()[j].name().toString(), xmlList[i].attributes()[j].toString());
			}
		}
	}
	
	function parseXMLNodeToObject(xmlNode:XMLNode, parent:Dynamic):Void
	{
		var i:Int = 0;
		var nodes:Array<Dynamic> = xmlNode.childNodes;
		var len:Int = nodes.length;
		for(i in 0...len){
			var child:Dynamic = new Dictionary();
			
			if( Reflect.field(parent, nodes[i].nodeName) == null ){
				Reflect.setField(parent, nodes[i].nodeName, child);
			}
			else if( Std.is(Reflect.field(parent, nodes[i].nodeName), Array) ){
				cast(Reflect.field(parent, nodes[i].nodeName)).push( child );
			}else{
				var temp:Dynamic = Reflect.field(parent, nodes[i].nodeName);
				Reflect.setField(parent, nodes[i].nodeName, temp);
				cast(Reflect.field(parent, nodes[i].nodeName)).push( child );
			}
			if( nodes[i].childNodes.length > 0 ){
				parseXMLNodeToObject(nodes[i], child);
			}
			
			for (prop in Reflect.fields(nodes[i].attributes)) {
				Reflect.setField(child, prop, Reflect.field(nodes[i].attributes, prop));
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
	
	static public function getExtension(configType:UInt):String
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