package zygame.layout;

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
		if (list.dataProvider == null) {
			return;
		}
		var recycler = list.itemRendererRecycler;
		if (recycler == null) {
			recycler = DefalutItemRenderer.recycler;
		}
        // 布局渲染
	}
}
