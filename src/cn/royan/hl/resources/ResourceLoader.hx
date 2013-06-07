package cn.royan.hl.resources;

import cn.royan.hl.bases.Dictionary;
import cn.royan.hl.bases.DispatcherBase;
import cn.royan.hl.bases.WeakMap;
import cn.royan.hl.bases.PoolMap;
import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.interfaces.IDisposeBase;
import cn.royan.hl.services.TakeService;
import cn.royan.hl.uis.normal.bases.UiNLoader;
import cn.royan.hl.utils.SystemUtils;

import flash.display.DisplayObjectContainer;

import haxe.Timer;

/**
 * ...
 * 资源导入类
 * @author RoYan
 */
class ResourceLoader extends DispatcherBase, implements IDisposeBase
{
		static var __loaderMap:Dictionary = #if flash new Dictionary(); #else {}; #end
		static var __weakMap:WeakMap = WeakMap.getInstance();
		
		var uid:String;
		
		var moduleKey:String;
		var moduleVer:String;
		
		var configType:Int;
		var configFile:ConfigFile;
		var takeService:TakeService;
		var currentPath:String;
		
		var callbacks:Dynamic;
		
		var root:DisplayObjectContainer;
		var loader:UiNLoader;
		
		/**
		 * 创建单例
		 * @param	key			配置文件名
		 * @param	container	容器
		 * @param	version		版本
		 * @param	type		配置文件类型
		 * @return
		 */
		public static function getInstance(key:String, container:DisplayObjectContainer, version:String="1.0", type:Int = ConfigFile.CONFIG_FILE_TYPE_XML):ResourceLoader
		{
			if( Reflect.field(__loaderMap,key) == null )
			{
				Reflect.setField(__loaderMap, key, new ResourceLoader(key, container, version, type));
			}
			return Reflect.field(__loaderMap,key);
		}
		
		function new(key:String, container:DisplayObjectContainer, version:String, type:Int)
		{
			super();
			
			uid = SystemUtils.createUniqueID();
			
			root = container;
			
			moduleKey = key;
			moduleVer = version;
			
			setConfigType(type);
			
			#if flash
			currentPath = "component/loadinglibs.swf";
			
			takeService = PoolMap.getInstanceByType( TakeService, ["version="+moduleVer] );
			takeService.setCallbacks({done:loaderOnCompleteHandler,
									  doing:loaderOnProgressHandler,
									  error:loaderOnErrorHandler } );
			takeService.sendRequest(currentPath);
			takeService.connect();
			#else
			loaderOnCompleteHandler(null);
			#end
		}
		
		/**
		 * 开始加载
		 */
		public function load():Void
		{
			currentPath = moduleKey + ConfigFile.getExtension(configType);
			takeService.sendRequest("xml/"+currentPath);
			takeService.connect();
		}
		
		/**
		 * 销毁
		 */
		public function dispose():Void
		{
			PoolMap.disposeInstance(configFile);
			callbacks = null;
		}
		
		/**
		 * 设置配置文件类型
		 * @param	value
		 */
		public function setConfigType(value:Int):Void
		{
			configType = value;
		}
		
		/**
		 * 获取配置信息
		 * @return
		 */
		public function getConfigFile():ConfigFile
		{
			return configFile;
		}
		
		/**
		 * 获取资源
		 * @param	path	资源路径
		 * @return
		 */
		public function getResourceByPath(path:String):Dynamic
		{
			return __weakMap.getValue(path + uid);
		}
		
		/**
		 * 设置回调函数
		 * @param	value
		 */
		public function setCallbacks(value:Dynamic):Void
		{
			callbacks = value;
		}
		
		/**
		 * 额外内容完成
		 */
		public function extraComplete():Void
		{
			loader.loaderComplete();
		}
		
		/**
		 * 内部初始化完成（删除加载动画）
		 */
		public function containerInitComplete():Void
		{
			if( root.contains(loader) ) root.removeChild(loader);
		}
		
		function loaderOnProgressHandler(data: { var loaded:Int; var total:Int; } ):Void
		{
			SystemUtils.print("[Class ResourceLoader]:Loader File OnProgress", PrintConst.RESOURCES);
		}
		
		function loaderOnCompleteHandler(data:Dynamic):Void
		{
			SystemUtils.print("[Class ResourceLoader]:Loader File OnComplete:"+ currentPath +":"+ uid, PrintConst.RESOURCES);
			__weakMap.set(currentPath + uid, data);
			
			#if flash
			takeService.dispose();
			PoolMap.disposeInstance(takeService);
			
			loader = cast(SystemUtils.getInstanceByClassName("LoaderClass"), UiNLoader);
			#else
			loader = new UiNLoader();
			#end
			loader.addEventListener(DatasEvent.DATA_DONE, loaderAnimationCompleteHandler);
			
			root.addChild( loader );
			
			takeService = PoolMap.getInstanceByType( TakeService, ["version="+moduleVer] );
			takeService.setCallbacks({done:configFileOnCompleteHandler,
									  doing:configFileOnProgressHandler,
									  error:configFileOnErrorHandler } );
			#if flash
			load();
			#end
		}
		
		function loaderAnimationCompleteHandler(evt:DatasEvent):Void
		{
			if( root.contains(loader) ) root.removeChild(loader);
		}
		
		function loaderOnErrorHandler(message:String):Void
		{
			SystemUtils.print("[Class ResourceLoader]:Loader File OnError", PrintConst.RESOURCES);
			if ( callbacks != null && callbacks.error != null ) callbacks.error(message);
		}
		
