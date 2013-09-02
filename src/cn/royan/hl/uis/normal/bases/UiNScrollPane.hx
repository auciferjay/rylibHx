package cn.royan.hl.uis.normal.bases;

import cn.royan.hl.consts.UiConst;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.uis.normal.InteractiveUiN;
import cn.royan.hl.uis.normal.UninteractiveUiN;
import cn.royan.hl.interfaces.uis.IUiScrollPaneBase;

import flash.events.Event;
import flash.geom.Rectangle;

#if js
import browser.display.Graphics;
import browser.Lib;
import browser.Html5Dom;
#end

/**
 * ...
 * @author RoYan
 */
class UiNScrollPane extends InteractiveUiN, implements IUiScrollPaneBase
{
	var container:InteractiveUiN;
	var containerMask:UninteractiveUiN;
	var scrollerType:Int;
	
	var hScrollBar:UiNScrollBar;
	var vScrollBar:UiNScrollBar;
	
	public function new(container:InteractiveUiN, type:Int = UiConst.SCROLL_TYPE_HANDV, content:Int = UiConst.SCROLL_BOTH_THUMB_AND_BUTTON) 
	{
		super();
		
		this.container = container;
		
		container.addEventListener(DatasEvent.DATA_CHANGE, changeHandler);
		addChild(container);
		#if flash
		containerMask = new UninteractiveUiN();
		addChild(containerMask);
		container.mask = containerMask;
		#elseif js
		nmeSurface.style.width = container.getSize().width + "px";
		nmeSurface.style.height = container.getSize().height + "px";
		nmeSurface.style.setProperty("overflow", "hidden", "");
		#end
		
		setType(type, content);
		
		changeHandler();
	}
	
	override private function addToStageHandler(evt:Event = null):Void 
	{
		super.addToStageHandler(evt);
		
		changeHandler();
		#if flash
		if( vScrollBar != null ) vScrollBar.addEventListener(DatasEvent.DATA_CHANGE, vChangeHandler);
		if ( hScrollBar != null ) hScrollBar.addEventListener(DatasEvent.DATA_CHANGE, hChangeHandler);
		#end
	}
	
	function changeHandler(evt:DatasEvent = null):Void
	{
		if ( container.width > containerWidth && 
			( scrollerType == UiConst.SCROLL_TYPE_HORIZONTAL_ONLY || scrollerType == UiConst.SCROLL_TYPE_HANDV ) ) {
			if ( !contains(hScrollBar) ) addChild(hScrollBar);
		}else {
			if ( hScrollBar != null && contains(hScrollBar) ) removeChild(hScrollBar);
		}
		
		if ( container.height > containerHeight &&
			( scrollerType == UiConst.SCROLL_TYPE_VERICAL_ONLY || scrollerType == UiConst.SCROLL_TYPE_HANDV ) ) {
			if ( !contains(vScrollBar) ) addChild(vScrollBar);
		}else {
			if ( vScrollBar != null && contains(vScrollBar) ) removeChild(vScrollBar);
		}
	}
	
	override public function setSize(cWidth:Float, cHeight:Float):Void
	{
		super.setSize(cWidth, cHeight);
		#if flash
		containerMask.setSize(cWidth, cHeight);
		#elseif js
		nmeSurface.style.width = cWidth + "px";
		nmeSurface.style.height = cHeight + "px";
		#end
		switch(scrollerType){
			case UiConst.SCROLL_TYPE_NONE:
			case UiConst.SCROLL_TYPE_VERICAL_ONLY:
				vScrollBar.setSize(10, cHeight);
				vScrollBar.setPosition(cWidth - 10, 0);
			case UiConst.SCROLL_TYPE_HORIZONTAL_ONLY:
				hScrollBar.setSize(cWidth, 10);
				hScrollBar.setPosition(0, cHeight - 10);
			case UiConst.SCROLL_TYPE_HANDV:
				hScrollBar.setSize(cWidth - 10, 10);
				vScrollBar.setSize(10, cHeight - 10);
				
				vScrollBar.setPosition(cWidth - 10, 0);
				hScrollBar.setPosition(0, cHeight - 10);
		}
		
		viewChanged();
	}
	
	public function setType(type:Int, content:Int):Void
	{
		scrollerType = type;
		
		switch(scrollerType){
			case UiConst.SCROLL_TYPE_NONE:
				if ( vScrollBar != null && contains( vScrollBar ) )
					removeChild( vScrollBar );
				if ( hScrollBar != null && contains( hScrollBar ) )
					removeChild( hScrollBar );
			case UiConst.SCROLL_TYPE_VERICAL_ONLY:
				if ( vScrollBar == null ) {
					vScrollBar = new UiNScrollBar(UiConst.SCROLLBAR_TYPE_VERICAL, content);
					vScrollBar.addEventListener(DatasEvent.DATA_CHANGE, vChangeHandler);
				}
					
				if ( hScrollBar != null && contains( hScrollBar ) )
					removeChild( hScrollBar );
			case UiConst.SCROLL_TYPE_HORIZONTAL_ONLY:
				if ( hScrollBar == null ) {
					hScrollBar = new UiNScrollBar(UiConst.SCROLLBAR_TYPE_HORIZONTAL, content);
					hScrollBar.addEventListener(DatasEvent.DATA_CHANGE, hChangeHandler);
				}
				
				if ( vScrollBar != null && contains( vScrollBar ) )
					removeChild( vScrollBar );
			case UiConst.SCROLL_TYPE_HANDV:
				if ( hScrollBar == null ) {
					hScrollBar = new UiNScrollBar(UiConst.SCROLLBAR_TYPE_HORIZONTAL, content);
					hScrollBar.addEventListener(DatasEvent.DATA_CHANGE, hChangeHandler);
				}
				if ( vScrollBar == null ) {
					vScrollBar = new UiNScrollBar(UiConst.SCROLLBAR_TYPE_VERICAL, content);
					vScrollBar.addEventListener(DatasEvent.DATA_CHANGE, vChangeHandler);
				}
		}
		
		viewChanged();
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