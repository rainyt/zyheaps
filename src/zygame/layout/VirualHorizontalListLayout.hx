package zygame.layout;

import haxe.Int64;
import zygame.display.data.ObjectRecycler;
import zygame.display.ItemRenderer;
import zygame.display.ListView;

/**
 * 虚拟化横向的ListView布局，请注意，该布局会不停刷新发生变化的data，但仅使用可见的渲染项。当使用大量数据时，这个会非常有用。
 * 注意事项：虚拟布局是使用相同的宽度进行计算，如果使用虚拟布局，请确保所有的宽度是一样的。
 */
class VirualHorizontalListLayout extends ListLayout {
	override function updateListLayout(list:ListView, recycler:ObjectRecycler<Dynamic>) {
		super.updateListLayout(list, recycler);
		list.enableHorizontalScroll = true;
		list.enableVerticalScroll = false;
		@:privateAccess list.__moveUpdateData = true;
		var item:ItemRenderer = recycler.create();
		var itemWidth = item.contentWidth;
		var counts = list.dataProvider.source.length;
		recycler.release(item);
		// 虚拟宽度
		@:privateAccess list._box.width = itemWidth * counts;
		// 计算开始位置
		var visibleLen = Std.int(list.width / itemWidth) + 1;
		var startIndex = Std.int(list.scrollX / itemWidth);
		// 初始化开始渲染位置
		var offestX = startIndex * itemWidth;
		while (visibleLen > 0) {
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
			item.y = 0;
			item.height = list.height;
			item.x = offestX;
			list.addChild(item);
			item.data = value;
			item.selected = list.hasSelectedIndex(startIndex);
			offestX += item.contentWidth;
			visibleLen--;
			startIndex++;
		}
	}
}
