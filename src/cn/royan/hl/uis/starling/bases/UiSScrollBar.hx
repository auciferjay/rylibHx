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
	var scrollerCont:Int;
	
	public function new(type:Int = UiConst.SCROLLBAR_TYPE_HORIZONTAL, content:Int = UiConst.SCROLL_BOTH_THUMB_AND_BUTTON) 
	{
		super();
		
		scrollerCont = content;
		
		setMouseRender(true);
		
		if ( content != UiConst.SCROLL_ONLY_THUMB ) {
			min = new UiSLabelButton("-");
			min.setCallbacks({down:minMouseDownHandler, up:minMouseUpHandler});
			addItem(min);
		}
		
		bar = new InteractiveUiS();
		bar.setCallbacks({click:backgroundClickHandler});
		bar.setColorsAndAplhas([0xCCCCCC], [1]);
		addItem(bar);
		
		if ( content != UiConst.SCROLL_ONLY_THUMB ) {
			max = new UiSLabelButton("+");
			max.setCallbacks({down:maxMouseDownHandler, up:maxMouseUpHandler});
			addItem(max);
		}
		
		thumb = new UiSLabelButton("=");
		thumb.setColorsAndAplhas([[0x555555]], [[1]]);
		thumb.setCallbacks( { move:thumbMoveHandler } );
		if ( content != UiConst.SCROLL_ONLY_BUTTON ) {
			addChild(thumb);
		}
		
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
				if ( rect.x <= thumb.getRange().x + touch.getMovement(this).x &&
					 rect.x + rect.width >= thumb.getRange().x + touch.getMovement(this).x ) {
					thumb.setPosition(thumb.getRange().x + touch.getMovement(this).x, thumb.getRange().y);
				}
			case UiConst.SCROLLBAR_TYPE_VERICAL:
				if ( rect.y <= thumb.getRange().y + touch.getMovement(this).y &&
					 rect.y + rect.height >= thumb.getRange().y + touch.getMovement(this).y ) {
					thumb.setPosition(thumb.getRange().x, thumb.getRange().y + touch.getMovement(this).y);
				}
				
		}
		if ( callbacks != null && callbacks.change != null ) callbacks.change(this);
		else dispatchEvent(new Event(DatasEvent.DATA_CHANGE));
	}
	
	override public function setSize(w:Float, h:Float):Void 
	{
		super.setSize(w, h);
		
		switch( scrollerType ) {
			case UiConst.SCROLLBAR_TYPE_HORIZONTAL:
				switch( scrollerCont ) {
					case UiConst.SCROLL_BOTH_THUMB_AND_BUTTON, UiConst.SCROLL_ONLY_BUTTON:
						min.setSize(h, h);
						bar.setSize(w - 2 * h, h);
						thumb.setSize(3 * h, h);
						max.setSize(h, h);
						
						rect.width 	= w - 2 * h - thumb.getRange().width;
						rect.x = h;
					case UiConst.SCROLL_ONLY_THUMB:
						bar.setSize(w, h);
						thumb.setSize(3 * h, h);
						
						rect.width 	= w - thumb.getRange().width;
						rect.x = 0;
				}
				
				rect.height = 0;
				rect.y = 0;
				
				thumb.setPosition(rect.x, 0);
			case UiConst.SCROLLBAR_TYPE_VERICAL:
				switch( scrollerCont ) {
					case UiConst.SCROLL_BOTH_THUMB_AND_BUTTON, UiConst.SCROLL_ONLY_BUTTON:
						min.setSize(w, w);
						bar.setSize(w, h - 2* w);
						thumb.setSize(w, 3 * w);
						max.setSize(w, w);
						
						rect.height = h - 2 * w - thumb.getRange().height;
						rect.y = w;
					case UiConst.SCROLL_ONLY_THUMB:
						bar.setSize(w, h - 2* w);
						thumb.setSize(w, 3 * w);
						
						rect.height = h - thumb.getRange().height;
						rect.y = 0;
				}
				
				rect.width 	= 0;
				rect.x = 0;
				
				thumb.setPosition(0, rect.y);
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
		
		//draw();
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