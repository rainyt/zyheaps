package zygame.display.base;

import zygame.core.Start;

/**
 * 拖拽器
 */
class DragDividedRenderer extends ItemRenderer {
	public var bg:Quad;

	public var index:Int = -1;

	public var isEnd:Bool = false;

	public function new() {
		super();
		bg = new Quad(5, 5, 0xe0e0e0, this);
		this.width = 10;
		this.height = 5;
		this.bg.enableInteractive = true;
		bg.interactive.cursor = Move;
		this.mouseChildren = false;
	}

	override function set_width(width:Null<Float>):Null<Float> {
		bg.width = width;
		return super.set_width(width);
	}

	override function set_height(height:Null<Float>):Null<Float> {
		bg.height = height;
		return super.set_height(height);
	}
}
