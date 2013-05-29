package cn.royan.hl.interfaces.uis;

/**
 * ...
 * 基础组项显示接口，继承自基础显示接口
 * <p>IUiItemGroupBase->IUiBase</p>
 * @author RoYan
 */
interface IUiItemGroupBase implements IUiBase
{
	/**
	 * 设置选中
	 * @param	value
	 */
	function setSelected(value:Bool):Void;
	
	/**
	 * 获取选中
	 * @return
	 */
	function getSelected():Bool;
	
	/**
	 * 设置入组
	 * @param	value
	 */
	function setInGroup(value:Bool):Void;
}