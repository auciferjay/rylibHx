package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import cn.royan.hl.bases.PoolMap;
	import cn.royan.hl.uis.graphs.UiGStage;
	import cn.royan.hl.uis.graphs.bases.UiGBmpdMovieClip;
	import cn.royan.hl.uis.sparrow.SparrowManager;
	
	public class NormalRoot extends Sprite
	{
		private var container:UiGStage;
		private var bitmap:Bitmap;
		private var sparrow:Array;
		private var sparrow2:Array;
		private var sparrow3:Array;
		private var unit:UiGBmpdMovieClip;
		
		public function NormalRoot(stage:Stage)
		{
			super();
			
			container = new UiGStage(stage);
			
			sparrow = SparrowManager.getAtlas("Fish9").getSparrows("9_");
			sparrow2 = SparrowManager.getAtlas("Fish8").getSparrows("8_");
			sparrow3 = SparrowManager.getAtlas("Fish3").getSparrows("3_");
			var i:int;
			
			for( i = 0; i < 2; i++ ){
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
				unit.setTouchabled(true);
				unit.setButtonMode(true);
				unit.setPosition(Math.random() * 1000, Math.random()* 600);
				unit.play();
				container.addItem(unit);
			}
			container.draw();
			bitmap = new Bitmap(container.getTexture().bitmapdata);
			addChild(bitmap);
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		
		private function onEnterFrameHandler(evt:Event):void
		{
			container.draw();
			
			bitmap.bitmapData = container.getTexture().bitmapdata;
		}
	}
}