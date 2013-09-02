package cn.royan.hl.consts;

/**
 * ...
 * @author RoYan
 */
class UiConst
{
	/**
	 * 默认样式
	 */
	public static inline var DEFAULT_CSS:String = "default_css";
	
	/**
	 * 视图状态 5
	 * 正常->鼠标移入->鼠标按下->选中->禁用
	 */
	static public inline var STATUS_LEN:Int = 5;
	static public inline var INTERACTIVE_STATUS_NORMAL:Int 		= 0;
	static public inline var INTERACTIVE_STATUS_OVER:Int 		= 1;
	static public inline var INTERACTIVE_STATUS_DOWN:Int 		= 2;
	static public inline var INTERACTIVE_STATUS_SELECTED:Int 	= 3;
	static public inline var INTERACTIVE_STATUS_DISABLE:Int 	= 4;
	
	/**
	 * 水平对齐方式
	 * 左对齐->居中->右对齐
	 */
	static public inline var CONTAINER_HORIZONTAL_LEFT:Int 		= 0;
	static public inline var CONTAINER_HORIZONTAL_CENTER:Int 	= 1;
	static public inline var CONTAINER_HORIZONTAL_RIGHT:Int 	= 2;
	
	/**
	 * 垂直对齐方式
	 * 顶部对齐->居中->底部对齐
	 */
	static public inline var CONTAINER_VERTICAL_TOP:Int			= 0;
	static public inline var CONTAINER_VERTICAL_MIDDLE:Int 		= 1;
	static public inline var CONTAINER_VERTICAL_BOTTOM:Int 		= 2;
	
	/**
	 * 单行垂直对齐方式
	 * 顶部对齐->居中->底部对齐
	 */
	static public inline var CONTAINER_CONTENT_ALIGN_TOP:Int	= 0;
	static public inline var CONTAINER_CONTENT_ALIGN_MIDDLE:Int	= 1;
	static public inline var CONTAINER_CONTENT_ALIGN_BOTTOM:Int	= 2;
	
	/**
	 * 滚动条类型
	 * 水平方向->垂直方向
	 */
	public static inline var SCROLLBAR_TYPE_HORIZONTAL:Int 	= 0;
	public static inline var SCROLLBAR_TYPE_VERICAL:Int 	= 1;
	
	/**
	 * 滚动条显示类型
	 * 不显示->只显示水平方向->只显示垂直方向->都显示
	 */
	public static inline var SCROLL_TYPE_NONE:Int				= 0;
	public static inline var SCROLL_TYPE_HORIZONTAL_ONLY:Int 	= 1;
	public static inline var SCROLL_TYPE_VERICAL_ONLY:Int 		= 2;
	public static inline var SCROLL_TYPE_HANDV:Int				= 3;
	
	/**
	 * 滚动条显示内容
	 */
	public static inline var SCROLL_BOTH_THUMB_AND_BUTTON:Int	= 0;
	public static inline var SCROLL_ONLY_THUMB:Int				= 1;
	public static inline var SCROLL_ONLY_BUTTON:Int				= 2;
	
	/**
	 * 文字对齐方式
	 * 左对齐->居中->右对齐
	 */
	static public inline var TEXT_ALIGN_LEFT:Int 	= 0;
	static public inline var TEXT_ALIGN_CENTER:Int 	= 1;
	static public inline var TEXT_ALIGN_RIGHT:Int	= 2;
	
	/**
	 * 文字自动对齐方式
	 * 不对齐->左对齐->居中->右对齐
	 */
	static public inline var TEXT_AUTOSIZE_NONE:Int = 0;
	static public inline var TEXT_AUTOSIZE_LEFT:Int = 1;
	static public inline var TEXT_AUTOSIZE_CENTER:Int = 2;
	static public inline var TEXT_AUTOSIZE_RIGHT:Int = 3;
	
	/**
	 * 文本类型
	 * 输入框->密码框
	 */
	static public inline var TEXT_TYPE_INPUT:Int = 0;
	static public inline var TEXT_TYPE_PASSWORD:Int = 1;
}