package zygame.display.base;

import zygame.layout.ILayout;
import h2d.Tile;
import h2d.Object;

inline function getWidth(display:IDisplayObject):Float {
	if (display.width == null) {
		return cast(display, Object).getSize().width;
	} else {
		return display.width;
	}
}

inline function getHeight(display:IDisplayObject):Float {
	if (display.height == null) {
		return cast(display, Object).getSize().height;
	} else {
		return display.height;
	}
}

/**
 * 一个通用的数据转换
 * @param data 
 * @return IDisplayObject
 */
inline function convertIDisplayObject(data:Dynamic, ?parent:Object):IDisplayObject {
	if (data is Tile || data is String) {
		return new Image(data, parent);
	}
	if (data is IDisplayObject) {
		if (parent != null) {
			parent.addChild(cast data);
		}
		return cast data;
	}
	return null;
}

function layoutIDisplayObject(display:IDisplayObject):Void {
	if (display.parent is IDisplayObject) {
		var dw = getWidth(cast display.parent);
		var dh = getHeight(cast display.parent);
	}
	if (display.parent != null) {
		// 后布局
		var w = 0.;
		var h = 0.;
		var dw = getWidth(display);
		var dh = getHeight(display);
		if (display.parent is IDisplayObject) {
			var display:IDisplayObject = cast display.parent;
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
		var obj:Object = cast display;
		for (i in 0...obj.numChildren) {
			var c = obj.getChildAt(i);
			if (c is IDisplayObject) {
				cast(c, IDisplayObject).updateLayout();
			}
		}
		if (display.layout != null && display.layout.autoLayout) {
			display.layout.updateLayout(display, @:privateAccess cast(display, Object).children);
		}
	}
}

interface IDisplayObject extends IObject {
	public final function getSize(?out:h2d.col.Bounds):h2d.col.Bounds;

	/**
	 * The parent object in the scene tree.
	 */
	public var parent(default, null):Object;

	/**
	 * 映射ID
	 */
	public var ids:Map<String, Object>;

	/**
	 * 获取对应ID的组件
	 * @param id 
	 * @param T 
	 * @return T
	 */
	public function get<T:Object>(id:String, c:Class<T>):T;

	public var contentWidth(get, null):Float;

	public var contentHeight(get, null):Float;
}
