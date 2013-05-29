package cn.royan.hl.interfaces.uis;

/**
 * ...
 * 滚动容器接口，继承自基础显示接口
 * <p>IUiScrollPane->IUiBase</p>
 * @author RoYan
 */
interface IUiScrollPaneBase implements IUiBase
{
	/**
	 * 设置滚动类型
	 * @param	type	SCROLL_TYPE_NONE / SCROLL_TYPE_HORIZONTAL_ONLY / SCROLL_TYPE_VERICAL_ONLY / SCROLL_TYPE_HANDV
	 */
	function setType(type:Int):Void;
	
	/**
	 * 设置Thumb材质
	 * @param	texture
	 */
	function setThumbTexture(texture:Dynamic):Void;
	
	/**
	 * 设置min材质
	 * @param	texture
	 */
	function setMinTexture(texture:Dynamic):Void;
	
	/**
	 * 设置max材质
	 * @param	texture
	 */
	function setMaxTexture(texture:Dynamic):Void;
	
	/**
	 * 设置bg材质
	 * @param	texture
	 */
	function setBackgroundTextrue(texture:Dynamic):Void;
}