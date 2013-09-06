package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setInterval;
	
	import cn.royan.hl.bases.PoolMap;
	import cn.royan.hl.consts.PrintConst;
	import cn.royan.hl.uis.graphs.UiGStage;
	import cn.royan.hl.uis.graphs.bases.UiGBmpdMovieClip;
	import cn.royan.hl.uis.sparrow.SparrowManager;
	import cn.royan.hl.utils.SystemUtils;
	
	[SWF(backgroundColor='0x000c1d', width="1000", height="600")]
	public class rylibHxTest extends Sprite
	{
		private var container:UiGStage;
		private var bitmap:Bitmap;
		private var sparrow:Array;
		private var unit:UiGBmpdMovieClip;
		
		[Embed(source="fish_9.png")]
		public static const AtlasTextureFish:Class;
		
		[Embed(source="fish_9.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlFish:Class;
		
		public function rylibHxTest()
		{
			SystemUtils.showDebug = PrintConst.UIS
			
			container = new UiGStage(stage);
			
			SparrowManager.setAtlas("Fish", new AtlasTextureFish(), Xml.parse(new AtlasXmlFish));
			sparrow = SparrowManager.getAtlas("Fish").getSparrows("9_");
			var i:int;
			
			for( i = 0; i < 100; i++ ){
				unit = PoolMap.createInstanceByType(UiGBmpdMovieClip, [sparrow, 12]);
				unit.setPosition(Math.random() * 1000, Math.random()* 600);
				unit.play();
				container.addItem(unit);
			}
			container.draw();
			bitmap = new Bitmap(container.getTexture().bitmapdata);
			addChild(bitmap);
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			
//			setInterval(onEnterFrameHandler, 100);
		}
		
		private function onEnterFrameHandler(evt:Event):void
		{
			container.draw();
			
			bitmap.bitmapData = container.getTexture().bitmapdata;
		}
	}
}