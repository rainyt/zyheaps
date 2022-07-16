package zygame.res;

import haxe.Exception;
import h2d.Object;

/**
 * 使用XML格式创建UI
 */
class XMLBuilder {
	public static function parserFromId(id:String, parent:Object):Object {
		return parser(AssetsBuilder.getXml(id), parent);
	}

	public static function parser(xml:Xml, parent:Object):Object {
		xml = xml.nodeType == Document ? xml.firstElement() : xml;
		var root = AssetsBuilder.builder.createInstance(xml.nodeName);
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
}
