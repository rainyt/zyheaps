package zygame.display;

import zygame.display.base.IDisplayObject;

/**
 * 横向排序的Box
 */
class HBox extends Box {
	/**
	 * 间隔
	 */
	public var gap:Float = 0;

	override function updateLayout() {
		super.updateLayout();
		// 重新排序
		var offestX = 0.;
		for (object in this.children) {
			object.x = offestX;
			offestX += gap;
			if (object is IDisplayObject) {
				offestX += cast(object, IDisplayObject).width;
			} else {
				offestX += object.getSize().width;
			}
		}
	}
}
