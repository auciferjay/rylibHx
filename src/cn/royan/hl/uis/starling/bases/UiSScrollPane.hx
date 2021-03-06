package cn.royan.hl.uis.starling.bases;

import cn.royan.hl.consts.UiConst;
import cn.royan.hl.events.DatasEvent;
import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.interfaces.uis.IUiScrollPaneBase;
import cn.royan.hl.uis.starling.InteractiveUiS;
import cn.royan.hl.uis.starling.UninteractiveUiS;
import cn.royan.hl.utils.SystemUtils;
import starling.extensions.pixelmask.PixelMaskDisplayObject;

import starling.events.Event;

import flash.geom.Rectangle;

/**
 * ...
 * @author RoYan
 */
class UiSScrollPane extends InteractiveUiS, implements IUiScrollPaneBase
{
	var maskedDisplayObject:PixelMaskDisplayObject;
	var container:InteractiveUiS;
	var containerMask:UninteractiveUiS;
	var scrollerType:Int;
	
	var hScrollBar:UiSScrollBar;
	var vScrollBar:UiSScrollBar;
	
	public function new(container:InteractiveUiS, type:Int = UiConst.SCROLL_TYPE_HANDV, content:Int = UiConst.SCROLL_BOTH_THUMB_AND_BUTTON)
	{
		super();
		
		setMouseRender(true);
		
		this.container = container;
		
		//addChild(container);
		
		maskedDisplayObject = new PixelMaskDisplayObject();
		maskedDisplayObject.addChild(container);
		addChild(maskedDisplayObject);
		
		containerMask = new UninteractiveUiS();
		containerMask.setColorsAndAplhas([0],[1]);
		containerMask.setSize(10, 10);
		maskedDisplayObject.mask = containerMask;
		
		setType(type, content);
	}
	
	override private function addToStageHandler(evt:Event = null):Void 
	{
		super.addToStageHandler(evt);
		
		container.addEventListener(DatasEvent.DATA_CHANGE, changeHandler);
		if( vScrollBar != null ) vScrollBar.addEventListener(DatasEvent.DATA_CHANGE, vChangeHandler);
		if ( hScrollBar != null ) hScrollBar.addEventListener(DatasEvent.DATA_CHANGE, hChangeHandler);
	}
	
	function changeHandler(evt:Event = null):Void
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
		//super.setSize(cWidth, cHeight);
		containerWidth = cWidth;
		containerHeight = cHeight;
		
		containerMask.setSize(cWidth, cHeight);
		maskedDisplayObject.mask = containerMask;
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
		
		draw();
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
					vScrollBar = new UiSScrollBar(UiConst.SCROLLBAR_TYPE_VERICAL, content);
					vScrollBar.addEventListener(DatasEvent.DATA_CHANGE, vChangeHandler);
				}
					
				if ( hScrollBar != null && contains( hScrollBar ) )
					removeChild( hScrollBar );
			case UiConst.SCROLL_TYPE_HORIZONTAL_ONLY:
				if ( hScrollBar == null ) {
					hScrollBar = new UiSScrollBar(UiConst.SCROLLBAR_TYPE_HORIZONTAL, content);
					hScrollBar.addEventListener(DatasEvent.DATA_CHANGE, hChangeHandler);
				}
				
				if ( vScrollBar != null && contains( vScrollBar ) )
					removeChild( vScrollBar );
			case UiConst.SCROLL_TYPE_HANDV:
				if ( hScrollBar == null ) {
					hScrollBar = new UiSScrollBar(UiConst.SCROLLBAR_TYPE_HORIZONTAL, content);
					hScrollBar.addEventListener(DatasEvent.DATA_CHANGE, hChangeHandler);
				}
				if ( vScrollBar == null ) {
					vScrollBar = new UiSScrollBar(UiConst.SCROLLBAR_TYPE_VERICAL, content);
					vScrollBar.addEventListener(DatasEvent.DATA_CHANGE, vChangeHandler);
				}
		}
		
		draw();
	}
	
	function hChangeHandler(evt:Event):Void
	{
		container.setPosition(-Std.int(hScrollBar.getValue() / 100 * (container.width - getRange().width)), container.getRange().y);
	}
	
	function vChangeHandler(evt:Event):Void
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