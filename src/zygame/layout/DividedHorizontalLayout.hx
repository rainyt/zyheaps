package zygame.layout;

import zygame.display.base.IDisplayObject;
import zygame.display.base.DragDividedRenderer;
import zygame.display.HDividedBox;
import h2d.Object;
import zygame.display.base.IObject;

using zygame.utils.LayoutTools;

/**
 * 横向切割器的布局计算处理
 */
class DividedHorizontalLayout extends HorizontalLayout {
	override public function updateLayout(self:IObject, children:Array<Object>) {
		// 重新排序
		var view:HDividedBox = cast self;
		var dragChilds = @:privateAccess view.children.filter((f) -> f is DragDividedRenderer);
		view.removeChildren();
		var childs = view.getChilds().copy();
		if (childs.length == 1) {
			var ichild:IDisplayObject = cast childs[0];
			ichild.left = ichild.right = ichild.top = ichild.bottom = 0;
			@:privateAccess view.superAddChild(childs[0]);
		} else if (childs.length > 1) {
			// 左边
			var left = childs[0];
			var right = childs[childs.length - 1];

			var item:DragDividedRenderer = cast(dragChilds[0] == null ? view.createDragItemRenderer() : dragChilds[0]);
			var itemWidth = item.contentWidth;
			var allWidth = view.width - (childs.length - 1) * itemWidth;
			var cCounts = childs.length;
			var maxWidth = allWidth - (childs.length - 1) * itemWidth;
			var offest = 0.;

			function mathItem(index:Int, object:Object, isFillAll:Bool, setFixWidth:Null<Float> = null):Void {
				var pWidth = allWidth / cCounts;
				cCounts--;
				var divideWidth:Null<Float> = @:privateAccess view.__dividedState.get(index);
				var fixWidth = divideWidth == null ? pWidth : divideWidth - offest;
				if (setFixWidth != null)
					fixWidth = setFixWidth;
				if (fixWidth < 10) {
					fixWidth = 10;
				} else if (fixWidth > maxWidth) {
					fixWidth = maxWidth;
				}

				if (index < childs.length - 1) {
					fixWidth -= index * itemWidth;
					offest += fixWidth;
				} else {
					fixWidth -= itemWidth;
				}
				var idsipaly:IDisplayObject = cast object;
				if (!isFillAll) {
					idsipaly.width = fixWidth;
					allWidth -= fixWidth;
					maxWidth -= fixWidth;
				} else {
					idsipaly.width = allWidth;
				}
				idsipaly.top = idsipaly.bottom = 0;
			}

			// 先预处理左边
			mathItem(0, left, false, null);
			// 在处理右边
			if (childs.length > 2) {
				var divideWidth:Null<Float> = @:privateAccess view.__dividedState.get(childs.length - 2);
				mathItem(childs.length - 1, right, false, divideWidth == null ? null : divideWidth);
			} else {
				mathItem(childs.length - 1, right, false);
			}

			var len = childs.length - 1;
			for (index in 1...len) {
				var object = childs[index];
				mathItem(index, object, index == len - 1);
			}

			// 开始添加组件
			for (index => object in childs) {
				var idsipaly:IDisplayObject = cast object;
				@:privateAccess view.superAddChild(object);
				if (index < childs.length - 1) {
					var dragItem:DragDividedRenderer = cast(dragChilds[index] == null ? view.createDragItemRenderer() : dragChilds[index]);
					dragItem.index = index;
					dragItem.isEnd = index == childs.length - 2;
					@:privateAccess view.superAddChild(dragItem);
					var idsipaly:IDisplayObject = cast dragItem;
					idsipaly.top = idsipaly.bottom = 0;
				}
			}
		}
		super.updateLayout(self, children);
	}
}
