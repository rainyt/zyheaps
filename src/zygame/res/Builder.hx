package zygame.res;

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
		classDefine.set(name, c);
	}
}
