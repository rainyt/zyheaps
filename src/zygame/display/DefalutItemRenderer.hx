package zygame.display;

import hxd.Event;
import haxe.Json;
import h2d.Object;
import zygame.display.data.ObjectRecycler;
import zygame.display.base.IItemRenderer;

/**
 * 默认列表渲染器
 */
class DefalutItemRenderer extends ItemRenderer {
	/**
	 * 移入Quad
	 */
	public var overDisplay:Quad;

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

	public function new(?parent:Object) {
		super(parent);
		this.height = 50;
		overDisplay = new Quad(5, 5, 0xe0e0e0, this);
		overDisplay.left = 0;
		overDisplay.right = 0;
		overDisplay.top = 0;
		overDisplay.bottom = 0;
		overDisplay.alpha = 0;
		this.addChild(label);
		label.centerX = 0;
		label.centerY = 0;
		this.interactive.onOver = onOver;
		this.interactive.onOut = onOut;
	}

	override function set_data(value:Dynamic):Dynamic {
		if (value is Float) {
			value = Std.string(value);
		}
		if (!(value is String)) {
			value = "[Object]";
		}
		this.label.text = value == null ? "" : value;
		label.updateLayout();
		return super.set_data(value);
	}

	private function onOver(e:Event) {
		overDisplay.alpha = 1;
		overDisplay.updateLayout();
	}

	private function onOut(e:Event) {
		overDisplay.alpha = 0;
	}

	override function onRemove() {
		super.onRemove();
		overDisplay.alpha = 0;
	}
}
