package cn.royan.hl.bases;
import cn.royan.hl.utils.SystemUtils;

class PoolMap 
{
	public static var maxValue:Int = 10;
	
	private static var __weakMap:WeakMap = WeakMap.getInstance();
	private static var pools:Dictionary = new Dictionary();
	
	private static function getPool( type:Class<Dynamic> ):Array<Dynamic>
	{
		for ( t in Reflect.fields(pools) ) {
			if ( Type.getClassName(type) == t )
				return Reflect.field(pools, Type.getClassName(type));
		}
		Reflect.setField(pools,Type.getClassName(type),[]);
		return Reflect.field(pools, Type.getClassName(type));
	}
		
	private static function createInstanceByType(type:Class<Dynamic>, parameters:Array<Dynamic>):Dynamic
	{
		var waterDrop:WaterDrop = new WaterDrop(type, parameters);
		__weakMap.set(waterDrop.key, waterDrop.target);
		
		return waterDrop.target;
	}
		
	public static function getInstanceByType( type:Class<Dynamic>, ?parameters:Array<Dynamic>):Dynamic
	{
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
		
	public static function disposeInstance( object:Dynamic, type:Class<Dynamic> = null ):Void
	{
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
		this.type 		= type;
		this.params 	= parameters;
		this.autoKill 	= params!= null?params.length:0;
		this.key 		= type+"|"+autoKill;
		this.target 	= createInstanceByType(type, params);
	}
	
	function createInstanceByType(type:Class<Dynamic>, parameters:Array<Dynamic>):Dynamic
	{
		return Type.createInstance(type, parameters!=null?parameters:[]);
	}
}