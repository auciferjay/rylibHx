package
{
	import flash.display.Sprite;
	import cn.royan.hl.uis.sparrow.SparrowManager;
	
	[SWF(backgroundColor='0x000c1d', width="1000", height="600", frameRate="60")]
	public class rylibHxTest extends Sprite
	{
		[Embed(source="enters.png")]
		public static const AtlasTextureFish:Class;
		
		[Embed(source="enters.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlFish:Class;
		
		[Embed(source="0-21.png")]
		public static const AtlasTextureFish2:Class;
		
		[Embed(source="0-21.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlFish2:Class;
		
		public function rylibHxTest()
		{
			SparrowManager.setAtlas("Fish9", new AtlasTextureFish(), Xml.parse(new AtlasXmlFish));
			SparrowManager.setAtlas("Fish1", new AtlasTextureFish2(), Xml.parse(new AtlasXmlFish2));
			
			startNormal();
		}
		
		private function startNormal():void
		{
			// TODO Auto Generated method stub
			addChild(new NormalRoot(stage));
		}
	}
}