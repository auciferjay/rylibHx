package cn.royan.hl.uis.graphs;

import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.geom.Range;
import cn.royan.hl.interfaces.uis.IUiGraphBase;
import cn.royan.hl.uis.sparrow.Sparrow;
import cn.royan.hl.uis.style.Style;
import cn.royan.hl.utils.BitmapDataUtils;
import cn.royan.hl.utils.SystemUtils;

import flash.geom.Rectangle;

/**
 * ...
 * @author RoYan
 */
class InteractiveUiG implements IUiGraphBase
{
	var bounds:Rectangle;
	
	var updated:Bool;
	var parent:IUiGraphBase;
	
	var range:Range;
	
	var bgColors:Array<Dynamic>;
	var bgAlphas:Array<Dynamic>;
	
	var borderThick:Int;
	var borderColor:Int;
	var borderAlpha:Float;
	var borderRx:Int;
	var borderRy:Int;
	
	var containerWidth:Int;
	var containerHeight:Int;
	
	var positionX:Float;
	var positionY:Float;
	
	var scaleX:Float;
	var scaleY:Float;
	var rotation:Float;
	var alpha:Float;
	var visible:Bool;
	
	var bgTexture:Sparrow;
	
	var excludes:Array<String>;
	var includes:Array<String>;
	
	var callbacks:Dynamic;
	
	public function new(texture:Sparrow = null)
	{
		visible = true;
		
		containerHeight = 0;
		containerWidth 	= 0;
		
		positionX = 0;
		positionY = 0;
		
		range = { };
		
		bounds = new Rectangle();
		
		if ( texture != null ) {
			bgTexture = texture;
			setSize(Std.int(bgTexture.regin.width), Std.int(bgTexture.regin.height));
		}
	}
	
	/**
	 * 设置父容器
	 * @param	value
	 */
	public function setParent(value:IUiGraphBase):Void
	{
		parent = value;
	}
	
	/**
	 * 更新显示
	 */
	public function updateDisplayList():Void
	{
		updated = true;
		
		if ( parent != null ) {
			parent.updateDisplayList();
		}
	}
	
	/**
	 * 画布刷新
	 */
	public function draw():Void
	{
		bgTexture = Sparrow.fromBitmapData( BitmapDataUtils.fromColors(Std.int(containerWidth), Std.int(containerHeight), 
											bgColors, bgAlphas, 1, borderColor, borderThick, borderAlpha, borderRx, borderRy) );
											
		updated = false;
	}
	
	/**
	 * 设置毁掉函数
	 * @param	value {click:..., up:..., down:..., over:..., out:...}
	 */
	public function setCallbacks(value:Dynamic):Void
	{
		callbacks = value;
	}
	
	/**
	 * 设置背景颜色以及对应透明度
	 * @param	color 	[0xFFFFFF, 0xFFFF00, 0xFF0000]/[[0xFFFFFF, 0xFFFF00, 0xFF0000],[0xFFFFFF, 0xFFFF00, 0xFF0000]]
	 * @param	alpha 	[1, .5, 0]/[[1, .5, 0],[1, .5, 0]]
	 */
	public function setColorsAndAplhas(color:Array<Dynamic>, alpha:Array<Dynamic>):Void
	{
		SystemUtils.print(color+":"+alpha, PrintConst.UIS);
		bgColors = color;
		bgAlphas = alpha;
		
		while ( bgAlphas.length < bgColors.length ) {
			bgAlphas.push(bgAlphas[bgAlphas.length - 1]);
		}
		
		while ( bgColors.length < bgAlphas.length ) {
			bgColors.push(bgColors[bgColors.length - 1]);
		}
		
		updateDisplayList();
	}
	
	/**
	 * 获取背景颜色
	 * @return [0xFFFFFF, 0xFFFF00, 0xFF0000]/[[0xFFFFFF, 0xFFFF00, 0xFF0000],[0xFFFFFF, 0xFFFF00, 0xFF0000]]
	 */
	public function getColors():Array<Dynamic>
	{
		return bgColors;
	}
	
	/**
	 * 获取背景透明度
	 * @return [1, .5, 0]/[[1, .5, 0],[1, .5, 0]]
	 */
	public function getAlphas():Array<Dynamic>
	{
		return bgAlphas;
	}
	
	/**
	 * 设置边框样式
	 * @param	thick 	粗细度
	 * @param	color 	颜色值
	 * @param	alpha 	透明度
	 * @param	rx		x轴半径
	 * @param	ry		y轴半径
	 */
	public function setBorder(thick:Int, color:Int, alpha:Float, rx:Int = 0, ry:Int = 0):Void
	{
		borderThick = thick;
		borderColor = color;
		borderAlpha = alpha;
		borderRx	= rx;
		borderRy 	= ry;
		
		updateDisplayList();
	}
	
