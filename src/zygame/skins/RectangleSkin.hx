package zygame.skins;

import hxd.clipper.Rect;

/**
 * 矩形皮肤
 */
class RectangleSkin extends BaseSkin {
	/**
	 * 背景颜色
	 */
	public var backgroundColor:Int = 0xffffff;

	/**
	 * 圆角
	 */
	public var radius:Float = 0;

	/**
	 * 准备绘制
	 */
	override function readyGraphics() {
		super.readyGraphics();
		this.beginFill(backgroundColor);
		if (this.radius > 0) {
			this.drawRoundedRect(0, 0, radius * 4, radius * 4, radius);
		} else
			this.drawRect(0, 0, 5, 5);
	}

	override function readyScale9Grid():Rect {
		super.readyScale9Grid();
		if (this.radius > 0) {
			var i = Std.int(radius);
			return new Rect(i, i, i, i);
		} else {
			return new Rect(2, 2, 2, 2);
		}
	}
}
