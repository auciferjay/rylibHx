package cn.royan.hl.bases;

import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.utils.SystemUtils;

/**
 * ...
 * 对象池类
 * @author RoYan
 */
class PoolMap 
{
	public static var maxValue:Int = 10;
	
	private static var __weakMap:WeakMap = WeakMap.getInstance();
	private static var pools:Dictionary = #if flash new Dictionary(); #else {}; #end
	
	private static function getPool( type:Class<Dynamic> ):Array<Dynamic>
	{
		SystemUtils.print(type, PrintConst.BASES);
		for ( t in Reflect.fields(pools) ) {
			if ( Type.getClassName(type) == t )
				return Reflect.field(pools, Type.getClassName(type));
		}
		Reflect.setField(pools,Type.getClassName(type),[]);
		return Reflect.field(pools, Type.getClassName(type));
	}
		
	private static function createInstanceByType(type:Class<Dynamic>, parameters:Array<Dynamic>):Dynamic
	{
		SystemUtils.print(type+":"+parameters, PrintConst.BASES);
		var waterDrop:WaterDrop = new WaterDrop(type, parameters);
		if ( __weakMap.getValue(waterDrop.key) == null ) {
			__weakMap.set(waterDrop.key, waterDrop.target);
			return waterDrop.target;
		}
		return __weakMap.getValue(waterDrop.key);
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
		if ( parameters != null ) {
			if( parameters.length == 1 && Std.is(parameters[0], Array) )
				return createInstanceByType( type, parameters[0] );
			if( parameters.length > 0 )
				return createInstanceByType( type, parameters );
		} else {
			var pool:Array<Dynamic> = getPool( type );
			if( pool.length > 0 )
				return pool.pop();
			else
				return createInstanceByType( type, parameters );
		}
		return null;
	}
	
	/**
	 * 销毁对象
	 * @param	object		待销毁对象
	 * @param	type		对象类型
	 */
	public static function disposeInstance( object:Dynamic, type:Class<Dynamic> = null ):Void
	{
		SystemUtils.print(object+":"+type, PrintConst.BASES);
		if ( type == null ) {
			var typeName:String = Type.getClassName(Type.getClass( object ));
			type = Type.resolveClass( typeName );
		}
		
		var keys:Array<Dynamic> = __weakMap.getKeys(object);
		var pool:Array<Dynamic>;
		
		if ( keys == null ) keys = [];
		
		if( keys.length > 1 || keys.length == 0){
			pool = getPool( type );
			if (pool.length >= maxValue)
				pool.shift();
			
			pool.push( object );
		}else{
			var params:Array<String> = Std.string(keys[0]).split("|");
			if( params[params.length - 1] != "0" ){
				__weakMap.clear(keys[0]);
				object = null;
			}else{
				pool = getPool( type );
				if(pool.length >= maxValue)
					pool.shift();
				
				pool.push( object );
			}
		}
	}
}

class WaterDrop
{
	public var target:Dynamic;
	public var type:Class<Dynamic>;
	public var params:Array<Dynamic>;
	public var key:String;
	public var autoKill:Int;
	
	public function new(type:Class<Dynamic>, parameters:Array<Dynamic>)
	{
		SystemUtils.print(type+":"+parameters, PrintConst.BASES);
		this.type 		= type;
		this.params 	= parameters;
		this.autoKill 	= params!= null?params.length:0;
		this.key 		= type+"|"+autoKill;
		this.target 	= createInstanceByType(type, params);
	}
	
	function createInstanceByType(type:Class<Dynamic>, parameters:Array<Dynamic>):Dynamic
	{
		SystemUtils.print(type+":"+parameters, PrintConst.BASES);
		return Type.createInstance(type, parameters!=null?parameters:[]);
	}
}