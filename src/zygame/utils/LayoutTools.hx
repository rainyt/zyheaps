package zygame.utils;

import h2d.Object;
import zygame.layout.ILayout;
import zygame.display.base.IObject;

/**
 * 布局工具
 */
class LayoutTools {
	/**
	 * 获取对应的布局
	 * @param object 
	 * @param c 
	 * @return T
	 */
	public static function getLayout<T:ILayout>(object:IObject, c:Class<T>):T {
		return cast object.layout;
	}

	/**
	 * 获取宽度
	 * @param object 
	 * @return Float
	 */
	public static function getWidth(object:Object):Float {
		if (object is IObject) {
			return cast(object, IObject).width;
		} else {
			return object.getSize().width;
		}
	}

	/**
	 * 获取高度
	 * @param object 
	 * @return Float
	 */
	public static function getHeight(object:Object):Float {
		if (object is IObject) {
			return cast(object, IObject).height;
		} else {
			return object.getSize().height;
		}
	}
}
