package zygame.layout;

import zygame.display.base.IObject;
import h2d.Object;
import zygame.display.ItemRenderer;
import zygame.display.ListView;
import zygame.display.data.ObjectRecycler;

using zygame.utils.LayoutTools;

/**
 * 流列表布局
 */
class FlowLayout extends Layout {
	override function updateLayout(self:IObject, children:Array<Object>) {
		super.updateLayout(self, children);
		// 重新排序
		var offestY = 0.;
		var offestX = 0.;
		for (item in children) {
			var iwidth = item.getWidth();
			if (offestX + iwidth > self.width) {
				offestY += item.getHeight();
				offestX = 0;
			}
			item.x = offestX;
			offestX += iwidth;
			item.y = offestY;
		}
	}
}
