package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import cn.royan.hl.bases.PoolMap;
	import cn.royan.hl.uis.graphs.UiGMovieClip;
	import cn.royan.hl.uis.graphs.UiGSprite;
	import cn.royan.hl.uis.graphs.UiGStage;
	import cn.royan.hl.uis.sparrow.Sparrow;
	import cn.royan.hl.uis.sparrow.SparrowManager;
	
	public class NormalRoot extends Sprite
	{
		private var container:UiGStage;
		private var bitmap:Bitmap;
		private var sparrow1:Array;
		private var sparrow2:Array;
		private var sparrow3:Array;
		private var unit:UiGMovieClip;
		
		public function NormalRoot(stage:Stage)
		{
			super();
			
			container = new UiGStage(stage);
			
			sparrow1 = SparrowManager.getAtlas("Fish1").getSparrows("8_");
			sparrow2 = SparrowManager.getAtlas("Fish1").getSparrows("0_");
			sparrow3 = SparrowManager.getAtlas("Fish1").getSparrows("9_");
			
			var i:int;
			
			var root:UiGSprite = new UiGSprite();
			container.addChild(root);
			for( i = 0; i < 100; i++ ){
				var s:Array;
				switch(i%3){
					case 0:
						s = sparrow1;
						break;
					case 1:
						s = sparrow2;
						break;
					case 2:
						s = sparrow3;
						break;
				}
				unit = PoolMap.createInstanceByType(UiGMovieClip, [s,12]);
//				unit.setTouchable(true);
				unit.setX(Math.random()*1000);
				unit.setY(Math.random()*600);
				//unit.play();
				root.addChild(unit);
			}
			
			container.draw();
			bitmap = new Bitmap(container.getSnap());
			addChild(bitmap);
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		
		private function onEnterFrameHandler(evt:Event):void
		{
			container.draw();
			bitmap.bitmapData = container.getSnap();
			//container.recycle();
		}
	}
}