package zygame.layout;

import zygame.display.data.ObjectRecycler;
import zygame.display.ItemRenderer;
import zygame.display.ListView;

/**
 * 横向的ListView布局
 */
class HorizontalListLayout extends ListLayout {
	override function updateListLayout(list:ListView, recycler:ObjectRecycler<Dynamic>) {
		super.updateListLayout(list, recycler);
		list.enableHorizontalScroll = true;
		list.enableVerticalScroll = false;
		var offestX = 0.;
		for (value in list.dataProvider.source) {
			var item:ItemRenderer = recycler.create();
			item.y = 0;
			item.height = list.height;
			item.x = offestX;
			list.addChild(item);
			item.data = value;
			offestX += item.contentWidth;
		}
	}
}
