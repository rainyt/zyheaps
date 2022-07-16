package zygame.res;

import zygame.display.Scene;
import zygame.utils.StringUtils;
import zygame.display.Scroll;
import zygame.display.Image;
import zygame.display.Quad;
import zygame.display.Label;
import zygame.display.VBox;
import zygame.display.HBox;
import zygame.display.Button;
import zygame.display.Box;

/**
 * 一个UI构造器，内置一些构造的基础配置
 */
class Builder {
	/**
	 * UI类型定义
	 */
	public var classDefine:Map<String, Class<Dynamic>> = [];

	public function new() {
		// 这是基础类型
		addClass(Scene);
		addClass(Box);
		addClass(Button);
		addClass(HBox);
		addClass(VBox);
		addClass(Label);
		addClass(Quad);
		addClass(Image);
		addClass(Scroll);
	}

	/**
	 * 追加一个类型绑定
	 * @param c 
	 */
	public function addClass(c:Class<Dynamic>):Void {
		var name = Type.getClassName(c);
		var array = name.split(".");
		classDefine.set(array[array.length - 1], c);
	}

	/**
	 * 创建类型的单例，可以通过Box这种简写获取正确的类型对象
	 * @param type 
	 * @param array 
	 * @return Dynamic
	 */
	public function createInstance(type:String, array:Array<Dynamic> = null):Dynamic {
		var c = classDefine.get(type);
		if (c == null) {
			c = Type.resolveClass(type);
		}
		return Type.createInstance(c, array == null ? [] : array);
	}
}
