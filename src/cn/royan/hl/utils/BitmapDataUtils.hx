package cn.royan.hl.utils;

import cn.royan.hl.consts.PrintConst;
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
	static public function fromColors(width:Int, height:Int, colors:Array<Dynamic>, alphas:Array<Dynamic>, length:Int = 1, border:Int = 0x000000, thick:Int = 0, alpha:Float = 0.0, rx:Int = 0, ry:Int = 0):BitmapData
	{
		SystemUtils.print(width+":"+height+":"+colors+":"+alphas+","+length, PrintConst.UTILS);
		
		var bitmapdata:BitmapData = new BitmapData(width * length, height, true, #if neko {rgb:0,a:0} #else 0x00000000 #end);
		var shape:Shape = new Shape();
		var matrix:Matrix = new Matrix();
		var ratios:Array<Dynamic> = [];
		var len:Float = 0;
		var colorLen:Int = 0;
		
		if ( length == 1 ) {
			if ( Std.is( colors, Array ) ) {
				if ( alpha > 0.0 && thick > 0 ) {
					shape.graphics.lineStyle(thick, border, alpha);
				}
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
			
			shape.graphics.drawRoundRect( 0, 0, width - thick, height - thick, rx, ry );
			shape.graphics.endFill();
		}else {
			for ( i in 0...length ) {
				if ( Std.is( colors[i], Array ) ) {
					if ( alpha > 0.0 && thick > 0 ) {
						shape.graphics.lineStyle(thick, border, alpha);
					}
					
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
				
				shape.graphics.drawRoundRect( width * i, 0, width - thick, height - thick, rx, ry );
				shape.graphics.endFill();
			}
		}
		bitmapdata.draw(shape);
		
		return bitmapdata;
	}
	
	static public function fromDisplayObject(displayObject:DisplayObject):BitmapData
	{
		var bitmapdata:BitmapData = new BitmapData(Std.int(displayObject.width), Std.int(displayObject.height), true, #if neko {rgb:0,a:0} #else 0x00000000 #end);
		bitmapdata.draw(displayObject);
		
		return bitmapdata;
	}
}