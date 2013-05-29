package cn.royan.hl.interfaces.uis;

/**
 * ...
 * 基础组容器接口，继承自基础对齐类容器接口
 * 注销IUiContainerBase中addItem,addItemAt,removeItem,removeItemAt,getItemAt,getIndexByItem,getItems
 * 
 * <p>IUiContainerGroupBase->IUiContainerAlignBase</p>
 * @author RoYan
 */
interface IUiContainerGroupBase implements IUiContainerAlignBase
{
	/**
	 * 添加显示项及健值
	 * @param	item
	 * @param	key
	 */
	function addGroupItem(item:IUiItemGroupBase, key:Dynamic = null):Void;
	
	/**
	 * 添加显示项及健值
	 * @param	item
	 * @param	index
	 * @param	key
	 */
	function addGroupItemAt(item:IUiItemGroupBase, index:Int, key:Dynamic = null):Void;
	
	/**
	 * 移除显示项
	 * @param	item
	 */
	function removeGroupItem(item:IUiItemGroupBase):Void;
	
	/**
	 * 移除显示项
	 * @param	index
	 */
	function removeGroupItemAt(index:Int):Void;
	
	/**
	 * 清空显示项
	 */
	function removeAllGroupItems():Void;
	
	/**
	 * 获取显示项
	 * @param	index
	 * @return
	 */
	function getGroupItemAt(index:Int):IUiItemGroupBase;
	
	/**
	 * 获取显示项索引
	 * @param	item
	 * @return
	 */
	function getIndexByGroupItem(item:IUiItemGroupBase):Int;
	
	/**
	 * 获取显示列表
	 * @return
	 */
	function getGroupItems():Array<IUiItemGroupBase>;
	
	/**
	 * 获取选中显示项
	 * @return
	 */
	function getSelectedItems():Array<IUiItemGroupBase>;
	
	/**
	 * 获取选中值
	 * @return
	 */
	function getValues():Array<Dynamic>;
	
	/**
	 * 设置必选
	 * @param	value
	 */
	function setIsMust(value:Bool):Void;
	
	/**
	 * 设置多选
	 * @param	value
	 */
	function setIsMulti(value:Bool):Void;
	
	/**
	 * 设置多选数
	 * @param	value
	 */
	function setMaxLen(value:Int):Void;
}