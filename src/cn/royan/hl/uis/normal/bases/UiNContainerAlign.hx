package cn.royan.hl.uis.normal.bases;

import cn.royan.hl.consts.UiConst;
import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.interfaces.uis.IUiContainerAlignBase;
import cn.royan.hl.interfaces.uis.IUiContainerBase;
import cn.royan.hl.uis.normal.InteractiveUiN;
import cn.royan.hl.uis.sparrow.Sparrow;

import flash.display.DisplayObject;

/**
 * ...
 * @author RoYan
 */
typedef ContainerGap = {
	var x:Int;
	var y:Int;
}

typedef ContainerMargin = {
	var top:Int;
	var bottom:Int;
	var left:Int;
	var right:Int;
}

private typedef ContainerRowConfig = {
	var width:Float;
	var height:Float;
	var length:Int;
}

class UiNContainerAlign extends UiNContainer, implements IUiContainerAlignBase
{
	var horizontalAlign:Int;
	var verticalAlign:Int;
	var contentAlign:Int;
	
	var rows:Array<ContainerRowConfig>;
	var gaps:ContainerGap;
	var margins:ContainerMargin;
	var itemsWidth:Float;
	var itemsHeight:Float;
	
	var moveProp:Dynamic->Void;
	
	public function new(texture:Sparrow = null) 
	{
		super(texture);
	}
	
	//Public methods
	override public function draw():Void 
	{
		super.draw();
		if ( !isOnStage ) return;
		
		fillRow();
		drawRow();
	}
	
	override public function dispose():Void 
	{
		super.dispose();
		
		for ( item in items) {
			item.dispose();
		}
		
		removeAllItems();
	}
	
	public function setHorizontalAlign(value:Int):Void
	{
		horizontalAlign = value;
	}
	
	public function setVerticalAlign(value:Int):Void
	{
		verticalAlign = value;
	}
	
	public function setContentAlign(value:Int):Void
	{
		contentAlign = value;
	}
	
	public function setGaps(gapX:Int, gapY:Int):Void
	{
		gaps = { x:gapX, y:gapY };
	}
	
	public function setMargins(left:Int, top:Int, right:Int, bottom:Int):Void
	{
		margins = { top:top, bottom:bottom, left:left, right:right };
	}
	
	public function setMove(effect:Dynamic->Void):Void
	{
		moveProp = effect;
	}
	
	function fillRow():Void
	{
		var rowW:Float	= 0;
		var rowH:Float	= 0;
		
		var marginL:Float = margins != null?margins.left:0;
		var marginR:Float = margins!=null?margins.right:0;
		
		var gapX:Float = gaps!=null?gaps.x:0;
		var gapY:Float = gaps!=null?gaps.y:0;
		
		itemsWidth = 0;
		itemsHeight = 0;
		
		rows = [];
		
		var itemNumber:Int = 0;
		var rowNumber:Int = 0;
		
		for ( i in 0...items.length ) {
			var item:IUiBase = items[i];
				//item.setPosition(0, 0);
			if ( !cast(item,DisplayObject).visible ) continue;
			
			if ( rowW + ( (i > 0 ? 1:0) * gapX + item.getRange().width ) > containerWidth - marginL - marginR ) {
				//prev row end
				rows.push( { width: rowW, height: rowH, length:itemNumber } );
				itemsWidth = Std.int( Math.max( itemsWidth, rowW ) );
				itemsHeight += (rowNumber > 0 ? 1:0) * gapY + rowH;
				rowNumber++;
				//next row start
				rowW = item.getRange().width;
				rowH = item.getRange().height;
				
				itemNumber = 1;
			}else {
				rowW += ( (i > 0 ? 1:0) * gapX + item.getRange().width);
				rowH = Math.max( rowH, item.getRange().height );
				itemNumber++;
			}
		}
		rows.push( { width: rowW, height: rowH, length:itemNumber } );
		
		itemsWidth = Std.int( Math.max( itemsWidth, rowW ) );
		itemsHeight += (rowNumber > 0 ? 1:0) * gapY + rowH;
	}
	
	function drawRow():Void
	{
		var rowW:Float	= 0;
		var rowH:Float	= 0;
		
		var marginT:Float = margins!=null?margins.top:0;
		var marginB:Float = margins!=null?margins.bottom:0;
		var marginL:Float = margins != null?margins.left:0;
		var marginR:Float = margins!=null?margins.right:0;
		
		var gapX:Float = gaps!=null?gaps.x:0;
		var gapY:Float = gaps!=null?gaps.y:0;
		
		var offsetX:Float;
		var offsetY:Float;
		
		switch( verticalAlign ) {
			case UiConst.CONTAINER_VERTICAL_BOTTOM:
				offsetY = containerHeight - marginB - itemsHeight;
			case UiConst.CONTAINER_VERTICAL_MIDDLE:
				offsetY = Std.int( (containerHeight - itemsHeight) / 2 );
			default:
				offsetY = marginT;
		}
		
		var z:Int = 0;
		for ( i in 0...rows.length ) {
			switch( horizontalAlign ) {
				case UiConst.CONTAINER_HORIZONTAL_RIGHT:
					offsetX = containerWidth - marginR - rows[i].width;
				case UiConst.CONTAINER_HORIZONTAL_CENTER:
					offsetX = (containerWidth - rows[i].width) / 2;
				default:
					offsetX = marginL;
			}
			
			for ( j in 0...rows[i].length ) {
				if ( !cast(items[z], DisplayObject).visible ) {
					z++;
					continue;
				}
				
				switch( contentAlign ) {
					case UiConst.CONTAINER_CONTENT_ALIGN_MIDDLE:
						items[z].setPosition( offsetX, offsetY + (rows[i].height - items[z].getRange().height) / 2 );
					case UiConst.CONTAINER_CONTENT_ALIGN_BOTTOM:
						items[z].setPosition( offsetX, offsetY + rows[i].height - items[z].getRange().height );
					default:
						items[z].setPosition( offsetX, offsetY );
				}
				
				if ( moveProp != null ) {
					moveProp(items[z]);
				}
				
				offsetX += items[z].getRange().width + gapX;
				z++;
			}
			offsetY += rows[i].height + gapY;
		}
	}
}