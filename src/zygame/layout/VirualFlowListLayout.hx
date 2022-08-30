package zygame.layout;

import zygame.display.data.ObjectRecycler;
import zygame.display.ItemRenderer;
import zygame.display.ListView;

/**
 * 虚拟化流ListView布局，请注意，该布局会不停刷新发生变化的data，但仅使用可见的渲染项。当使用大量数据时，这个会非常有用。
 * 注意事项：虚拟布局是使用相同的宽度、高度进行计算，如果使用虚拟布局，请确保所有的宽度、高度是一样的。
 */
class VirualFlowListLayout extends ListLayout {
	override function updateListLayout(list:ListView, recycler:ObjectRecycler<Dynamic>) {
		super.updateListLayout(list, recycler);
		list.enableHorizontalScroll = false;
		list.enableVerticalScroll = true;
		@:privateAccess list.__moveUpdateData = true;
		var item:ItemRenderer = recycler.create();
		var itemWidth = item.contentWidth;
		var itemHeight = item.contentHeight;
		var counts = list.dataProvider.source.length;
		recycler.release(item);
		// 虚拟宽度
		var visibleXLen = Std.int(list.width / itemWidth);
		var v = counts / visibleXLen;
		@:privateAccess list._box.height = itemHeight * (Std.int(v) + (v > Std.int(v) ? 1 : 0));
		// 计算开始位置
		var visibleYLen = Std.int(list.height / itemHeight) + 1;
		var startIndex = Std.int(list.scrollY / itemHeight) * visibleXLen;
		// 初始化开始渲染位置
		var offestY = (Std.int(startIndex / visibleXLen) * itemHeight);
		while (visibleYLen > 0) {
			var offestX = 0.;
			for (i in 0...visibleXLen) {
				if (startIndex >= list.dataProvider.source.length) {
					break;
				}
				if (startIndex < 0) {
					startIndex++;
					offestX += itemWidth;
					continue;
				}
				var value = list.dataProvider.source[startIndex];
				if (value == null)
					break;
				var item:ItemRenderer = recycler.create();
				item.listView = list;
				item.data = value;
				item.selected = list.hasSelectedIndex(startIndex);
				item.y = offestY;
				item.x = offestX;
				list.addChild(item);
				offestX += item.contentWidth;
				startIndex++;
			}
			offestY += item.contentHeight;
			visibleYLen--;
		}
	}
}
