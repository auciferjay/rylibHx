package cn.royan.hl.interfaces.uis;

/**
 * ...
 * 滚动条接口， 继承自基础对齐类容器接口
 * <p>IUiScrollBarBase->IUiContainerAlignBase</p>
 * @author RoYan
 */
interface IUiScrollBarBase implements IUiContainerAlignBase
{
	/**
	 * 获取滑动值
	 * @return
	 */
	function getValue():Int;
	
	/**
	 * 设置滑动值
	 * @param	value
	 */
	function setValue(value:Int):Void;
	
	/**
	 * 设置滑动类型
	 * @param	type	SCROLLBAR_TYPE_HORIZONTAL / SCROLLBAR_TYPE_VERICAL
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