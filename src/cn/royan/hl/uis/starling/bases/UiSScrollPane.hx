package cn.royan.hl.uis.starling.bases;

import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.interfaces.uis.IUiScrollPaneBase;
import cn.royan.hl.uis.starling.InteractiveUiS;
import cn.royan.hl.uis.starling.UninteractiveUiS;

import starling.events.Event;

import flash.geom.Rectangle;

/**
 * ...
 * @author RoYan
 */
class UiSScrollPane extends InteractiveUiS, implements IUiScrollPaneBase
{
	public static inline var SCROLL_TYPE_NONE:Int				= 0;
	public static inline var SCROLL_TYPE_HORIZONTAL_ONLY:Int 	= 1;
	public static inline var SCROLL_TYPE_VERICAL_ONLY:Int 		= 2;
	public static inline var SCROLL_TYPE_HANDV:Int				= 3;
	
	var container:InteractiveUiS;
	var containerMask:UninteractiveUiS;
	var scrollerType:Int;
	
	var hScrollBar:UiSScrollBar;
	var vScrollBar:UiSScrollBar;
	
	public function new(container:InteractiveUiS, type:Int = SCROLL_TYPE_HANDV) 
	{
		super();
		
		this.container = container;
		
		container.addEventListener(DatasEvent.DATA_CHANGE, changeHandler);
		addChild(container);
		
		containerMask = new UninteractiveUiS();
		addChild(containerMask);
		//container.mask = containerMask;
		
		setType(type);
		
		changeHandler();
	}
	
	override private function addToStageHandler(evt:Event = null):Void 
	{
		super.addToStageHandler(evt);
		
		changeHandler();
		if( vScrollBar != null ) vScrollBar.addEventListener(DatasEvent.DATA_CHANGE, vChangeHandler);
		if ( hScrollBar != null ) hScrollBar.addEventListener(DatasEvent.DATA_CHANGE, hChangeHandler);
	}
	
	function changeHandler(evt:DatasEvent = null):Void
	{
		if ( container.width > containerWidth && 
			( scrollerType == SCROLL_TYPE_HORIZONTAL_ONLY || scrollerType == SCROLL_TYPE_HANDV ) ) {
			if ( !contains(hScrollBar) ) addChild(hScrollBar);
		}else {
			if ( hScrollBar != null && contains(hScrollBar) ) removeChild(hScrollBar);
		}
		
		if ( container.height > containerHeight &&
			( scrollerType == SCROLL_TYPE_VERICAL_ONLY || scrollerType == SCROLL_TYPE_HANDV ) ) {
			if ( !contains(vScrollBar) ) addChild(vScrollBar);
		}else {
			if ( vScrollBar != null && contains(vScrollBar) ) removeChild(vScrollBar);
		}
	}
	
	override public function setSize(cWidth:Float, cHeight:Float):Void
	{
		super.setSize(cWidth, cHeight);
		containerMask.setSize(cWidth, cHeight);
		switch(scrollerType){
			case SCROLL_TYPE_NONE:
			case SCROLL_TYPE_VERICAL_ONLY:
				vScrollBar.setSize(10, cHeight);
				vScrollBar.setPosition(cWidth - 10, 0);
			case SCROLL_TYPE_HORIZONTAL_ONLY:
				hScrollBar.setSize(cWidth, 10);
				hScrollBar.setPosition(0, cHeight - 10);
			case SCROLL_TYPE_HANDV:
				hScrollBar.setSize(cWidth - 10, 10);
				vScrollBar.setSize(10, cHeight - 10);
				
				vScrollBar.setPosition(cWidth - 10, 0);
				hScrollBar.setPosition(0, cHeight - 10);
		}
		
		draw();
	}
	
	public function setType(type:Int):Void
	{
		scrollerType = type;
		
		switch(scrollerType){
			case SCROLL_TYPE_NONE:
				if ( vScrollBar != null && contains( vScrollBar ) )
					removeChild( vScrollBar );
				if ( hScrollBar != null && contains( hScrollBar ) )
					removeChild( hScrollBar );
			case SCROLL_TYPE_VERICAL_ONLY:
				if ( vScrollBar == null ) {
					vScrollBar = new UiSScrollBar(UiSScrollBar.SCROLLBAR_TYPE_VERICAL);
					vScrollBar.addEventListener(DatasEvent.DATA_CHANGE, vChangeHandler);
				}
					
				if ( hScrollBar != null && contains( hScrollBar ) )
					removeChild( hScrollBar );
			case SCROLL_TYPE_HORIZONTAL_ONLY:
				if ( hScrollBar == null ) {
					hScrollBar = new UiSScrollBar(UiSScrollBar.SCROLLBAR_TYPE_HORIZONTAL);
					hScrollBar.addEventListener(DatasEvent.DATA_CHANGE, hChangeHandler);
				}
				
				if ( vScrollBar != null && contains( vScrollBar ) )
					removeChild( vScrollBar );
			case SCROLL_TYPE_HANDV:
				if ( hScrollBar == null ) {
					hScrollBar = new UiSScrollBar(UiSScrollBar.SCROLLBAR_TYPE_HORIZONTAL);
					hScrollBar.addEventListener(DatasEvent.DATA_CHANGE, hChangeHandler);
				}
				if ( vScrollBar == null ) {
					vScrollBar = new UiSScrollBar(UiSScrollBar.SCROLLBAR_TYPE_VERICAL);
					vScrollBar.addEventListener(DatasEvent.DATA_CHANGE, vChangeHandler);
				}
		}
		
		draw();
	}
	
	function hChangeHandler(evt:DatasEvent):Void
	{
		container.setPosition(-Std.int(hScrollBar.getValue() / 100 * (container.width - getRange().width)), container.getRange().y);
	}
	
	function vChangeHandler(evt:DatasEvent):Void
	{
		container.setPosition(container.getRange().x, -Std.int(vScrollBar.getValue() / 100 * (container.height - getRange().height)));
	}
	
	public function setThumbTexture(texture:Dynamic):Void
	{
		if ( hScrollBar != null ) hScrollBar.setThumbTexture(texture);
		if ( vScrollBar != null ) hScrollBar.setThumbTexture(texture);
	}
	
	public function setMinTexture(texture:Dynamic):Void
	{
		if ( hScrollBar != null ) hScrollBar.setMinTexture(texture);
		if ( vScrollBar != null ) hScrollBar.setMinTexture(texture);
	}
	
	public function setMaxTexture(texture:Dynamic):Void
	{
		if ( hScrollBar != null ) hScrollBar.setMaxTexture(texture);
		if ( vScrollBar != null ) hScrollBar.setMaxTexture(texture);
	}
	
	public function setBackgroundTextrue(texture:Dynamic):Void
	{
		if ( hScrollBar != null ) hScrollBar.setBackgroundTextrue(texture);
		if ( vScrollBar != null ) hScrollBar.setBackgroundTextrue(texture);
	}
}