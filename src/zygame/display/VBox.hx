package zygame.display;

import zygame.display.base.IDisplayObject;

/**
 * 竖向排序的Box
 */
class VBox extends Box {
	/**
	 * 间隔
	 */
	public var gap:Float = 0;

	override function layout() {
		super.layout();
		// 重新排序
		var offestY = 0.;
		for (object in this.children) {
			object.y = offestY;
			offestY += gap;
			if (object is IDisplayObject) {
				offestY += cast(object, IDisplayObject).height;
			} else {
				offestY += object.getSize().height;
			}
		}
	}
}
