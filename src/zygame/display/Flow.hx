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
}
