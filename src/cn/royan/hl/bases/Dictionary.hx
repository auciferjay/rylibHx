package cn.royan.hl.bases;

/**
 * ...
 * @author RoYan
 */
#if flash
typedef Dictionary = flash.utils.Dictionary;
#else
class Dictionary implements ArrayAccess<Dynamic> {
	public function new(weakKeys:Bool = false) {}
}
#end