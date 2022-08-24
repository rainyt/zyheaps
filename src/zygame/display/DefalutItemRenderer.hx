package zygame.display;

import zygame.display.data.ObjectRecycler;
import zygame.display.base.IItemRenderer;

/**
 * 默认列表渲染器
 */
class DefalutItemRenderer extends Box implements IItemRenderer {
	/**
	 * 默认的渲染器
	 */
	public static var recycler:ObjectRecycler<DefalutItemRenderer> = new ObjectRecycler(() -> {
		return new DefalutItemRenderer();
	}, (display) -> {
		display.data = null;
		display.selected = null;
	});

	public var data(default, set):Dynamic;

	public function set_data(value:Dynamic):Dynamic {
		this.data = value;
		return value;
	}

	public var selected(default, set):Bool;

	public function set_selected(value:Bool):Bool {
		this.selected = value;
		return value;
	}
}
