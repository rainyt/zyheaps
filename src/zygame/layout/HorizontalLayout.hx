package zygame.layout;

import h2d.Interactive;
import h2d.Object;
import zygame.display.base.IObject;

using zygame.utils.LayoutTools;

class HorizontalLayout extends Layout {
	public var gap:Float = 0;

	override public function updateLayout(self:IObject, children:Array<Object>) {
		// 重新排序
		var offestX = 0.;
		for (object in children) {
			if (object is Interactive)
				continue;
			object.x = offestX;
			offestX += gap;
			offestX += object.getWidth();
		}
	}
}
