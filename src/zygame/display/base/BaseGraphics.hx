package zygame.display.base;

import h2d.Graphics;

/**
 * 基础的绘制类型
 */
class BaseGraphics extends Graphics {
	/**
	 * 脏标记
	 */
	public var dirty:Bool = false;

	/**
	 * 设置脏
	 */
	inline public function setDirty(d:Bool = true):Void {
		dirty = d;
	}

	/**
	 * 获取图形宽度
	 */
	public var width(default, set):Null<Float>;

	function set_width(width:Null<Float>):Null<Float> {
		this.width = width;
		this.setDirty();
		return width;
	}

	/**
	 * 获取图形高度
	 */
	public var height(default, set):Null<Float>;

	function set_height(height:Null<Float>):Null<Float> {
		this.height = height;
		this.setDirty();
		return height;
	}
}
