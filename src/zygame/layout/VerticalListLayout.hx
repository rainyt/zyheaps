package zygame.layout;

import zygame.display.data.ObjectRecycler;
import zygame.display.ItemRenderer;
import zygame.display.ListView;

/**
 * 竖向的ListView布局
 */
class VerticalListLayout extends ListLayout {
	override function updateListLayout(list:ListView, recycler:ObjectRecycler<Dynamic>) {
		super.updateListLayout(list, recycler);
		list.enableHorizontalScroll = false;
		list.enableVerticalScroll = true;
		var offestY = 0.;
		for (index => value in list.dataProvider.source) {
			var item:ItemRenderer = recycler.create();
			item.data = value;
			item.selected = list.hasSelectedIndex(index);
			item.x = 0;
			item.width = list.width;
			item.y = offestY;
			list.addChild(item);
			offestY += item.contentHeight;
		}
	}
}
