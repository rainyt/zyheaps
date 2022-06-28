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
	public var width(get, set):Float;

	private var __width:Float = 0;

	function get_width():Float {
		return __width;
	}

	function set_width(width:Float):Float {
		__width = width;
		this.setDirty();
		return __width;
	}

	/**
	 * 获取图形高度
	 */
	public var height(get, set):Float;

	private var __height:Float = 0;

	function get_height():Float {
		return __height;
	}

	function set_height(height:Float):Float {
		__height = height;
		this.setDirty();
		return __height;
	}
}
