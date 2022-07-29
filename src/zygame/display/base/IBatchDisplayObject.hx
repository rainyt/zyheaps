package zygame.display.base;

import zygame.display.batch.BObject;

inline private function getWidth(display:IBatchDisplayObject):Float {
	if (display.width == null) {
		return cast(display, BObject).getSize().width;
	} else {
		return display.width;
	}
}

inline private function getHeight(display:IBatchDisplayObject):Float {
	if (display.height == null) {
		return cast(display, BObject).getSize().height;
	} else {
		return display.height;
	}
}

function layoutIDisplayObject(display:IBatchDisplayObject):Void {
	if (display.parent != null) {
		// 先处理子布局
		var obj:BObject = cast display;
		for (i in 0...obj.numChildren) {
			var c = obj.getChildAt(i);
			if (c is IDisplayObject) {
				cast(c, IDisplayObject).layout();
			}
		}
		// 后布局
		var w = 0.;
		var h = 0.;
		var dw = getWidth(display);
		var dh = getHeight(display);
		if (display.parent is IBatchDisplayObject) {
			var display:IBatchDisplayObject = cast display.parent;
			w = getWidth(display);
			h = getHeight(display);
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
				display.width = w - display.right - display.left - 1;
			} else {
				// 改变位置
				display.x = w - display.right - dw - 1;
			}
		} else if (display.centerX != null) {
			if (display.left != null) {
				// 改变宽度
				display.width = w / 2 - display.centerX - display.left - 1;
			} else {
				// 改变位置
				display.x = w / 2 - display.centerX - dw / 2 - 1;
			}
		}
		if (display.bottom != null) {
			if (display.top != null) {
				// 改变宽度
				display.height = h - display.bottom - display.top - 1;
			} else {
				// 改变位置
				display.y = h - display.bottom - dh - 1;
			}
		} else if (display.centerY != null) {
			if (display.top != null) {
				// 改变宽度
				display.height = h / 2 + display.centerY - display.top - 1;
			} else {
				// 改变位置
				display.y = h / 2 + display.centerY - dh / 2 - 1;
			}
		}
		trace(display, display.x, display.y);
	} else {
		trace(display, "为什么没父节点");
	}
}

interface IBatchDisplayObject {
	public var dirt:Bool;

	public var stageWidth(get, never):Float;

	public var stageHeight(get, never):Float;

	/**
	 * The parent object in the scene tree.
	 */
	public var parent(default, null):BObject;

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
	 * 角度
	 */
	public var rotation(default, set):Null<Float>;

	/**
		The amount of horizontal scaling of this object.
	**/
	public var scaleX(default, set):Float;

	/**
		The amount of vertical scaling of this object.
	**/
	public var scaleY(default, set):Float;

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

	/**
	 * 初始化入口
	 */
	public function onInit():Void;

	// /**
	//  * 映射ID
	//  */
	// public var ids:Map<String, Object>;
	// /**
	//  * 获取对应ID的组件
	//  * @param id
	//  * @param T
	//  * @return T
	//  */
	// public function get<T:Object>(id:String, c:Class<T>):T;
}
