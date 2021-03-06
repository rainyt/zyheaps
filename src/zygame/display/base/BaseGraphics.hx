package zygame.display.base;

import zygame.utils.SceneManager;
import h2d.Object;
import zygame.core.Start;
import h2d.Graphics;
import zygame.display.base.IDisplayObject;

/**
 * 基础的绘制类型
 */
class BaseGraphics extends Graphics implements IDisplayObject {
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

	public function get_stageWidth():Float {
		return Start.current.stageWidth;
	}

	override function addChildAt(s:Object, pos:Int) {
		@:privateAccess SceneManager.setDirt();
		super.addChildAt(s, pos);
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

	/**
	 * 布局自身
	 */
	public function layout():Void {
		layoutIDisplayObject(this);
		this.x;
	}

	public function onInit():Void {}

	/**
	 * 设置脏
	 */
	inline public function setDirty(d:Bool = true):Void {
		dirt = d;
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

	public var ids:Map<String, Object>;

	public function get<T:Object>(id:String, c:Class<T>):T {
		if (ids != null)
			return cast ids.get(id);
		return null;
	}
}
