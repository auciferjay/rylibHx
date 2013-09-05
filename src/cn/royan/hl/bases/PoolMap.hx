package cn.royan.hl.bases;

import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.utils.SystemUtils;

#if !flash
import nme.ObjectHash;
#else
import flash.utils.TypedDictionary;
#end
/**
 * ...
 * 对象池类
 * @author RoYan
 */
class PoolMap 
{
	public static var maxValue:Int = 10;
	
	#if !flash
	private static var pools:ObjectHash<Dynamic, Array<String>> = new ObjectHash < Dynamic, Array<String> > ();
	#else
	private static var pools:TypedDictionary<Dynamic, Array<String>> = new TypedDictionary < Dynamic, Array<String> > (true);
	#end
	
	private static function getPool( type:Class<Dynamic> ):Array<Dynamic>
	{
		for (item in pools.keys())
			if ( item == type )
				#if flash
				return untyped pools[item];
				#else
				return pools.get(item);
				#end
		
		#if flash
		untyped pools[type] = [];
		return untyped pools[type];
		#else
		pools.set(type, []);
		return pools.get(type);
		#end
	}
		
	private static function createInstanceByType(type:Class<Dynamic>, parameters:Array<Dynamic>):Dynamic
	{
		return WaterDrop.createInstanceByType(type, parameters);
	}
	
	/**
	 * 获取类实例
	 * @param	type			类
	 * @param	?parameters		带入参数
	 * @return
	 */
	public static function getInstanceByType( type:Class<Dynamic>, ?parameters:Array<Dynamic>):Dynamic
	{
		SystemUtils.print(type+":"+parameters, PrintConst.BASES);
		var pool:Array<Dynamic> = getPool( type );
		SystemUtils.print("pool:"+pool);
		if( pool.length > 0 )
			return pool.pop();
		else
			return createInstanceByType( type, parameters );
	}
	
	/**
	 * 销毁对象
	 * @param	object		待销毁对象
	 * @param	type		对象类型
	 */
	public static function disposeInstance( object:Dynamic, type:Class<Dynamic> = null ):Void
	{
		SystemUtils.print(object + ":" + type, PrintConst.BASES);
		if ( Std.is( object, Array ) ) {
			if ( type == null ) {
				var typeName:String = Type.getClassName(Type.getClass( object[0] ));
				type = Type.resolveClass( typeName );
			}
			
			var pool:Array<Dynamic> = getPool( type ).concat(object);
			while (pool.length >= maxValue)
				pool.shift();
			
			pool.push( object );
		} else {
			if ( type == null ) {
				var typeName:String = Type.getClassName(Type.getClass( object ));
				type = Type.resolveClass( typeName );
			}
			
			var pool:Array<Dynamic> = getPool( type );
			if (pool.length >= maxValue)
				pool.shift();
			
			pool.push( object );
		}
	}
}

class WaterDrop
{
	public static function createInstanceByType(type:Class<Dynamic>, parameters:Array<Dynamic>):Dynamic
	{
		SystemUtils.print("create:"+type, PrintConst.BASES);
		return Type.createInstance(type, parameters!=null?parameters:new Array());
	}
}