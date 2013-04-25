package cn.royan.hl.bases;

/**
 * ...
 * @author RoYan
 */
#if flash
typedef Dictionary = flash.utils.Dictionary;
#else
typedef Dictionary = Dynamic;
#end