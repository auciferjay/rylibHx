package cn.royan.hl.interfaces.uis;

/**
 * ...
 * 基础容器接口，所有容器类继承此接口，继承自基础显示接口
 * <p>IUiContainerBase->IUiBase</p>
 * @author RoYan
 */
interface IUiContainerBase implements IUiBase
{
	/**
	 * 添加显示项
	 * @param	item
	 */
	function addItem(item:IUiBase):Void;
	
	/**
	 * 添加显示项
	 * @param	item
	 * @param	index
	 */
	function addItemAt(item:IUiBase, index:Int):Void;
	
	/**
	 * 移除显示想
	 * @param	item
	 */
	function removeItem(item:IUiBase):Void;
	
	/**
	 * 移除显示项
	 * @param	index
	 */
	function removeItemAt(index:Int):Void;
	
	/**
	 * 清空显示项
	 */
	function removeAllItems():Void;
	
	/**
	 * 获取显示项
	 * @param	index
	 * @return
	 */
	function getItemAt(index:Int):IUiBase;
	
	/**
	 * 获取显示项索引
	 * @param	item
	 * @return
	 */
	function getIndexByItem(item:IUiBase):Int;
	
	/**
	 * 获取显示列表
	 * @return
	 */
	function getItems():Array<IUiBase>;
	
	/**
	 * 设置添加显示项时执行函数
	 * @param	effect		function effect(item:IUiBase):Void
	 */
	function setShow(effect:Dynamic->Void):Void;
	
	/**
	 * 设置容器当前状态
	 * @param	value
	 */
	function setState(value:String):Void;
	
	/**
	 * 获取容器当前状态
	 * @return
	 */
	function getState():String;
	
	/**
	 * 设置移除显示项时执行函数, effect中callback方法必须被执行
	 * @param	effect 		function effect(item:IUiBase, callback:Void->Void):Void
	 */
	function setHide(effect:Dynamic->Dynamic->Void):Void;
}