package zygame.display;

import zygame.core.Start;
import zygame.display.base.IDisplayObject;
import h2d.RenderContext;
import zygame.display.base.BaseGraphics;
import h2d.Object;

/**
 * 一个矩形对象，可以对它设置高宽设置大小
 */
class Quad extends BaseGraphics {
	public var radius(default, set):UInt;

	private function set_radius(v:UInt):UInt {
		this.radius = v;
		this.dirt = true;
		return v;
	}

	/**
	 * 矩形的颜色
	 */
	public var quadColor(get, set):UInt;

	private var __quadColor:UInt = 0;

	function get_quadColor():UInt {
		return __quadColor;
	}

	function set_quadColor(quadColor:UInt):UInt {
		__quadColor = quadColor;
		this.setDirty();
		return __quadColor;
	}

	public function new(width:Float, height:Float, color:UInt = 0x0, parent:Object = null, radius:UInt = 0) {
		super(parent);
		this.width = width;
		this.height = height;
		this.__quadColor = color;
		this.radius = radius;
		this.setDirty();
		onInit();
	}

	override function onAdd() {
		super.onAdd();
		this.setDirty();
	}

	private function change():Void {
		this.clear();
		this.beginFill(__quadColor);
		if (radius > 0)
			this.drawRoundedRect(0, 0, this.width, this.height, radius);
		else
			this.drawRect(0, 0, this.width, this.height);
		this.endFill();
	}

	override function draw(ctx:RenderContext) {
		if (dirt) {
			change();
		}
		super.draw(ctx);
	}
}
