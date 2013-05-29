package cn.royan.hl.interfaces.uis;

/**
 * ...
 * 基础对齐类容器接口，继承自基础类容器接口
 * <p>IUiContainerAlignBase->IUiContainerBase</p>
 * @author RoYan
 */
interface IUiContainerAlignBase implements IUiContainerBase
{
	/**
	 * 设置水平对齐方式
	 * @param	value 	CONTAINER_HORIZONTAL_LEFT / CONTAINER_HORIZONTAL_CENTER / CONTAINER_HORIZONTAL_RIGHT
	 */
	function setHorizontalAlign(value:Int):Void;
	
	/**
	 * 设置垂直对齐方式
	 * @param	value	CONTAINER_VERTICAL_TOP / CONTAINER_VERTICAL_MIDDLE / CONTAINER_VERTICAL_BOTTOM
	 */
	function setVerticalAlign(value:Int):Void;
	
	/**
	 * 设置内容对齐方式
	 * @param	value	CONTAINER_CONTENT_ALIGN_TOP / CONTAINER_CONTENT_ALIGN_MIDDLE / CONTAINER_CONTENT_ALIGN_BOTTOM
	 */
	function setContentAlign(value:Int):Void;
	
	/**
	 * 设置水平及垂直方向间隔
	 * @param	gapX
	 * @param	gapY
	 */
	function setGaps(gapX:Int, gapY:Int):Void;
	
	/**
	 * 设置显示列表与边框的间距
	 * @param	left
	 * @param	top
	 * @param	right
	 * @param	bottom
	 */
	function setMargins(left:Int, top:Int, right:Int, bottom:Int):Void;
	
	/**
	 * 设置调整显示项位置时执行执行函数
	 * @param	effect		function effect(item:IUiBase):Void
	 */
	function setMove(effect:Dynamic->Void):Void;
}