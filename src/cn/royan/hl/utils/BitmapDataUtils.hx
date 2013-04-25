package cn.royan.hl.utils;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.Shape;
import flash.geom.Matrix;

/**
 * ...
 * @author RoYan
 */
class BitmapDataUtils
{
	static public function fromColors(width:Int, height:Int, colors:Array<Dynamic>, alphas:Array<Dynamic>):BitmapData
	{
		var bitmapdata:BitmapData = new BitmapData(width, height, true, 0x00000000);
		var shape:Shape = new Shape();
		var matrix:Matrix = new Matrix();
		
		if( colors.length == 1 ){
			matrix.createGradientBox(width, height, Math.PI/2, 0, 0);
			if ( Std.is( colors[0], Array ) ) {
				shape.graphics.beginGradientFill(GradientType.LINEAR, cast(colors[0]), cast(alphas[0]), [0,255], matrix);
			}else{
				shape.graphics.beginFill(colors[0], alphas[0]);
			}
			
			shape.graphics.drawRect( 0, 0, width, height );
			shape.graphics.endFill();
		}else {
			for ( i in 0...colors.length ) {
				matrix.createGradientBox(width / colors.length, height, Math.PI / 2, 0, 0);
				if ( Std.is( colors[i], Array ) ) {
					shape.graphics.beginGradientFill(GradientType.LINEAR, cast(colors[i]), cast(alphas[i]), [0,255], matrix);
				}else {
					shape.graphics.beginFill(colors[i], alphas[i]);
				}
				
				shape.graphics.drawRect( width / colors.length * i, 0, width / colors.length, height );
				shape.graphics.endFill();
			}
		}
		bitmapdata.draw(shape);
		
		return bitmapdata;
	}
	
	static public function fromDisplayObject(displayObject:DisplayObject):BitmapData
	{
		var bitmapdata:BitmapData = new BitmapData(Std.int(displayObject.width), Std.int(displayObject.height), true, 0x00000000);
		bitmapdata.draw(displayObject);
		
		return bitmapdata;
	}
}