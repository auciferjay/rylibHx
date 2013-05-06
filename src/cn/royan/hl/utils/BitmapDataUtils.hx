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
	static public function fromColors(width:Int, height:Int, colors:Array<Dynamic>, alphas:Array<Dynamic>, length:Int = 1):BitmapData
	{
		var bitmapdata:BitmapData = new BitmapData(width * length, height, true, 0x00000000);
		var shape:Shape = new Shape();
		var matrix:Matrix = new Matrix();
		var ratios:Array<Dynamic> = [];
		var len:Float = 0;
		var colorLen:Int = 0;
		
		if ( length == 1 ) {
			if ( Std.is( colors, Array ) ) {
				matrix.createGradientBox(width, height, Math.PI / 2, 0, 0);
				ratios = [];
				colorLen = Std.int(colors.length - 1);
				len = 255 / colorLen;
				for ( i in 0...colorLen ) {
					ratios.push(i * len);
				}
				ratios.push(255);
				
				shape.graphics.beginGradientFill(GradientType.LINEAR, cast(colors), cast(alphas), ratios, matrix);
			}else{
				shape.graphics.beginFill(colors[0], alphas[0]);
			}
			
			shape.graphics.drawRect( 0, 0, width, height );
			shape.graphics.endFill();
		}else {
			for ( i in 0...length ) {
				if ( Std.is( colors[i], Array ) ) {
					matrix.createGradientBox(width, height, Math.PI / 2, 0, 0);
					ratios = [];
					colorLen = Std.int(colors[i].length - 1);
					len = 255 / colorLen;
					for ( i in 0...colorLen ) {
						ratios.push(i * len);
					}
					ratios.push(255);
					
					shape.graphics.beginGradientFill(GradientType.LINEAR, cast(colors[i]), cast(alphas[i]), ratios, matrix);
				}else {
					shape.graphics.beginFill(colors[i], alphas[i]);
				}
				
				shape.graphics.drawRect( width * i, 0, width, height );
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