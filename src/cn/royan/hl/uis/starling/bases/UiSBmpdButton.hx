package cn.royan.hl.uis.starling.bases;

import cn.royan.hl.consts.PrintConst;
import cn.royan.hl.consts.UiConst;
import cn.royan.hl.interfaces.uis.IUiItemGroupBase;
import cn.royan.hl.uis.starling.InteractiveUiS;
import cn.royan.hl.utils.BitmapDataUtils;
import cn.royan.hl.utils.SystemUtils;

import flash.geom.Rectangle;

import starling.display.Image;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.textures.Texture;

/**
 * ...
 * @author RoYan
 */
class UiSBmpdButton extends InteractiveUiS, implements IUiItemGroupBase
{
	var bgTextures:Array<Texture>;
	var currentStatus:Image;
	var isInGroup:Bool;
	var freshRect:Rectangle;
	
	public function new(texture:Array<Texture>)
	{
		super();
		
		bgTextures = [];
		
		buttonMode = true;
		
		setMouseRender(true);
		
		if( Std.is( texture, Array ) ){
			bgTextures = cast(texture);
			
			type = 1;
			
			setSize(Std.int(bgTextures[0].frame != null ? bgTextures[0].frame.width : bgTextures[0].width ), 
					Std.int(bgTextures[0].frame != null ? bgTextures[0].frame.height : bgTextures[0].height ));

			while ( bgTextures.length < 5 ) {
				bgTextures.push(bgTextures[bgTextures.length - 1]);
			}
		}else {
			type = -1;
			//throw "texture is wrong type(Sparrow or Vector.<Sparrow>)";
			return;
		}
		
		currentStatus = new Image(bgTextures[status] != null?bgTextures[status]:Texture.fromBitmapData(BitmapDataUtils.fromColors(Std.int(containerWidth), Std.int(containerHeight), 
									[0x00000], [0], 1, borderColor, borderThick, borderAlpha, borderRx, borderRy)));
		if ( bgTextures[status] != null ) {
			currentStatus.texture = bgTextures[status];
		}
		addChildAt(currentStatus, 0);
	}
	
	public function setInGroup(value:Bool):Void
	{
		isInGroup = value;
	}
	
	//Public methods
	override public function draw():Void
	{
		if ( !isOnStage ) return;
		if ( type == 0 ) {
			if ( currentStatus != null ) {
				removeChild(currentStatus);
				currentStatus.dispose();
			}
			currentStatus = new Image(Texture.fromBitmapData(BitmapDataUtils.fromColors(Std.int(containerWidth), Std.int(containerHeight), 
									[0x0], [0], 1, borderColor, borderThick, borderAlpha, borderRx, borderRy)));
			addChildAt(currentStatus, 0);
		}
		if(currentStatus != null){
			if( bgTextures[status] != null )
				currentStatus.texture = bgTextures[status];
			currentStatus.scaleX = currentStatus.scaleY = getScale();
		}
	}
	
	override public function setColorsAndAplhas(color:Array<Dynamic>, alpha:Array<Dynamic>):Void 
	{
		SystemUtils.print(color+":"+alpha, PrintConst.UIS);
		bgColors = color;
		bgAlphas = alpha;
		
		while ( bgColors.length < UiConst.STATUS_LEN ) {
			bgColors.push( bgColors[bgColors.length - 1] );
		}
		
		while ( bgAlphas.length < UiConst.STATUS_LEN ) {
			bgAlphas.push( bgAlphas[bgAlphas.length - 1] );
		}
		
		for ( i in 0...bgColors.length ) {
			bgTextures[i] = Texture.fromBitmapData(BitmapDataUtils.fromColors(Std.int(containerWidth), Std.int(containerHeight), 
									bgColors[i], bgAlphas[i], 1, borderColor, borderThick, borderAlpha, borderRx, borderRy));
		}
		
		type = 0;
		
		draw();
	}
	
	public function setSelected(value:Bool):Void
	{
		selected = value;
		status = selected?UiConst.INTERACTIVE_STATUS_SELECTED:UiConst.INTERACTIVE_STATUS_NORMAL;
		draw();
	}
	
	public function getSelected():Bool
	{
		return selected;
	}
	
	public function clone():UiSBmpdButton
	{
		return new UiSBmpdButton(bgTextures);
	}
	
	override public function setTexture(value:Texture, frames:Int=5):Void{}
	
	override public function dispose():Void
	{
		super.dispose();
		
		if( bgTextures != null )
			while ( bgTextures.length > 0 ) {
				bgTextures.pop().dispose();
			}
	}
}