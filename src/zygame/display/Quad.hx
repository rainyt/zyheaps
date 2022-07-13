package zygame.display;

import zygame.core.Start;
import zygame.display.base.IDisplayObject;
import h2d.RenderContext;
import zygame.display.base.BaseGraphics;
import h2d.Object;

/**
 * 一个矩形对象，可以对它设置高宽设置大小
 */
class Quad extends BaseGraphics implements IDisplayObject {
	public var dirt:Bool = false;

	/**
	 * 距离左边
	 */
	public var left:Null<Float>;

	/**
	 * 距离右边
	 */
	public var right:Null<Float>;

	/**
	 * 距离顶部
	 */
	public var top:Null<Float>;

	/**
	 * 距离底部
	 */
	public var bottom:Null<Float>;

	/**
	 * 居中X
	 */
	public var centerX:Null<Float>;

	/**
	 * 居中Y
	 */
	public var centerY:Null<Float>;

	/**
	 * 布局自身
	 */
	public function layout():Void {}

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

	public function new(width:Float, height:Float, color:UInt = 0x0, parent:Object = null) {
		super(parent);
		this.width = width;
		this.height = height;
		this.__quadColor = color;
		this.setDirty();
	}

	private function change():Void {
		this.clear();
		this.beginFill(__quadColor);
		this.drawRect(0, 0, this.width, this.height);
		this.endFill();
		this.setDirty(false);
	}

	override function draw(ctx:RenderContext) {
		if (dirty) {
			change();
		}
		super.draw(ctx);
	}

	public function get_stageWidth():Float {
		return Start.current.stageWidth;
	}

	/**
	 * 获取舞台宽度
	 */
	public var stageWidth(get, never):Float;

	public function get_stageHeight():Float {
		return Start.current.stageHeight;
	}

	/**
	 * 获取舞台高度
	 */
	public var stageHeight(get, never):Float;
}
