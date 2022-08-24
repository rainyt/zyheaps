package zygame.display;

import h2d.Object;
import zygame.display.data.ObjectRecycler;
import zygame.display.base.IItemRenderer;

class ItemRenderer extends Box implements IItemRenderer {

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

	public function new(?parent:Object) {
		super(parent);
	}
}