		function configFileOnProgressHandler(data: { var loaded:Int; var total:Int; } ):Void
		{
			SystemUtils.print("[Class ResourceLoader]:Config File onProgress", PrintConst.RESOURCES);
			//if ( callbacks != null && callbacks.doing != null ) callbacks.doing(data);
		}
		
		function configFileOnCompleteHandler(data:Dynamic):Void
		{
			SystemUtils.print("[Class ResourceLoader]:Config File onComplete", PrintConst.RESOURCES);
			
			__weakMap.set(currentPath + uid, data);
			
			configFile = PoolMap.getInstanceByType(ConfigFile, [data, configType]);
			
			takeService.dispose();
			
			PoolMap.disposeInstance(takeService);
			
			synFileStartLoadHandler();
		}
		
		function configFileOnErrorHandler(message:String):Void
		{
			SystemUtils.print("[Class ResourceLoader]:Config File OnError", PrintConst.RESOURCES);
			if ( callbacks != null && callbacks.error != null ) callbacks.error(message);
		}
		
		function synFileStartLoadHandler():Void
		{
			var synFiles:Array<Dynamic> = cast(Reflect.field(Reflect.field(configFile.getValue(),'DLLS'),'DLL'), Array<Dynamic>);
			if( synFiles != null && synFiles.length > 0 ){
				
				SystemUtils.print("[Class ResourceLoader]:syn File Start", PrintConst.RESOURCES);
				
				var currentDll:Dynamic = synFiles.shift();
				currentPath = Reflect.field(currentDll,'path');
				
				if( checkResourceByPath(currentPath) ){
					synFileStartLoadHandler();
					return;
				}
				
				SystemUtils.print("[Class ResourceLoader]:syn File Start:"+currentPath, PrintConst.RESOURCES);
				
				takeService = PoolMap.getInstanceByType( TakeService, ["version="+moduleVer] );
				takeService.setCallbacks({done:synFileOnCompleteHandler,
										  doing:synFileOnProgressHandler,
					 					  error:synFileOnErrorHandler});
				takeService.sendRequest(currentPath);
				takeService.connect();
				
			}else{
				SystemUtils.print("[Class ResourceLoader]:syn File OnFinish", PrintConst.RESOURCES);
				if( callbacks != null && callbacks.doing != null )callbacks.doing(this);
				asynFileStartLoadHandler();	
				return;
			}
		}
		
		function synFileOnProgressHandler(data: { var loaded:Int; var total:Int; } ):Void
		{
			loader.loaderProgress(data);
		}
		
		function synFileOnCompleteHandler(data:Dynamic):Void
		{
			SystemUtils.print("[Class ResourceLoader]:syn File OnComplete", PrintConst.RESOURCES);
			
			loader.loaderComplete();
			
			__weakMap.set(currentPath + uid, data);
			
			takeService.dispose();
			PoolMap.disposeInstance(takeService);
			
			Timer.delay(synFileStartLoadHandler, 500);
		}
		
		function synFileOnErrorHandler(message:String):Void
		{
			SystemUtils.print("[Class ResourceLoader]:syn File OnError", PrintConst.RESOURCES);
			if ( callbacks != null && callbacks.error != null ) callbacks.error(message);
		}
		
		function asynFileStartLoadHandler():Void
		{
			var asynFiles:Array<Dynamic> = cast(Reflect.field(Reflect.field(configFile.getValue(),'AYSNDLLS'),'DLL'), Array<Dynamic>);
			if( asynFiles != null && asynFiles.length > 0 ){
				SystemUtils.print("[Class ResourceLoader]:asyn File Start", PrintConst.RESOURCES);
				
				var currentDll:Dynamic = asynFiles.shift();
				currentPath = Reflect.field(currentDll,'path');
				
				if( checkResourceByPath(currentPath) ){
					asynFileStartLoadHandler();
					return;
				}
				
				SystemUtils.print("[Class ResourceLoader]:asyn File Start:"+currentPath, PrintConst.RESOURCES);
				
				takeService = PoolMap.getInstanceByType( TakeService, ["version="+moduleVer] );
				takeService.setCallbacks({done:asynFileOnCompleteHandler,
										  doing:asynFileOnProgressHandler,
										  error:asynFileOnErrorHandler});
				takeService.sendRequest(currentPath);
				takeService.connect();
				
			}else{
				SystemUtils.print("[Class ResourceLoader]:asyn File OnFinish", PrintConst.RESOURCES);
				if( callbacks != null && callbacks.done != null ) callbacks.done(this);
			}
		}
		
		function asynFileOnProgressHandler(data: { var loaded:Int; var total:Int; } ):Void
		{
			
		}
		
		function asynFileOnCompleteHandler(data:Dynamic):Void
		{
			SystemUtils.print("[Class ResourceLoader]:asyn File OnComplete", PrintConst.RESOURCES);
			
			__weakMap.set(currentPath + uid, data);
			
			takeService.dispose();
			PoolMap.disposeInstance(takeService);
			
			asynFileStartLoadHandler();
		}
		
		function asynFileOnErrorHandler(message:String):Void
		{
			SystemUtils.print("[Class ResourceLoader]:asyn File OnError", PrintConst.RESOURCES);
		}
		
		function checkResourceByPath(path:String):Bool
		{
			for( key in Reflect.fields(__loaderMap) )
			{
				if( cast(Reflect.field(__loaderMap,key), ResourceLoader).getResourceByPath(path) != null ){
					return true;
					break;
				}
			}
			return false;
		}
}