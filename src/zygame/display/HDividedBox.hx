package zygame.display;

import zygame.display.base.BaseDividedBox;

/**
 * 横向的分割器，可以放置多个对象，会有一个隐藏的分界对象，拖拽可以改变大小
 */
class HDividedBox extends BaseDividedBox {
	override function onInit() {
		super.onInit();
		this.layout = new zygame.layout.DividedHorizontalLayout();
	}
}
