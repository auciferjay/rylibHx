package cn.royan.hl.interfaces.uis;

/**
 * ...
 * 基础可播放显示接口，继承自基础显示接口
 * <p>IUiItemPlayBase->IUiBase</p>
 * @author RoYan
 */
interface IUiItemPlayBase implements IUiBase
{
	/**
	 * 进场
	 */
	function getIn():Void;
	
	/**
	 * 出场
	 */
	function getOut():Void;
	
	/**
	 * 播放到
	 * @param	frame
	 */
	function goTo(frame:Int):Void;
	
	/**
	 * 跳转到
	 * @param	frame
	 */
	function jumpTo(frame:Int):Void;
	
	/**
	 * 跳转到，并播放到
	 * @param	from
	 * @param	to
	 */
	function goFromTo(from:Int, to:Int):Void;
	
	/**
	 * 播放
	 */
	//function play():Void;
	
	/**
	 * 停止
	 */
	//function stop():Void;
	
	/**
	 * 暂停
	 */
	//function pause():Void;
	
	/**
	 * 下一帧
	 */
	//function nextFrame():Void;
	
	/**
	 * 上一帧
	 */
	//function prevFrame():Void;
}