package zygame.layout;

import zygame.display.base.BaseDividedBox;
import zygame.display.base.IDisplayObject;
import zygame.display.base.DragDividedRenderer;
import h2d.Object;
import zygame.display.base.IObject;

using zygame.utils.LayoutTools;

/**
 * 竖向切割器的布局计算处理
 */
class DividedVerticalLayout extends VerticalLayout {
	override public function updateLayout(self:IObject, children:Array<Object>) {
		// 重新排序
		var view:BaseDividedBox = cast self;
		var dragChilds = @:privateAccess view.children.filter((f) -> f is DragDividedRenderer);
		var allChilds = @:privateAccess view.children;
		// view.removeChildren();
		var childs = view.getChilds();
		var delChilds = allChilds.filter((f) -> childs.indexOf(f) == -1);
		for (object in delChilds) {
			view.removeChild(object);
		}
		if (childs.length == 1) {
			var ichild:IDisplayObject = cast childs[0];
			ichild.left = ichild.right = ichild.top = ichild.bottom = 0;
			if (childs[0].parent == null)
				@:privateAccess view.superAddChild(childs[0]);
		} else if (childs.length > 1) {
			var item:DragDividedRenderer = cast(dragChilds[0] == null ? view.createDragItemRenderer() : dragChilds[0]);
			var itemHeight = item.contentHeight;
			var allHeight = view.height - (childs.length - 1) * itemHeight;
			var cCounts = childs.length;
			var maxHeight = allHeight - (childs.length - 1) * itemHeight;
			var offest = 0.;

			function mathItem(index:Int, object:Object, isFillAll:Bool, setFixWidth:Null<Float> = null):Void {
				var pHeight = allHeight / cCounts;
				cCounts--;
				var divideHeight:Null<Float> = @:privateAccess view.__dividedState.get(index);
				var fixHeight = divideHeight == null ? pHeight : divideHeight - offest;
				if (setFixWidth != null)
					fixHeight = setFixWidth;
				if (fixHeight < 10) {
					fixHeight = 10;
				} else if (fixHeight > maxHeight) {
					fixHeight = maxHeight;
				}

				if (index < childs.length - 1) {
					fixHeight -= index * itemHeight;
					offest += fixHeight;
				} else {
					fixHeight -= itemHeight;
				}
				var idsipaly:IDisplayObject = cast object;
				if (!isFillAll) {
					idsipaly.height = fixHeight;
					allHeight -= fixHeight;
					maxHeight -= fixHeight;
				} else {
					idsipaly.height = allHeight;
				}
				idsipaly.left = idsipaly.right = 0;
			}

			// 开始与结尾
			var start = childs[0];
			var end = childs[childs.length - 1];
			// 先预处理左边
			mathItem(0, start, false, null);
			// 在处理右边
			if (childs.length > 2) {
				var divideWidth:Null<Float> = @:privateAccess view.__dividedState.get(childs.length - 2);
				mathItem(childs.length - 1, end, false, divideWidth == null ? null : divideWidth);
			} else {
				mathItem(childs.length - 1, end, true);
			}

			var len = childs.length - 1;
			for (index in 1...len) {
				var object = childs[index];
				mathItem(index, object, index == len - 1);
			}

			var cindex = 0;
			// 开始添加组件
			for (index => object in childs) {
				var idsipaly:IDisplayObject = cast object;
				if (object.parent == null)
					@:privateAccess view.superAddChild(object, cindex);
				cindex++;
				if (index < childs.length - 1) {
					var dragItem:DragDividedRenderer = cast(dragChilds[index] == null ? view.createDragItemRenderer() : dragChilds[index]);
					dragItem.index = index;
					dragItem.isEnd = index == childs.length - 2;
					if (dragItem.parent == null)
						@:privateAccess view.superAddChild(dragItem, cindex);
					cindex++;
					var idsipaly:IDisplayObject = cast dragItem;
					idsipaly.left = idsipaly.right = 0;
				}
			}
		}
		super.updateLayout(self, children);
	}
}