	/**
	 * 设置尺寸
	 * @param	cWidth
	 * @param	cHeight
	 */
	public function setSize(cWidth:Float, cHeight:Float):Void
	{
		containerWidth 	= Std.int(cWidth);
		containerHeight = Std.int(cHeight);
		
		range.width = cWidth;
		range.height = cHeight;
		
		bounds.width = cWidth;
		bounds.height = cHeight;
		
		updateDisplayList();
	}
	
	/**
	 * 设置位置
	 * @param	cX
	 * @param	cY
	 */
	public function setPosition(cX:Float, cY:Float):Void
	{
		positionX = cast Math.floor(cX);
		positionY = cast Math.floor(cY);
		
		range.x = cX;
		range.y = cY;
		
		bounds.x = cX;
		bounds.y = cY;
	}
	
	/**
	 * 设置范围
	 * @param	value	{width:..., height:..., x:..., y:...}
	 */
	public function setRange(value:Range):Void
	{
		setSize(cast(value.width), cast(value.height));
		setPosition(cast(value.x), cast(value.y));
	}
	
	/**
	 * 获取范围
	 * @return	{width:..., height:..., x:..., y:...}
	 */
	public function getRange():Range
	{
		return range;
	}
	
	/**
	 * 获取感应范围
	 * @return
	 */
	public function getBounds():Rectangle
	{
		return bounds;
	}
	
	/**
	 * 设置材质
	 * @param	texture		Sparrow/Texture(Starling)
	 * @param	frames
	 */
	public function setTexture(texture:Dynamic, frames:Int = 1):Void
	{
		bgTexture = texture;
		
		setSize(Std.int(bgTexture.regin.width), Std.int(bgTexture.regin.height));
	}
	
	/**
	 * 获取当前材质
	 * @return
	 */
	public function getTexture():Dynamic
	{
		return bgTexture;
	}
	
	/**
	 * 设置X缩放比例
	 * @param	value
	 */
	public function setScaleX(value:Float):Void
	{
		scaleX = value;
		
		updateDisplayList();
	}
	
	/**
	 * 获取X缩放比列
	 * @return
	 */
	public function getScaleX():Float
	{
		return scaleX;
	}
	
	/**
	 * 设置X缩放比例
	 * @param	value
	 */
	public function setScaleY(value:Float):Void
	{
		scaleY = value;
		
		updateDisplayList();
	}
	
	/**
	 * 获取X缩放比列
	 * @return
	 */
	public function getScaleY():Float
	{
		return scaleY;
	}
	
	/**
	 * 设置角度
	 * @param	value
	 */
	public function setRotation(value:Float):Void
	{
		rotation = value;
		
		updateDisplayList();
	}
	
	/**
	 * 获取角度
	 * @return
	 */
	public function getRotation():Float
	{
		return rotation;
	}
	
	/**
	 * 设置透明度
	 * @param	value
	 */
	public function setTotalAlpha(value:Float):Void
	{
		alpha = value;
		
		updateDisplayList();
	}
	
	/**
	 * 获取透明度
	 * @return
	 */
	public function getTotalAlpha():Float
	{
		return alpha;
	}
	
	/**
	 * 设置显示
	 * @param	value
	 */
	public function setVisible(value:Bool):Void
	{
		visible = value;
	}
	
	/**
	 * 过去显示
	 * @return
	 */
	public function getVisible():Bool
	{
		return visible;
	}
	
	/**
	 * 设置样式名称
	 * @param 	value
	 */
	public function setStyle(value:Style):Void
	{
		
	}
	
	/**
	 * 设置容器状态对应隐藏列表
	 * @param	args
	 */
	public function setExclude(args:Array<String>):Void
	{
		excludes = args;
	}
	
	/**
	 * 获取容器状态对应隐藏列表
	 * @return
	 */
	public function getExclude():Array<String>
	{
		return excludes;
	}
	
	/**
	 * 设置容器状态对应显示列表
	 * @param	args
	 */
	public function setInclude(args:Array<String>):Void
	{
		includes = args;
	}
	
	/**
	 * 获取容器状态对应显示列表
	 * @return
	 */
	public function getInclude():Array<String>
	{
		return includes;
	}
	
	/**
	 * 销毁
	 */
	public function dispose():Void
	{
		if ( bgTexture != null )
			bgTexture.dispose();
	}
}