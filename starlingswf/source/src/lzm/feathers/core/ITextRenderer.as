/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import flash.geom.Point;

	/**
	 * Interface that handles common capabilities of rendering text.
	 *
	 * @see http://wiki.starling-framework.org/feathers/text-renderers
	 */
	public interface ITextRenderer extends IFeathersControl, ITextBaselineControl
	{
		/**
		 * The text to render.
		 */
		function get text():String;

		/**
		 * @private
		 */
		function set text(value:String):void;

		/**
		 * Determines if the text wraps to the next line when it reaches the
		 * width of the component.
		 */
		function get wordWrap():Boolean;

		/**
		 * @private
		 */
		function set wordWrap(value:Boolean):void;

		/**
		 * Measures the text's bounds (without a full validation, if
		 * possible).
		 */
		function measureText(result:Point = null):Point;
	}
}
