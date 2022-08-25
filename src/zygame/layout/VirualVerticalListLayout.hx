package zygame.layout;

import haxe.Int64;
import zygame.display.data.ObjectRecycler;
import zygame.display.ItemRenderer;
import zygame.display.ListView;

/**
 * 虚拟化竖向的ListView布局，请注意，该布局会不停刷新发生变化的data，但仅使用可见的渲染项。当使用大量数据时，这个会非常有用。
 * 注意事项：虚拟布局是使用相同的高度进行计算，如果使用虚拟布局，请确保所有的高度是一样的。
 */
class VirualVerticalListLayout extends ListLayout {
	/**
	 * 设置Item的固定高度
	 */
	public var itemHeight:Null<Float> = null;

	override function updateListLayout(list:ListView, recycler:ObjectRecycler<Dynamic>) {
		super.updateListLayout(list, recycler);
		list.enableHorizontalScroll = false;
		list.enableVerticalScroll = true;
		@:privateAccess list.__moveUpdateData = true;
		var item:ItemRenderer = recycler.create();
		var itemHeight = itemHeight != null ? itemHeight : item.contentHeight;
		var counts = list.dataProvider.source.length;
		recycler.release(item);
		// 虚拟高度
		@:privateAccess list._box.height = itemHeight * counts;
		// 计算开始位置
		var visibleLen = Std.int(list.height / itemHeight) + 1;
		var startIndex = Std.int(list.scrollY / itemHeight);
		// 初始化开始渲染位置
		var offestY = startIndex * itemHeight;
		while (visibleLen > 0) {
			if (startIndex >= list.dataProvider.source.length) {
				break;
			}
			if (startIndex < 0) {
				startIndex++;
				offestY += itemHeight;
				continue;
			}
			var value = list.dataProvider.source[startIndex];
			if (value == null)
				break;
			var item:ItemRenderer = recycler.create();
			item.data = value;
			item.selected = list.hasSelectedIndex(startIndex);
			item.x = 0;
			item.width = list.width;
			item.y = offestY;
			list.addChild(item);
			offestY += item.contentHeight;
			visibleLen--;
			startIndex++;
		}
	}
}
