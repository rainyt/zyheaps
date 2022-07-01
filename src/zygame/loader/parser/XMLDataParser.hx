package zygame.loader.parser;

import zygame.utils.AssetsUtils;

class XMLDataParser extends BaseParser {
	public static function support(type:String):Bool {
		return type == "xml";
	}

	override function process() {
		super.process();
		AssetsUtils.loadBytes(getData(), function(data) {
			var obj = Xml.parse(data.toString());
			this.out(this, XML, obj, 1);
		}, error);
	}
}
