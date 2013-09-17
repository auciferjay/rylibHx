package
{
	import cn.royan.hl.bases.PoolMap;
	import cn.royan.hl.uis.graphs.UiGStage;
	import cn.royan.hl.uis.graphs.bases.UiGBmpdMovieClip;
	import cn.royan.hl.uis.sparrow.SparrowManager;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class StarlingRoot extends Sprite
	{
		private var container:UiGStage;
		private var bitmap:Image;
		private var sparrow:Array;
		private var sparrow2:Array;
		private var sparrow3:Array;
		private var unit:UiGBmpdMovieClip;
		
		public function StarlingRoot()
		{
			super();
			
			container = new UiGStage(Starling.current.nativeStage);
			
			sparrow = SparrowManager.getAtlas("Fish9").getSparrows("9_");
			sparrow2 = SparrowManager.getAtlas("Fish8").getSparrows("8_");
			sparrow3 = SparrowManager.getAtlas("Fish3").getSparrows("3_");
			var i:int;
			
			for( i = 0; i < 200; i++ ){
				var s:Array;
				switch(i%3){
					case 0:
						s = sparrow
						break;
					case 1:
						s = sparrow2;
						break;
					case 2:
						s = sparrow3;
						break;
				}
				unit = PoolMap.createInstanceByType(UiGBmpdMovieClip, [s, 12]);
				unit.setPosition(Math.random() * 1000, Math.random()* 600);
				unit.play();
				container.addItem(unit);
			}
			container.draw();
			bitmap = new Image(Texture.fromBitmapData(container.getTexture().bitmapdata, false));
			addChild(bitmap);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		
		private function onEnterFrameHandler(evt:Event):void
		{
			container.draw();
			
			bitmap.texture.base["uploadFromBitmapData"](container.getTexture().bitmapdata);
		}
	}
}