package zygame.layout;

import zygame.display.ItemRenderer;
import zygame.display.DefalutItemRenderer;
import zygame.display.ListView;
import zygame.display.base.IObject;
import h2d.Object;

/**
 * 竖向的ListView布局
 */
class VerticalListLayout extends Layout {
	override function updateLayout(self:IObject, children:Array<Object>) {
		super.updateLayout(self, children);
		var list:ListView = cast self;
		list.enableHorizontalScroll = false;
		list.enableVerticalScroll = true;
		if (list.dataProvider == null) {
			return;
		}
		var recycler = list.itemRendererRecycler;
		if (recycler == null) {
			recycler = cast DefalutItemRenderer.recycler;
		}
		// 布局渲染
		var box = @:privateAccess list._box;
		var childs = @:privateAccess box.children;
		if (childs.length > 0) {
			if (recycler.testClass(childs[0])) {
				for (object in childs) {
					// 回收
					recycler.release(cast object);
				}
			}
			// 直接清空
			box.removeChildren();
		}
		trace("刷新了？");
		var offestY = 0.;
		for (index => value in list.dataProvider.source) {
			var item:ItemRenderer = recycler.create();
			item.x = 0;
			item.width = list.width;
			item.y = offestY;
			list.addChild(item);
			item.data = value;
			offestY += item.contentHeight;
		}
	}
}
