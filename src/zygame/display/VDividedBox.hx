package zygame.display;

import h2d.col.Point;
import hxd.Event;
import zygame.core.Start;
import zygame.display.base.BaseDividedBox;

/**
 * 竖向的分割器，可以放置多个对象，会有一个隐藏的分界对象，拖拽可以改变大小
 */
class VDividedBox extends BaseDividedBox {
	override function onInit() {
		super.onInit();
		this.layout = new zygame.layout.DividedVerticalLayout();
	}

	override function onMove(e:Event) {
		super.onMove(e);
		switch e.kind {
			case ERelease:
				Start.current.s2d.stopCapture();
			case EMove:
				var pos = this.globalToLocal(new Point(e.relX, e.relY));
				__moveItem.y = pos.y - __moveItem.height / 2;
				if (__moveItem.index != 0 && __moveItem.isEnd) {
					__dividedState.set(__moveItem.index, this.width - __moveItem.y);
				} else
					__dividedState.set(__moveItem.index, __moveItem.y);
				this.updateLayout();
			default:
		}
	}
}
