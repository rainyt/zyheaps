package zygame.display;

import h2d.Object;
import zygame.display.data.ObjectRecycler;
import zygame.display.base.IItemRenderer;

/**
 * 默认列表渲染器
 */
class DefalutItemRenderer extends ItemRenderer {
	/**
	 * 默认的渲染器
	 */
	public static var recycler:ObjectRecycler<DefalutItemRenderer> = new ObjectRecycler(() -> {
		return new DefalutItemRenderer();
	}, (display) -> {
		display.data = null;
		display.selected = false;
	});

	public var label:Label = new Label();

	override function onInit() {
		super.onInit();
		this.addChild(label);
		this.height = 50;
	}

	override function set_data(value:Dynamic):Dynamic {
		if (value is Float) {
			value = Std.string(value);
		}
		this.label.text = value == null ? "" : value;
		return super.set_data(value);
	}
}
