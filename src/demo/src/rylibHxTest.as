package
{
	import flash.display.Sprite;
	
	import cn.royan.hl.consts.PrintConst;
	import cn.royan.hl.uis.sparrow.SparrowManager;
	import cn.royan.hl.utils.SystemUtils;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	[SWF(backgroundColor='0x000c1d', width="1000", height="600")]
	public class rylibHxTest extends Sprite
	{
		[Embed(source="fish_9.png")]
		public static const AtlasTextureFish:Class;
		
		[Embed(source="fish_9.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlFish:Class;
		
		[Embed(source="fish_8.png")]
		public static const AtlasTextureFish2:Class;
		
		[Embed(source="fish_8.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlFish2:Class;
		
		[Embed(source="fish_3.png")]
		public static const AtlasTextureFish3:Class;
		
		[Embed(source="fish_3.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlFish3:Class;
		
		public static var test:TextureAtlas;
		public static var test2:TextureAtlas;
		public static var test3:TextureAtlas;
		
		private var myStarling:Starling;
		
		public function rylibHxTest()
		{
			SystemUtils.showDebug = PrintConst.UIS;
			
			SparrowManager.setAtlas("Fish9", new AtlasTextureFish(), Xml.parse(new AtlasXmlFish));
			SparrowManager.setAtlas("Fish8", new AtlasTextureFish2(), Xml.parse(new AtlasXmlFish2));
			SparrowManager.setAtlas("Fish3", new AtlasTextureFish3(), Xml.parse(new AtlasXmlFish3));
			
//			startStarling();
			
//			startPure();
			
			startNormal();
		}
		
		private function startPure():void
		{
			// TODO Auto Generated method stub
			myStarling = new Starling(PureRoot, stage);
			myStarling.addEventListener("rootCreated", rootCreated);
			myStarling.start();
		}
		
		private function rootCreated(evt:Event):void
		{
			test = new TextureAtlas(Texture.fromBitmap(new AtlasTextureFish()), XML(new AtlasXmlFish));
			test2 = new TextureAtlas(Texture.fromBitmap(new AtlasTextureFish2()), XML(new AtlasXmlFish2));
			test3 = new TextureAtlas(Texture.fromBitmap(new AtlasTextureFish3()), XML(new AtlasXmlFish3));
			
			PureRoot(myStarling.root).start();
		}
		
		private function startNormal():void
		{
			// TODO Auto Generated method stub
			addChild(new NormalRoot(stage));
		}
		
		private function startStarling():void
		{
			// TODO Auto Generated method stub
			var myStarling:Starling = new Starling(StarlingRoot, stage);
				myStarling.start()
		}
	}
}