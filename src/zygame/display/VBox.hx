package zygame.display;

import zygame.layout.VerticalLayout;
import h2d.Object;

using zygame.utils.LayoutTools;

/**
 * 竖向排序的Box
 */
class VBox extends Box {
	/**
	 * 间隔
	 */
	public var gap(default, set):Float;

	private function set_gap(f:Float):Float {
		this.gap = f;
		this.getLayout(VerticalLayout).gap = f;
		return f;
	}

	public function new(?parent:Object) {
		super(parent);
		// 竖向布局
		this.layout = new VerticalLayout();
	}
}
