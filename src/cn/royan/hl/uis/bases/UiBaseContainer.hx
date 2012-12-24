package cn.royan.hl.uis.bases;

import cn.royan.hl.interfaces.uis.IUiBase;
import cn.royan.hl.interfaces.uis.IUiContainerBase;
import cn.royan.hl.uis.InteractiveUiBase;

import flash.display.DisplayObject;

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
	var width:Int;
	var height:Int;
	var length:Int;
}

class UiBaseContainer extends InteractiveUiBase, implements IUiContainerBase
{
	static public inline var CONTAINER_HORIZONTAL_LEFT:Int 		= 0;
	static public inline var CONTAINER_HORIZONTAL_CENTER:Int 	= 1;
	static public inline var CONTAINER_HORIZONTAL_RIGHT:Int 	= 2;
	
	static public inline var CONTAINER_VERTICAL_TOP:Int			= 0;
	static public inline var CONTAINER_VERTICAL_MIDDLE:Int 		= 1;
	static public inline var CONTAINER_VERTICAL_BOTTOM:Int 		= 2;
	
	var horizontalAlign:Int;
	var verticalAlign:Int;
	var items:Array<IUiBase>;
	var rows:Array<ContainerRowConfig>;
	var gaps:ContainerGap;
	var margins:ContainerMargin;
	var itemsWidth:Int;
	var itemsHeight:Int;
	
	public function new() 
	{
		super();
		
		items = [];
	}
	
	//Public methods
	override public function draw():Void 
	{
		//super.draw();
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
	
	public function addItem(item:IUiBase):Void
	{
		items.push(item);
		
		addChild(cast( item, DisplayObject ));
		
		draw();
	}
	
	public function addItemAt(item:IUiBase, index:Int):Void
	{
		var prev:Array<IUiBase> = items.slice(0, index);
		var next:Array<IUiBase> = items.slice(index);
		
		prev.push(item);
		
		items = prev.concat(next);
		
		addChild(cast( item, DisplayObject ));
		
		draw();
	}
	
	public function removeItem(item:IUiBase):Void
	{
		items.remove(item);
		removeChild(cast(item, DisplayObject));
		
		draw();
	}
	
	public function removeItemAt(index:Int):Void
	{
		var prev:Array<IUiBase> = items.slice(0, index);
		var next:Array<IUiBase> = items.slice(index);
		
		removeItem(prev.pop());
		
		items = prev.concat(next);
		
		draw();
	}
	
	public function removeAllItems():Void
	{
		while ( items.length > 0 ) {
			removeItem(items.shift());
		}
		
		draw();
	}
	
	public function getItemAt(index:Int):IUiBase
	{
		return items[index];
	}
	
	public function getIndexByItem(item:IUiBase):Int
	{
		for ( i in 0...items.length ) {
			if ( items[i] == item ) return i;
		}
		return -1;
	}
	
	public function getItems():Array<IUiBase>
	{
		return items;
	}
	
	public function setHorizontalAlign(value:Int):Void
	{
		horizontalAlign = value;
	}
	
	public function setVerticalAlign(value:Int):Void
	{
		verticalAlign = value;
	}
	
	public function setGaps(gapX:Int, gapY:Int):Void
	{
		gaps = { x:gapX, y:gapY };
	}
	
	public function setMargins(left:Int, top:Int, right:Int, bottom:Int):Void
	{
		margins = { top:top, bottom:bottom, left:left, right:right };
	}
	
	function fillRow():Void
	{
		var rowW:Int	= 0;
		var rowH:Int	= 0;
		
		var marginL:Int = margins != null?margins.left:0;
		var marginR:Int = margins!=null?margins.right:0;
		
		var gapX:Int = gaps!=null?gaps.x:0;
		var gapY:Int = gaps!=null?gaps.x:0;
		
		itemsWidth = 0;
		itemsHeight = 0;
		
		rows = [];
		
		var itemNumber:Int = 0;
		var rowNumber:Int = 0;
		for ( i in 0...items.length ) {
			var item:IUiBase = items[i];
			if ( rowW + ( (i > 0 ? 1:0) * gapX + item.getSize().width ) > containerWidth - marginL - marginR ) {
				//prev row end
				rows.push( { width: rowW, height: rowH, length:itemNumber } );
				itemsWidth = Std.int( Math.max( itemsWidth, rowW ) );
				itemsHeight += (rowNumber > 0 ? 1:0) * gapY + rowH;
				rowNumber++;
				//next row start
				rowW = item.getSize().width;
				rowH = item.getSize().height;
				
				itemNumber = 1;
			}else {
				rowW += ( (i > 0 ? 1:0) * gapX + item.getSize().width);
				rowH = Std.int( Math.max( rowH, item.getSize().height ) );
				itemNumber++;
			}
		}
		rows.push( { width: rowW, height: rowH, length:itemNumber } );
		
		itemsWidth = Std.int( Math.max( itemsWidth, rowW ) );
		itemsHeight += (rowNumber > 0 ? 1:0) * gapY + rowH;
	}
	
	function drawRow():Void
	{
		var rowW:Int	= 0;
		var rowH:Int	= 0;
		
		var marginT:Int = margins!=null?margins.top:0;
		var marginB:Int = margins!=null?margins.bottom:0;
		var marginL:Int = margins != null?margins.left:0;
		var marginR:Int = margins!=null?margins.right:0;
		
		var gapX:Int = gaps!=null?gaps.x:0;
		var gapY:Int = gaps!=null?gaps.x:0;
		
		var offsetX:Int;
		var offsetY:Int;
		
		switch( verticalAlign ) {
			case CONTAINER_VERTICAL_BOTTOM:
				offsetY = containerHeight - marginB - itemsHeight;
			case CONTAINER_VERTICAL_MIDDLE:
				offsetY = Std.int( (containerHeight - itemsHeight) / 2 );
			default:
				offsetY = marginT;
		}
		
		var z:Int = 0;
		for ( i in 0...rows.length ) {
			switch( horizontalAlign ) {
				case CONTAINER_HORIZONTAL_RIGHT:
					offsetX = containerWidth - marginR - rows[i].width;
				case CONTAINER_HORIZONTAL_CENTER:
					offsetX = Std.int( (containerWidth - rows[i].width) / 2 );
				default:
					offsetX = marginL;
			}
			
			for( j in 0...rows[i].length ){
				items[z].setPosition( offsetX, offsetY );
				offsetX += items[z].getSize().width + gapX;
				z++;
			}
			offsetY += rows[i].height + gapY;
		}
	}
}