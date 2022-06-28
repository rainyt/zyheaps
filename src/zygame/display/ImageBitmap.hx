package zygame.display;

import zygame.core.Start;
import zygame.display.base.IDisplayObject;
import h2d.Bitmap;

/**
 * 图片显示对象
 */
class ImageBitmap extends Bitmap implements IDisplayObject {
	public function get_stageWidth():Float {
		return Start.current.stageWidth;
	}

	public var stageWidth(get, never):Float;

	public function get_stageHeight():Float {
		return Start.current.stageHeight;
	}

	public var stageHeight(get, never):Float;
}
