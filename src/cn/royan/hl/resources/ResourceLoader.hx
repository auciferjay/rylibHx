package cn.royan.hl.resources;

import cn.royan.hl.bases.Dictionary;
import cn.royan.hl.bases.DispatcherBase;
import cn.royan.hl.bases.WeakMap;
import cn.royan.hl.bases.PoolMap;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.interfaces.IDisposeBase;
import cn.royan.hl.services.TakeService;
import cn.royan.hl.uis.normal.bases.UiNLoader;
import cn.royan.hl.utils.SystemUtils;
import flash.display.DisplayObjectContainer;
import haxe.Timer;

/**
 * ...
 * @author RoYan
 */

class ResourceLoader extends DispatcherBase, implements IDisposeBase
{
		static var __loaderMap:Dictionary = new Dictionary();
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
		
		public function load():Void
		{
			currentPath = moduleKey + ConfigFile.getExtension(configType);
			takeService.sendRequest("xml/"+currentPath);
			takeService.connect();
		}
		
		public function dispose():Void
		{
			PoolMap.disposeInstance(configFile);
			callbacks = null;
		}
		
		public function setConfigType(value:Int):Void
		{
			configType = value;
		}
		
		public function getResourceByPath(path:String):Dynamic
		{
			return __weakMap.getValue(path + uid);
		}
		
		public function setCallbacks(value:Dynamic):Void
		{
			callbacks = value;
		}
		
		public function containerInitComplete():Void
		{
			if( root.contains(loader) ) root.removeChild(loader);
		}
		
		function loaderOnProgressHandler(data: { var loaded:Int; var total:Int; } ):Void
		{
			SystemUtils.print("[Class ResourceLoader]:Loader File OnProgress");
		}
		
		function loaderOnCompleteHandler(data:Dynamic):Void
		{
			SystemUtils.print("[Class ResourceLoader]:Loader File OnComplete");
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
			SystemUtils.print("[Class ResourceLoader]:Loader File OnError");
			if ( callbacks != null && callbacks.error != null ) callbacks.error(message);
		}
		
		function configFileOnProgressHandler(data: { var loaded:Int; var total:Int; } ):Void
		{
			SystemUtils.print("[Class ResourceLoader]:Config File onProgress");
			//if ( callbacks != null && callbacks.doing != null ) callbacks.doing(data);
		}
		
		function configFileOnCompleteHandler(data:Dynamic):Void
		{
			SystemUtils.print("[Class ResourceLoader]:Config File onComplete");
			
			__weakMap.set(currentPath + uid, data);
			
			configFile = PoolMap.getInstanceByType(ConfigFile, [data, configType]);
			
			takeService.dispose();
			
			PoolMap.disposeInstance(takeService);
			
			synFileStartLoadHandler();
		}
		
		function configFileOnErrorHandler(message:String):Void
		{
			SystemUtils.print("[Class ResourceLoader]:Config File OnError");
			if ( callbacks != null && callbacks.error != null ) callbacks.error(message);
		}
		
		function synFileStartLoadHandler():Void
		{
			var synFiles:Array<Dynamic> = cast(Reflect.field(Reflect.field(configFile.getValue(),'DLLS'),'DLL'), Array<Dynamic>);
			if( synFiles != null && synFiles.length > 0 ){
				
				SystemUtils.print("[Class ResourceLoader]:syn File Start");
				
				var currentDll:Dynamic = synFiles.shift();
				currentPath = Reflect.field(currentDll,'path');
				
				if( checkResourceByPath(currentPath) ){
					synFileStartLoadHandler();
					return;
				}
				
				SystemUtils.print("[Class ResourceLoader]:syn File Start:"+currentPath);
				
				takeService = PoolMap.getInstanceByType( TakeService, ["version="+moduleVer] );
				takeService.setCallbacks({done:synFileOnCompleteHandler,
										  doing:synFileOnProgressHandler,
					 					  error:synFileOnErrorHandler});
				takeService.sendRequest(currentPath);
				takeService.connect();
				
			}else{
				SystemUtils.print("[Class ResourceLoader]:syn File OnFinish");
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
			SystemUtils.print("[Class ResourceLoader]:syn File OnComplete");
			
			loader.loaderComplete();
			
			__weakMap.set(currentPath + uid, data);
			
			takeService.dispose();
			PoolMap.disposeInstance(takeService);
			
			Timer.delay(synFileStartLoadHandler, 500);
		}
		
		function synFileOnErrorHandler(message:String):Void
		{
			SystemUtils.print("[Class ResourceLoader]:syn File OnError");
			if ( callbacks != null && callbacks.error != null ) callbacks.error(message);
		}
		
		function asynFileStartLoadHandler():Void
		{
			var asynFiles:Array<Dynamic> = cast(Reflect.field(Reflect.field(configFile.getValue(),'AYSNDLLS'),'DLL'), Array<Dynamic>);
			if( asynFiles != null && asynFiles.length > 0 ){
				SystemUtils.print("[Class ResourceLoader]:asyn File Start");
				
				var currentDll:Dynamic = asynFiles.shift();
				currentPath = Reflect.field(currentDll,'path');
				
				if( checkResourceByPath(currentPath) ){
					asynFileStartLoadHandler();
					return;
				}
				
				SystemUtils.print("[Class ResourceLoader]:asyn File Start:"+currentPath);
				
				takeService = PoolMap.getInstanceByType( TakeService, ["version="+moduleVer] );
				takeService.setCallbacks({done:asynFileOnCompleteHandler,
										  doing:asynFileOnProgressHandler,
										  error:asynFileOnErrorHandler});
				takeService.sendRequest(currentPath);
				takeService.connect();
				
			}else{
				SystemUtils.print("[Class ResourceLoader]:asyn File OnFinish");
				if( callbacks != null && callbacks.done != null ) callbacks.done(this);
			}
		}
		
		function asynFileOnProgressHandler(data: { var loaded:Int; var total:Int; } ):Void
		{
			
		}
		
		function asynFileOnCompleteHandler(data:Dynamic):Void
		{
			SystemUtils.print("[Class ResourceLoader]:asyn File OnComplete");
			
			__weakMap.set(currentPath + uid, data);
			
			takeService.dispose();
			PoolMap.disposeInstance(takeService);
			
			asynFileStartLoadHandler();
		}
		
		function asynFileOnErrorHandler(message:String):Void
		{
			SystemUtils.print("[Class ResourceLoader]:asyn File OnError");
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