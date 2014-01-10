package
{
	import cn.royan.hl.bases.PoolMap;
	import cn.royan.hl.uis.graphs.UiGSprite;
	import cn.royan.hl.uis.graphs.UiGStage;
	import cn.royan.hl.uis.sparrow.Sparrow;
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
		private var sparrow:Sparrow;
		private var sparrow2:Sparrow;
		private var sparrow3:Sparrow;
		private var unit:UiGSprite;
		
		public function StarlingRoot()
		{
			super();
			
			container = new UiGStage(Starling.current.nativeStage);
			
			sparrow = SparrowManager.getAtlas("Fish9").getSparrow("9_01");
			sparrow2 = SparrowManager.getAtlas("Fish8").getSparrow("8_01");
			sparrow3 = SparrowManager.getAtlas("Fish3").getSparrow("3_01");
			var i:int;
			
			for( i = 0; i < 200; i++ ){
				var s:Sparrow;
				switch(i%3){
					case 0:
						s = sparrow;
						break;
					case 1:
						s = sparrow2;
						break;
					case 2:
						s = sparrow3;
						break;
				}
				unit = PoolMap.createInstanceByType(UiGSprite, [s]);
				unit.setTouchable(true);
				unit.setX(Math.random()*1000);
				unit.setY(Math.random()*600);
				container.addChild(unit);
			}
			container.draw()
			bitmap = new Image(Texture.fromBitmapData(container.getSnap(), false));
			addChild(bitmap);
			
//			container.recycle();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		
		private function onEnterFrameHandler(evt:Event):void
		{
			container.draw();
			
			bitmap.texture.base["uploadFromBitmapData"](container.getSnap());
//			container.recycle();
		}
	}
}