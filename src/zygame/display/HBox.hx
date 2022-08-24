package zygame.display;

import h2d.Object;
import zygame.layout.HorizontalLayout;

using zygame.utils.LayoutTools;

/**
 * 横向排序的Box
 */
class HBox extends Box {
	/**
	 * 间隔
	 */
	public var gap(default, set):Float;

	private function set_gap(f:Float):Float {
		this.gap = f;
		this.getLayout(HorizontalLayout).gap = f;
		return f;
	}

	public function new(?parent:Object) {
		super(parent);
		// 竖向布局
		this.layout = new HorizontalLayout();
	}
}
