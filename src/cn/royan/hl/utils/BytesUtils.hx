package cn.royan.hl.utils;
import flash.utils.ByteArray;

/**
 * ...
 * @author RoYan
 */

class BytesUtils 
{

	public static function getType(bytes:ByteArray):String
	{
		if( isPNG(bytes) ){
			return "PNG";
		}
		if( isJPEG(bytes) ){
			return "JPEG";
		}
		if( isSWF(bytes) ){
			return "SWF";
		}
		if( isXML(bytes) ){
			return "XML";
		}
		if( isGIF(bytes) ){
			return "GIF";
		}
		if( isBMP(bytes) ){
			return "BMP";
		}
		if( isFLV(bytes) ){
			return "FLV";
		}
		if( isMP3(bytes) ){
			return "MP3";
		}
		return "Other";
	}
	
	public static function isPNG(bytes:ByteArray):Bool
	{
		bytes.position = 0;
		
		if ( bytes.readUnsignedByte() != 0xff ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.readUnsignedByte() != 0xd8 ) {
			bytes.position = 0;
			return false;
		}
		
		bytes.position = bytes.length - 2;
		
		if ( bytes.readUnsignedByte() != 0xff ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.readUnsignedByte() != 0xd9 ) {
			bytes.position = 0;
			return false;
		}
		bytes.position = 0;
		return true;
	}
	
	public static function isJPEG(bytes:ByteArray):Bool
	{
		bytes.position = 0;
		
		if ( bytes.readUnsignedByte() != 0x89 ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.readUnsignedByte() != 0x50 ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.readUnsignedByte() != 0x4E ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.readUnsignedByte() != 0x47 ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.readUnsignedByte() != 0x0D ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.readUnsignedByte() != 0x0A ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.readUnsignedByte() != 0x1A ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.readUnsignedByte() != 0x0A ) {
			bytes.position = 0;
			return false;
		}
		return true;
	}
	
	public static function isSWF(bytes:ByteArray):Bool
	{
		bytes.position = 0;
		var header:String = bytes.readMultiByte(3, 'utf8');
		bytes.position = 0;
		return header == "CWS" || header == "FWS";
	}
	
	public static function isXML(bytes:ByteArray):Bool
	{
		bytes.position = 0;
		var header:String = bytes.readMultiByte(5, 'utf8');
		bytes.position = 0;
		return header == "<?xml";
	}
	
	public static function isGIF(bytes:ByteArray):Bool
	{
		if ( bytes.readUnsignedByte() != 0x47 ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.readUnsignedByte() != 0x49 ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.readUnsignedByte() != 0x46 ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.readUnsignedByte() != 0x38 ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.readUnsignedByte() != 0x39 && bytes.readUnsignedByte() != 0x37 ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.readUnsignedByte() != 0x61 ) {
			bytes.position = 0;
			return false;
		}
		return true;
	}
	
	public static function isBMP(bytes:ByteArray):Bool
	{
		if ( bytes.readUnsignedByte() != 0x42 ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.readUnsignedByte() != 0x4d ) {
			bytes.position = 0;
			return false;
		}
		bytes.position = 0;
		return true;
	}
	
	public static function isFLV(bytes:ByteArray):Bool
	{
		bytes.position = 0;
		var header:String = bytes.readMultiByte(3, 'utf8');
		bytes.position = 0;
		return header == "FLV";
	}
	
	public static function isMP3(bytes:ByteArray):Bool
	{
		bytes.position = 0;
		var header:String = bytes.readMultiByte(3, 'utf8');
		bytes.position = 0;
		return header == "ID3";
	}
	
	public static function isEncrypt(bytes:ByteArray):Bool
	{
		bytes.position = 0;
		var BYTE_KEY:Array<Int> = [10, 40, 90, 80];
		var isEnc:Bool = true;
		for (i in 0...3) {
			if (bytes.readByte() != BYTE_KEY[i]) {
				isEnc = false;
			}
		}
		bytes.position = 0;
		return isEnc;
	}
	
	public static function simpleDecode(bytes:ByteArray, key:String):ByteArray
	{
		if (!isEncrypt(bytes)) {
			return bytes;
		} else {
			var flag:Int = 0;
			var result:ByteArray = new ByteArray();
			for ( i in 3...bytes.length ) {
				if (flag >= key.length) flag = 0;
				result.writeByte(bytes[i] - key.charCodeAt(flag));
				flag++;
			}
			return result;
		}
	}
}