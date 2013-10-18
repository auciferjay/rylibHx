package cn.royan.hl.uis.graphs.components;

import cn.royan.hl.consts.UiConst;
import cn.royan.hl.uis.graphs.UiGDisplayObject;
import cn.royan.hl.uis.graphs.UiGSprite;

/**
 * ...
 * @author RoYan
 */
private typedef ContainerGap = {
	var x:Int;
	var y:Int;
}

private typedef ContainerMargin = {
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

class UiGContainer extends UiGSprite
{
	private var _horizontalAlign:Int;
	private var _verticalAlign:Int;
	private var _contentAlign:Int;

	private var _rows:Array<ContainerRowConfig>;
	private var _gaps:ContainerGap;
	private var _margins:ContainerMargin;
	private var _itemsWidth:Float;
	private var _itemsHeight:Float;

	private var _moveProp:Dynamic->Void;
	
	public function new() 
	{
		super();
	}
	
	public function setHorizontalAlign(value:Int):Void
	{
		_horizontalAlign = value;
	}

	public function setVerticalAlign(value:Int):Void
	{
		_verticalAlign = value;
	}

	public function setContentAlign(value:Int):Void
	{
		_contentAlign = value;
	}

	public function setGaps(gapX:Int, gapY:Int):Void
	{
		_gaps = { x:gapX, y:gapY };
	}

	public function setMargins(left:Int, top:Int, right:Int, bottom:Int):Void
	{
		_margins = { top:top, bottom:bottom, left:left, right:right };
	}

	public function setMove(effect:Dynamic->Void):Void
	{
		_moveProp = effect;
	}
	
	override public function draw():Void 
	{
		fillRow();
		drawRow();
		super.draw();
	}
	
	function fillRow():Void
	{
		var rowW:Float	= 0;
		var rowH:Float	= 0;

		var marginL:Float = _margins != null?_margins.left:0;
		var marginR:Float = _margins != null?_margins.right:0;

		var gapX:Float = _gaps != null?_gaps.x:0;
		var gapY:Float = _gaps != null?_gaps.y:0;

		_itemsWidth = 0;
		_itemsHeight = 0;

		_rows = [];

		var itemNumber:Int = 0;
		var rowNumber:Int = 0;

		for ( i in 0..._items.length ) {
			var item:UiGDisplayObject = _items[i];
			if ( !cast(item, UiGDisplayObject).visible ) continue;
			if ( rowW + ( (i > 0 ? 1:0) * gapX + item.width ) > width - marginL - marginR ) {
				//prev row end
				_rows.push( { width: rowW, height: rowH, length:itemNumber } );
				_itemsWidth = Std.int( Math.max( _itemsWidth, rowW ) );
				_itemsHeight += (rowNumber > 0 ? 1:0) * gapY + rowH;
				rowNumber++;
				//next row start
				rowW = item.width;
				rowH = item.height;

				itemNumber = 1;
			}else {
				rowW += ( (i > 0 ? 1:0) * gapX + item.width);
				rowH = Math.max( rowH, item.height );
				itemNumber++;
			}
		}
		_rows.push( { width: rowW, height: rowH, length:itemNumber } );

		_itemsWidth = Std.int( Math.max( _itemsWidth, rowW ) );
		_itemsHeight += (rowNumber > 0 ? 1:0) * gapY + rowH;
	}

	function drawRow():Void
	{
		var rowW:Float	= 0;
		var rowH:Float	= 0;

		var marginT:Float = _margins != null?_margins.top:0;
		var marginB:Float = _margins != null?_margins.bottom:0;
		var marginL:Float = _margins != null?_margins.left:0;
		var marginR:Float = _margins != null?_margins.right:0;

		var gapX:Float = _gaps != null?_gaps.x:0;
		var gapY:Float = _gaps != null?_gaps.y:0;

		var offsetX:Float;
		var offsetY:Float;

		switch( _verticalAlign ) {
			case UiConst.CONTAINER_VERTICAL_BOTTOM:
				offsetY = height - marginB - _itemsHeight;
			case UiConst.CONTAINER_VERTICAL_MIDDLE:
				offsetY = Std.int( (height - _itemsHeight) / 2 );
			default:
				offsetY = marginT;
		}

		var z:Int = 0;
		for ( i in 0..._rows.length ) {
			switch( _horizontalAlign ) {
				case UiConst.CONTAINER_HORIZONTAL_RIGHT:
					offsetX = width - marginR - _rows[i].width;
				case UiConst.CONTAINER_HORIZONTAL_CENTER:
					offsetX = (width - _rows[i].width) / 2;
				default:
					offsetX = marginL;
			}

			for ( j in 0..._rows[i].length ) {
				if ( !cast(_items[z], UiGDisplayObject).visible ) {
					z++;
					continue;
				}

				switch( _contentAlign ) {
					case UiConst.CONTAINER_CONTENT_ALIGN_MIDDLE:
						_items[z].x = Std.int(offsetX);
						_items[z].y = Std.int(offsetY + (_rows[i].height - _items[z].height) / 2);
					case UiConst.CONTAINER_CONTENT_ALIGN_BOTTOM:
						_items[z].x = Std.int(offsetX);
						_items[z].y = Std.int(offsetY + _rows[i].height - _items[z].height);
					default:
						_items[z].x = Std.int(offsetX);
						_items[z].y = Std.int(offsetY);
				}

				if ( _moveProp != null ) {
					_moveProp(_items[z]);
				}

				offsetX += _items[z].width + gapX;
				z++;
			}
			offsetY += _rows[i].height + gapY;
		}
	}
}