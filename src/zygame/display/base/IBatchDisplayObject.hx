package zygame.display.base;

import zygame.layout.ILayout;
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
				cast(c, IDisplayObject).updateLayout();
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
	}
}

interface IBatchDisplayObject extends IObject {
	/**
	 * The parent object in the scene tree.
	 */
	public var parent(default, null):BObject;
}
