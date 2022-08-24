package zygame.layout;

import zygame.display.ItemRenderer;
import zygame.display.ListView;
import zygame.display.data.ObjectRecycler;

/**
 * 流列表布局
 */
class FlowListLayout extends ListLayout {
	override function updateListLayout(list:ListView, recycler:ObjectRecycler<Dynamic>) {
		super.updateListLayout(list, recycler);
		list.enableHorizontalScroll = false;
		list.enableVerticalScroll = true;
		var offestY = 0.;
		var offestX = 0.;
		for (value in list.dataProvider.source) {
			var item:ItemRenderer = recycler.create();
			var iwidth = item.contentWidth;
			if (offestX + iwidth > list.width) {
				offestY += item.contentHeight;
				offestX = 0;
			}
			item.x = offestX;
			offestX += iwidth;
			item.width = list.width;
			item.y = offestY;
			list.addChild(item);
			item.data = value;
		}
	}
}
