package zygame.res;

import zygame.utils.Assets;
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
import zygame.display.base.IDisplayObject;

/**
 * 使用XML格式创建UI
 */
class XMLBuilder extends Builder<Xml> {
	public static function parserFromId(id:String, parent:Object):Object {
		return parser(AssetsBuilder.getXml(id), parent);
	}

	public static function parser(xml:Xml, parent:Object, ids:Map<String, Object> = null):Object {
		if (ids == null) {
			ids = [];
			if (parent is IDisplayObject) {
				cast(parent, IDisplayObject).ids = ids;
			}
		}
		xml = xml.nodeType == Document ? xml.firstElement() : xml;
		var root = AssetsBuilder.builder.createInstance(xml.nodeName, xml);
		if (xml.get("id") != null) {
			ids.set(xml.get("id"), root);
		}
		parent.addChild(root);
		// 属性绑定
		for (name in xml.attributes()) {
			AssetsBuilder.builder.setProperty(root, name, xml);
		}
		for (item in xml.elements()) {
			parser(item, root, ids);
		}
		return root;
	}

	override function setProperty(display:Object, key:String, data:Xml) {
		try {
			if (key == "id") {
				display.name = key;
				return;
			}
			if (setFunc.exists(data.nodeName)) {
				if (setFunc.get(data.nodeName)(display, key, data)) {
					return;
				}
			}
			Reflect.setProperty(display, key, Std.parseFloat(data.get(key)));
		} catch (e:Exception) {}
	}

	public function new() {
		super();
		addClass(Scene);
		addClass(Box);
		addClass(Button, function(xml:Xml) {
			return Button.create(xml.get("src"));
		}, function(object, key, xml) {
			switch (key) {
				case "size":
					object.label.setSize(Std.parseInt(xml.get(key)));
				case "color":
					object.label.setColor(Std.parseInt(xml.get(key)));
				case "text":
					object.text = xml.get(key);
				default:
					return false;
			}
			return true;
		});
		addClass(HBox);
		addClass(VBox);
		addClass(Label);
		addClass(Quad);
		addClass(Image);
		addClass(Scroll);
	}
}
