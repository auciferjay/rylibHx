package cn.royan.hl.uis.normal.bases;

import cn.royan.hl.consts.UiConst;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.interfaces.uis.IUiScrollBarBase;
import cn.royan.hl.uis.normal.InteractiveUiN;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

/**
 * ...
 * @author RoYan
 */
class UiNScrollBar extends UiNContainerAlign, implements IUiScrollBarBase
{
	var min:UiNLabelButton;
	var max:UiNLabelButton;
	var thumb:UiNLabelButton;
	var bar:InteractiveUiN;
	
	var rect:Rectangle;
	
	var scrollerType:Int;
	
	public function new(type:Int = UiConst.SCROLLBAR_TYPE_HORIZONTAL) 
	{
		super();
		
		min = new UiNLabelButton();
		min.addEventListener(MouseEvent.MOUSE_DOWN, minMouseDownHandler);
		addItem(min);
		
		bar = new InteractiveUiN();
		bar.addEventListener(MouseEvent.CLICK, backgroundClickHandler);
		bar.setColorsAndAplhas([0xCCCCCC], [1]);
		addItem(bar);
		
		max = new UiNLabelButton();
		max.addEventListener(MouseEvent.MOUSE_DOWN, maxMouseDownHandler);
		addItem(max);
		
		thumb = new UiNLabelButton();
		thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbMouseDownHandler);
		addChild(thumb);
		
		rect = new Rectangle();
		
		setType(type);
	}
	
	override private function addToStageHandler(evt:Event = null):Void 
	{
		super.addToStageHandler(evt);
		
		#if flash
		bar.addEventListener(MouseEvent.CLICK, backgroundClickHandler);
		thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbMouseDownHandler);
		max.addEventListener(MouseEvent.MOUSE_DOWN, maxMouseDownHandler);
		min.addEventListener(MouseEvent.MOUSE_DOWN, minMouseDownHandler);
		#end
	}
	
	function minMouseDownHandler(evt:MouseEvent):Void
	{
		min.addEventListener(MouseEvent.MOUSE_UP, minMouseUpHandler);
		min.stage.addEventListener(MouseEvent.MOUSE_UP, minMouseUpHandler);
		
		min.addEventListener(Event.ENTER_FRAME, minEnterHandler);
	}
	
	function minEnterHandler(evt:Event):Void
	{
		switch( scrollerType ) {
			case UiConst.SCROLLBAR_TYPE_HORIZONTAL:
				if ( thumb.getRange().x > rect.x ) {
					thumb.setPosition(thumb.getRange().x - 1, thumb.getRange().y);
				}
			case UiConst.SCROLLBAR_TYPE_VERICAL:
				if ( thumb.getRange().y > rect.y ) {
					thumb.setPosition(thumb.getRange().x, thumb.getRange().y - 1);
				}
		}
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_CHANGE));
	}
	
	function minMouseUpHandler(evt:MouseEvent):Void
	{
		min.removeEventListener(MouseEvent.MOUSE_UP, minMouseUpHandler);
		min.stage.removeEventListener(MouseEvent.MOUSE_UP, minMouseUpHandler);
		
		min.removeEventListener(Event.ENTER_FRAME, minEnterHandler);
	}
	
	function maxMouseDownHandler(evt:MouseEvent):Void
	{
		max.addEventListener(MouseEvent.MOUSE_UP, maxMouseUpHandler);
		max.stage.addEventListener(MouseEvent.MOUSE_UP, maxMouseUpHandler);
		
		max.addEventListener(Event.ENTER_FRAME, maxEnterHandler);
	}
	
	function maxEnterHandler(evt:Event):Void
	{
		switch( scrollerType ) {
			case UiConst.SCROLLBAR_TYPE_HORIZONTAL:
				if ( thumb.getRange().x < rect.width + rect.x ) {
					thumb.setPosition(thumb.getRange().x + 1, thumb.getRange().y);
				}
			case UiConst.SCROLLBAR_TYPE_VERICAL:
				if ( thumb.getRange().y < rect.height + rect.y ) {
					thumb.setPosition(thumb.getRange().x, thumb.getRange().y + 1);
				}
		}
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new DatasEvent(DatasEvent.DATA_CHANGE));
	}
	
	function maxMouseUpHandler(evt:MouseEvent):Void
	{
		max.removeEventListener(MouseEvent.MOUSE_UP, maxMouseUpHandler);
		max.stage.removeEventListener(MouseEvent.MOUSE_UP, maxMouseUpHandler);
		
		max.removeEventListener(Event.ENTER_FRAME, maxEnterHandler);
	}
	
	function backgroundClickHandler(evt:MouseEvent):Void
	{
		switch( scrollerType ) {
			case UiConst.SCROLLBAR_TYPE_HORIZONTAL:
				if ( evt.localX > rect.width ) {
					thumb.setPosition(Std.int(rect.x + rect.width), thumb.getRange().y);
				}else {
					thumb.setPosition(Std.int(evt.localX + rect.x), thumb.getRange().y);
				}
			case UiConst.SCROLLBAR_TYPE_VERICAL:
				if ( evt.localY > rect.height ) {
					thumb.setPosition(thumb.getRange().x, Std.int(rect.y + rect.height));
				}else {
					thumb.setPosition(thumb.getRange().x, Std.int(evt.localY + rect.y));
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
	
	override public function setSize(w:Float, h:Float):Void 
	{
		super.setSize(w, h);
		
		switch( scrollerType ) {
			case UiConst.SCROLLBAR_TYPE_HORIZONTAL:
				min.setSize(h, h);
				max.setSize(h, h);
				bar.setSize(w - 2 * h, h);
				thumb.setSize(3 * h, h);
				
				rect.width 	= w - 2 * h - thumb.getRange().width;
				rect.height = 0;
				rect.x = h;
				rect.y = 0;
				
				thumb.setPosition(h, 0);
			case UiConst.SCROLLBAR_TYPE_VERICAL:
				min.setSize(w, w);
				max.setSize(w, w);
				bar.setSize(w, h - 2 * w);
				thumb.setSize(w, 3 * w);
				
				rect.width 	= 0;
				rect.height = h - 2 * w - thumb.getRange().height;
				rect.x = 0;
				rect.y = w;
				
				thumb.setPosition(0, w);
		}
	}
	
	public function setValue(value:Int):Void
	{
		switch( scrollerType ) {
			case UiConst.SCROLLBAR_TYPE_HORIZONTAL:
				thumb.x = value / 100 * rect.width + rect.x;
			case UiConst.SCROLLBAR_TYPE_VERICAL:
				thumb.y = value / 100 * rect.height + rect.y;
		}
	}
	
	public function getValue():Int
	{
		switch( scrollerType ) {
			case UiConst.SCROLLBAR_TYPE_HORIZONTAL:
				return Std.int((thumb.x - rect.x) / rect.width * 100);
			case UiConst.SCROLLBAR_TYPE_VERICAL:
				return Std.int((thumb.y - rect.y) / rect.height * 100);
		}
		return 0;
	}
	
	public function setType(type:Int):Void
	{
		scrollerType = type;
		
		switch( scrollerType ) {
			case UiConst.SCROLLBAR_TYPE_HORIZONTAL:
				thumb.setPosition(containerHeight, 0);
			case UiConst.SCROLLBAR_TYPE_VERICAL:
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
		bar.setTexture(texture);
	}
}