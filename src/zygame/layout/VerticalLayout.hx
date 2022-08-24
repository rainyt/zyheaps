package zygame.layout;

import zygame.display.base.IObject;
import h2d.Object;

/**
 * 竖向排序的布局
 */
class VerticalLayout extends Layout {
	public var gap:Float = 0;

	override public function updateLayout(self:IObject, children:Array<Object>) {
		// 重新排序
		var offestY = 0.;
		for (object in children) {
			object.y = offestY;
			offestY += gap;
			if (object is IObject) {
				offestY += cast(object, IObject).height;
			} else {
				offestY += object.getSize().height;
			}
		}
	}
}
