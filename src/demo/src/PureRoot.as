package
{
	import cn.royan.hl.bases.PoolMap;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class PureRoot extends Sprite
	{
		public function PureRoot()
		{
			super();
			
			
		}
		
		public function start():void
		{
			var unit:MovieClip
			var i:int;
			for( i = 0; i < 200; i++ ){
				var s:Vector.<Texture>;
				switch(i%3){
					case 0:
						s = rylibHxTest.test.getTextures("9_")
						break;
					case 1:
						s = rylibHxTest.test2.getTextures("8_");
						break;
					case 2:
						s = rylibHxTest.test3.getTextures("3_");
						break;
				}
				unit = PoolMap.createInstanceByType(MovieClip, [s, 12]);
				unit.x = Math.random() * 1000;
				unit.y = Math.random()* 600;
				unit.play();
				addChild(unit);
				
				Starling.juggler.add(unit);
			}
		}
	}
}