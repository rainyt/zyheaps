package zygame.display;

import zygame.core.Start;
import h2d.col.Point;
import hxd.Event;
import zygame.display.base.BaseDividedBox;

/**
 * 横向的分割器，可以放置多个对象，会有一个隐藏的分界对象，拖拽可以改变大小
 */
class HDividedBox extends BaseDividedBox {
	override function onInit() {
		super.onInit();
		this.layout = new zygame.layout.DividedHorizontalLayout();
	}

	override function onMove(e:Event) {
		super.onMove(e);
		switch e.kind {
			case ERelease:
				Start.current.s2d.stopCapture();
			case EMove:
				var pos = this.globalToLocal(new Point(e.relX, e.relY));
				__moveItem.x = pos.x - __moveItem.width / 2;
				if (__moveItem.index != 0 && __moveItem.isEnd) {
					__dividedState.set(__moveItem.index, this.width - __moveItem.x);
				} else
					__dividedState.set(__moveItem.index, __moveItem.x);
				this.updateLayout();
			default:
		}
	}
}
