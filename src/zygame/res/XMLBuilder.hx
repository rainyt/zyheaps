package zygame.res;

import haxe.Exception;
import h2d.Object;
import zygame.display.Scene;
import zygame.display.Scroll;
import zygame.display.Image;
import zygame.display.Quad;
import zygame.display.Label;
import zygame.display.VBox;
import zygame.display.HBox;
import zygame.display.Button;
import zygame.display.Box;

/**
 * 使用XML格式创建UI
 */
class XMLBuilder extends Builder<Xml> {
	public static function parserFromId(id:String, parent:Object):Object {
		return parser(AssetsBuilder.getXml(id), parent);
	}

	public static function parser(xml:Xml, parent:Object):Object {
		xml = xml.nodeType == Document ? xml.firstElement() : xml;
		var root = AssetsBuilder.builder.createInstance(xml.nodeName, xml);
		parent.addChild(root);
		// 属性绑定
		for (name in xml.attributes()) {
			try {
				Reflect.setProperty(root, name, Std.parseFloat(xml.get(name)));
			} catch (e:Exception) {}
		}
		for (item in xml.elements()) {
			parser(item, root);
		}
		return root;
	}

	public function new() {
		super();
		addClass(Scene);
		addClass(Box);
		addClass(Button, function(xml:Xml) {
			return Button.create(xml.get("src"));
		});
		addClass(HBox);
		addClass(VBox);
		addClass(Label);
		addClass(Quad);
		addClass(Image);
		addClass(Scroll);
	}
}
