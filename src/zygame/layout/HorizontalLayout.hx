package zygame.layout;

import h2d.Object;
import zygame.display.base.IObject;

class HorizontalLayout extends Layout {
	public var gap:Float = 0;

	override public function updateLayout(self:IObject, children:Array<Object>) {
		// 重新排序
		var offestX = 0.;
		for (object in children) {
			object.x = offestX;
			offestX += gap;
			if (object is IObject) {
				offestX += cast(object, IObject).width;
			} else {
				offestX += object.getSize().width;
			}
		}
	}
}
