package cn.royan.hl.systems;

import flash.display.Stage;
import flash.system.Capabilities;

/**
 * ...
 * @author RoYan
 */
class DeviceCapabilities
{
	public static var tabletScreenMinimumInches:Float = 5;

		/**
		 * A custom width, in pixels, to use for calculations of the device's
		 * physical screen size. Set to NaN to use the actual width.
		 */
		public static var screenPixelWidth:Float = 0;

		/**
		 * A custom height, in pixels, to use for calculations of the device's
		 * physical screen size. Set to NaN to use the actual height.
		 */
		public static var screenPixelHeight:Float = 0;
		
		/**
		 * The DPI to be used by Feathers. Defaults to the value of
		 * <code>Capabilities.screenDPI</code>, but may be overridden. For
		 * example, if one wishes to demo a mobile app in the desktop browser,
		 * a custom DPI will override the real DPI of the desktop screen. 
		 */
		public static var dpi:Int = Std.int( Capabilities.screenDPI );

		/**
		 * Determines if this device is probably a tablet, based on the physical
		 * width and height, in inches, calculated using the full-screen
		 * dimensions and the screen DPI.
		 */
		public static function isTablet(stage:Stage):Bool
		{
			var screenWidth:Float = Math.isFinite(screenPixelWidth) ? stage.fullScreenWidth : screenPixelWidth;
			var screenHeight:Float = Math.isFinite(screenPixelHeight) ? stage.fullScreenHeight : screenPixelHeight;
			return (Math.max(screenWidth, screenHeight) / dpi) >= tabletScreenMinimumInches;
		}

		/**
		 * Determines if this device is probably a phone, based on the physical
		 * width and height, in inches, calculated using the full-screen
		 * dimensions and the screen DPI.
		 */
		public static function isPhone(stage:Stage):Bool
		{
			return !isTablet(stage);
		}

		/**
		 * The physical width of the device, in inches. Calculated using the
		 * full-screen width and the screen DPI.
		 */
		public static function screenInchesX(stage:Stage):Float
		{
			var screenWidth:Float = Math.isFinite(screenPixelWidth) ? stage.fullScreenWidth : screenPixelWidth;
			return screenWidth / dpi;
		}

		/**
		 * The physical height of the device, in inches. Calculated using the
		 * full-screen height and the screen DPI.
		 */
		public static function screenInchesY(stage:Stage):Float
		{
			var screenHeight:Float = Math.isFinite(screenPixelHeight) ? stage.fullScreenHeight : screenPixelHeight;
			return screenHeight / dpi;
		}
	
}