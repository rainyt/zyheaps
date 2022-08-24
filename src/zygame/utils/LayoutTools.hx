package zygame.utils;

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
}
