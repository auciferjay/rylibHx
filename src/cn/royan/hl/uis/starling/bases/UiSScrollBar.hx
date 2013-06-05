package cn.royan.hl.uis.starling.bases;

import cn.royan.hl.consts.UiConst;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.interfaces.uis.IUiScrollBarBase;
import cn.royan.hl.uis.starling.InteractiveUiS;

import starling.events.Touch;
import starling.events.Event;

import flash.events.MouseEvent;
import flash.geom.Rectangle;

/**
 * ...
 * @author RoYan
 */
class UiSScrollBar extends UiSContainerAlign, implements IUiScrollBarBase
{
	var min:UiSLabelButton;
	var max:UiSLabelButton;
	var thumb:UiSLabelButton;
	var bar:InteractiveUiS;
	
	var rect:Rectangle;
	
	var scrollerType:Int;
	
	public function new(type:Int = UiConst.SCROLLBAR_TYPE_HORIZONTAL) 
	{
		super();
		
		min = new UiSLabelButton("-");
		min.setCallbacks({down:minMouseDownHandler, up:minMouseUpHandler});
		addItem(min);
		
		bar = new InteractiveUiS();
		bar.setCallbacks({click:backgroundClickHandler});
		bar.setColorsAndAplhas([0xCCCCCC], [1]);
		addItem(bar);
		
		max = new UiSLabelButton("+");
		max.setCallbacks({down:maxMouseDownHandler, up:maxMouseUpHandler});
		addItem(max);
		
		thumb = new UiSLabelButton("=");
		thumb.setCallbacks({move:thumbMoveHandler});
		addChild(thumb);
		
		rect = new Rectangle();
		
		setType(type);
	}
	
	function minMouseDownHandler(obj:UiSLabelButton, touch:Touch):Void
	{
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
		else dispatchEvent(new Event(DatasEvent.DATA_CHANGE));
	}
	
	function minMouseUpHandler(obj:UiSLabelButton, touch:Touch):Void
	{
		min.removeEventListener(Event.ENTER_FRAME, minEnterHandler);
	}
	
	function maxMouseDownHandler(obj:UiSLabelButton, touch:Touch):Void
	{
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
		else dispatchEvent(new Event(DatasEvent.DATA_CHANGE));
	}
	
	function maxMouseUpHandler(obj:UiSLabelButton, touch:Touch):Void
	{
		max.removeEventListener(Event.ENTER_FRAME, maxEnterHandler);
	}
	
	function backgroundClickHandler(obj:UiSLabelButton, touch:Touch):Void
	{
		switch( scrollerType ) {
			case UiConst.SCROLLBAR_TYPE_HORIZONTAL:
				if ( touch.getLocation(this).x > rect.width ) {
					thumb.setPosition(Std.int(rect.x + rect.width), thumb.getRange().y);
				}else {
					thumb.setPosition(Std.int(touch.getLocation(this).x + rect.x), thumb.getRange().y);
				}
			case UiConst.SCROLLBAR_TYPE_VERICAL:
				if ( touch.getLocation(this).y > rect.height ) {
					thumb.setPosition(thumb.getRange().x, Std.int(rect.y + rect.height));
				}else {
					thumb.setPosition(thumb.getRange().x, Std.int(touch.getLocation(this).y + rect.y));
				}
		}
		
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new Event(DatasEvent.DATA_CHANGE));
	}
	
	function thumbMoveHandler(obj:UiSLabelButton, touch:Touch):Void
	{
		switch( scrollerType ) {
			case UiConst.SCROLLBAR_TYPE_HORIZONTAL:
				thumb.setPosition(thumb.getRange().x + touch.getMovement(this).x, thumb.getRange().y);
			case UiConst.SCROLLBAR_TYPE_VERICAL:
				thumb.setPosition(thumb.getRange().x, thumb.getRange().y + touch.getMovement(this).y);
				
		}
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new Event(DatasEvent.DATA_CHANGE));
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