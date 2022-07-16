package zygame.display.base;

import h2d.Object;

function layoutIDisplayObject(display:IDisplayObject):Void {
	if (display.parent != null) {
		var w = 0.;
		var h = 0.;
		if (display.parent is IDisplayObject) {
			var display:IDisplayObject = cast display.parent;
			w = display.width;
			h = display.height;
		}
		if (display.left != null) {
			display.x = display.left;
		}
		if (display.top != null) {
			display.y = display.top;
		}
		if (display.right != null) {
			if (display.left != null) {
				// 改变宽度
				display.width = w - display.right - display.left;
			} else {
				// 改变位置
				display.x = w - display.right - display.width;
			}
		} else if (display.centerX != null) {
			if (display.left != null) {
				// 改变宽度
				display.width = w / 2 - display.centerX - display.left;
			} else {
				// 改变位置
				display.x = w / 2 - display.centerX - display.width / 2;
			}
		}
		if (display.bottom != null) {
			if (display.top != null) {
				// 改变宽度
				display.height = h - display.bottom - display.top;
			} else {
				// 改变位置
				display.y = h - display.bottom - display.height;
			}
		} else if (display.centerY != null) {
			if (display.top != null) {
				// 改变宽度
				display.height = h / 2 - display.centerY - display.top;
			} else {
				// 改变位置
				display.y = h / 2 - display.centerY - display.height / 2;
			}
		}
		var obj:Object = cast display;
		for (i in 0...obj.numChildren) {
			var c = obj.getChildAt(i);
			if (c is IDisplayObject) {
				cast(c, IDisplayObject).layout();
			}
		}
	}
}

interface IDisplayObject {
	public var dirt:Bool;

	public var stageWidth(get, never):Float;

	public var stageHeight(get, never):Float;

	/**
	 * The parent object in the scene tree.
	 */
	public var parent(default, null):Object;

	/**
	 * The x position (in pixels) of the object relative to its parent.
	 */
	public var x(default, set):Float;

	/**
	 * The y position (in pixels) of the object relative to its parent.
	 */
	public var y(default, set):Float;

	/**
	 * 宽度
	 */
	public var width(default, set):Null<Float>;

	/**
	 * 高度
	 */
	public var height(default, set):Null<Float>;

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
	public function layout():Void;
}
