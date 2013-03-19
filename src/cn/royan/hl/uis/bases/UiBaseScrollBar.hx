package cn.royan.hl.uis.bases;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.interfaces.uis.IUiScrollBarBase;
import cn.royan.hl.uis.InteractiveUiBase;
import cn.royan.hl.utils.SystemUtils;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

/**
 * ...
 * @author RoYan
 */

class UiBaseScrollBar extends UiBaseContainerAlign, implements IUiScrollBarBase
{
	public static inline var SCROLLBAR_TYPE_HORIZONTAL:Int 	= 0;
	public static inline var SCROLLBAR_TYPE_VERICAL:Int 	= 1;
	
	var min:UiBaseLabelButton;
	var max:UiBaseLabelButton;
	var thumb:UiBaseLabelButton;
	var background:InteractiveUiBase;
	
	var rect:Rectangle;
	
	var scrollerType:Int;
	
	public function new(type:Int = SCROLLBAR_TYPE_HORIZONTAL) 
	{
		super();
		
		min = new UiBaseLabelButton();
		addItem(min);
		
		background = new InteractiveUiBase();
		background.addEventListener(MouseEvent.CLICK, backgroundClickHandler);
		background.setBackgroundColors([0xCCCCCC]);
		background.setBackgroundAlphas([1]);
		addItem(background);
		
		max = new UiBaseLabelButton();
		addItem(max);
		
		thumb = new UiBaseLabelButton();
		thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbMouseDownHandler);
		addChild(thumb);
		
		rect = new Rectangle();
		
		setType(type);
	}
	
	function backgroundClickHandler(evt:MouseEvent):Void
	{
		switch( scrollerType ) {
			case SCROLLBAR_TYPE_HORIZONTAL:
				if ( evt.localX > rect.width ) {
					thumb.setPosition(Std.int(rect.x + rect.width), thumb.getPosition().y);
				}else {
					thumb.setPosition(Std.int(evt.localX + rect.x), thumb.getPosition().y);
				}
			case SCROLLBAR_TYPE_VERICAL:
				if ( evt.localY > rect.height ) {
					thumb.setPosition(thumb.getPosition().x, Std.int(rect.y + rect.height));
				}else {
					thumb.setPosition(thumb.getPosition().x, Std.int(evt.localY + rect.y));
				}
		}
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_CHANGE));
	}
	
	function thumbMouseDownHandler(evt:MouseEvent):Void
	{
		thumb.startDrag(false, rect);
		thumb.addEventListener(MouseEvent.MOUSE_UP, thumbMouseUpHandler);
		thumb.stage.addEventListener(MouseEvent.MOUSE_UP, thumbMouseUpHandler);
		
		thumb.addEventListener(Event.ENTER_FRAME, thumbEnterFrameHandler);
	}
	
	function thumbMouseUpHandler(evt:MouseEvent):Void
	{
		thumb.stopDrag();
		thumb.removeEventListener(MouseEvent.MOUSE_UP, thumbMouseUpHandler);
		thumb.stage.removeEventListener(MouseEvent.MOUSE_UP, thumbMouseUpHandler);
		
		thumb.removeEventListener(Event.ENTER_FRAME, thumbEnterFrameHandler);
	}
	
	function thumbEnterFrameHandler(evt:Event):Void
	{
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_CHANGE));
	}
	
	override public function setSize(w:Int, h:Int):Void 
	{
		super.setSize(w, h);
		
		switch( scrollerType ) {
			case SCROLLBAR_TYPE_HORIZONTAL:
				min.setSize(h, h);
				max.setSize(h, h);
				background.setSize(w - 2 * h, h);
				thumb.setSize(3 * h, h);
				
				rect.width 	= w - 2 * h - thumb.getSize().width;
				rect.height = 0;
				rect.x = h;
				rect.y = 0;
				
				thumb.setPosition(h, 0);
			case SCROLLBAR_TYPE_VERICAL:
				min.setSize(w, w);
				max.setSize(w, w);
				background.setSize(w, h - 2 * w);
				thumb.setSize(w, 3 * w);
				
				rect.width 	= 0;
				rect.height = h - 2 * w - thumb.getSize().height;
				rect.x = 0;
				rect.y = w;
				
				thumb.setPosition(0, w);
		}
	}
	
	public function setValue(value:Int):Void
	{
		switch( scrollerType ) {
			case SCROLLBAR_TYPE_HORIZONTAL:
				thumb.x = value / 100 * rect.width + rect.x;
			case SCROLLBAR_TYPE_VERICAL:
				thumb.y = value / 100 * rect.height + rect.y;
		}
	}
	
	public function getValue():Int
	{
		switch( scrollerType ) {
			case SCROLLBAR_TYPE_HORIZONTAL:
				return Std.int((thumb.x - rect.x) / rect.width * 100);
			case SCROLLBAR_TYPE_VERICAL:
				return Std.int((thumb.y - rect.y) / rect.height * 100);
		}
		return 0;
	}
	
	public function setType(type:Int):Void
	{
		scrollerType = type;
		
		switch( scrollerType ) {
			case SCROLLBAR_TYPE_HORIZONTAL:
				thumb.setPosition(containerHeight, 0);
			case SCROLLBAR_TYPE_VERICAL:
				thumb.setPosition(0, containerWidth);
		}
		
		draw();
	}
	
	public function setThumbTexture(texture:Dynamic):Void
	{
		thumb.setTexture(texture);
	}
	
	public function setMinTexture(texture:Dynamic):Void
	{
		min.setTexture(texture);
	}
	
	public function setMaxTexture(texture:Dynamic):Void
	{
		max.setTexture(texture);
	}
	
	public function setBackgroundTextrue(texture:Dynamic):Void
	{
		background.setTexture(texture);
	}
}