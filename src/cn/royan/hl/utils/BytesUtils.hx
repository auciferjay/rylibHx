package cn.royan.hl.utils;

import flash.utils.ByteArray;

/**
 * ...
 * 数据工具类
 * @author RoYan
 */
class BytesUtils 
{
	/**
	 * 数据类型
	 * @param	bytes
	 * @return
	 */
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
	
	/**
	 * 是否为PNG
	 * @param	bytes
	 * @return
	 */
	public static function isPNG(bytes:ByteArray):Bool
	{
		bytes.position = 0;
		
		if ( bytes.bytesAvailable < 4 || bytes.readUnsignedByte() != 0xff ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.bytesAvailable < 3 || bytes.readUnsignedByte() != 0xd8 ) {
			bytes.position = 0;
			return false;
		}
		
		bytes.position = bytes.length - 2;
		
		if ( bytes.bytesAvailable < 2 || bytes.readUnsignedByte() != 0xff ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.bytesAvailable < 1 || bytes.readUnsignedByte() != 0xd9 ) {
			bytes.position = 0;
			return false;
		}
		bytes.position = 0;
		return true;
	}
	
	/**
	 * 是否为JPEG
	 * @param	bytes
	 * @return
	 */
	public static function isJPEG(bytes:ByteArray):Bool
	{
		bytes.position = 0;
		
		if ( bytes.bytesAvailable < 8 || bytes.readUnsignedByte() != 0x89 ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.bytesAvailable < 7 || bytes.readUnsignedByte() != 0x50 ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.bytesAvailable < 6 || bytes.readUnsignedByte() != 0x4E ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.bytesAvailable < 5 || bytes.readUnsignedByte() != 0x47 ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.bytesAvailable < 4 || bytes.readUnsignedByte() != 0x0D ) {
			bytes.position = 0;
			return false;
		}
		if (bytes.bytesAvailable < 3 || bytes.readUnsignedByte() != 0x0A ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.bytesAvailable < 2 || bytes.readUnsignedByte() != 0x1A ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.bytesAvailable < 1 || bytes.readUnsignedByte() != 0x0A ) {
			bytes.position = 0;
			return false;
		}
		return true;
	}
	
	/**
	 * 是否为SWF
	 * @param	bytes
	 * @return
	 */
	public static function isSWF(bytes:ByteArray):Bool
	{
		bytes.position = 0;
		if ( bytes.bytesAvailable < 3 ) return false;
		var header:String = bytes.readUTFBytes(3);
		bytes.position = 0;
		return header == "CWS" || header == "FWS";
	}
	
	/**
	 * 是否为XML
	 * @param	bytes
	 * @return
	 */
	public static function isXML(bytes:ByteArray):Bool
	{
		bytes.position = 0;
		if ( bytes.bytesAvailable < 5 ) return false;
		var header:String = bytes.readUTFBytes(5);
		bytes.position = 0;
		return header == "<?xml";
	}
	
	/**
	 * 是否为GIF
	 * @param	bytes
	 * @return
	 */
	public static function isGIF(bytes:ByteArray):Bool
	{
		if ( bytes.bytesAvailable < 6 || bytes.readUnsignedByte() != 0x47 ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.bytesAvailable < 5 || bytes.readUnsignedByte() != 0x49 ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.bytesAvailable < 4 || bytes.readUnsignedByte() != 0x46 ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.bytesAvailable < 3 || bytes.readUnsignedByte() != 0x38 ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.bytesAvailable < 2 || bytes.readUnsignedByte() != 0x39 && bytes.readUnsignedByte() != 0x37 ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.bytesAvailable < 1 || bytes.readUnsignedByte() != 0x61 ) {
			bytes.position = 0;
			return false;
		}
		return true;
	}
	
	/**
	 * 是否BMP
	 * @param	bytes
	 * @return
	 */
	public static function isBMP(bytes:ByteArray):Bool
	{
		if ( bytes.bytesAvailable < 2 || bytes.readUnsignedByte() != 0x42 ) {
			bytes.position = 0;
			return false;
		}
		if ( bytes.bytesAvailable < 1 || bytes.readUnsignedByte() != 0x4d ) {
			bytes.position = 0;
			return false;
		}
		bytes.position = 0;
		return true;
	}
	
	/**
	 * 是否为FLV
	 * @param	bytes
	 * @return
	 */
	public static function isFLV(bytes:ByteArray):Bool
	{
		bytes.position = 0;
		if ( bytes.bytesAvailable < 3 ) return false;
		var header:String = bytes.readUTFBytes(3);
		bytes.position = 0;
		return header == "FLV";
	}
	
	/**
	 * 是否为MP3
	 * @param	bytes
	 * @return
	 */
	public static function isMP3(bytes:ByteArray):Bool
	{
		bytes.position = 0;
		if ( bytes.bytesAvailable < 3 ) return false;
		var header:String = bytes.readUTFBytes(3);
		bytes.position = 0;
		return header == "ID3";
	}
	
	/**
	 * 是否进行了编码
	 * @param	bytes
	 * @return
	 */
	public static function isEncrypt(bytes:ByteArray):Bool
	{
		bytes.position = 0;
		var BYTE_KEY:Array<Int> = [10, 40, 90];
		var isEnc:Bool = true;
		if ( bytes.bytesAvailable < 3 ) return false;
		for (i in 0...3) {
			if (bytes.readByte() != BYTE_KEY[i]) {
				isEnc = false;
			}
		}
		bytes.position = 0;
		return isEnc;
	}
	
	/**
	 * 进行解码
	 * @param	bytes
	 * @param	key
	 * @return
	 */
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