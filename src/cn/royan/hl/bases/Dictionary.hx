package cn.royan.hl.bases;

/**
 * ...
 * Flash环境下为Dictionary，其他环境下为Dynamic<Dynamic>
 * @author RoYan
 */
#if flash
typedef Dictionary = flash.utils.Dictionary;
#else
typedef Dictionary = Dynamic<Dynamic>;
#end