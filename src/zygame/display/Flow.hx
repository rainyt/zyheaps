package zygame.display;

import zygame.core.Start;
import zygame.display.base.IDisplayObject;

class Flow extends h2d.Flow implements IDisplayObject {
	public var dirt:Bool = false;

	public function get_stageWidth():Float {
		return Start.current.stageWidth;
	}

	public var stageWidth(get, never):Float;

	public function get_stageHeight():Float {
		return Start.current.stageHeight;
	}

	public var stageHeight(get, never):Float;

	public var width(get, set):Float;

	private var _width:Float;

	function get_width():Float {
		return _width;
	}

	function set_width(width:Float):Float {
		_width = width;
		dirt = true;
		return _width;
	}

	public var height(get, set):Float;

	private var _height:Float;

	function get_height():Float {
		return _height;
	}

	function set_height(height:Float):Float {
		_height = height;
		dirt = true;
		return _height;
	}
}
