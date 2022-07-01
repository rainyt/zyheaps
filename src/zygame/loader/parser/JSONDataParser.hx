package zygame.loader.parser;

import zygame.utils.AssetsUtils;
import haxe.Json;

class JSONDataParser extends BaseParser {
	public static function support(type:String):Bool {
		return type == "json";
	}

	override function process() {
		AssetsUtils.loadBytes(getData(), function(data) {
			var obj = Json.parse(data.toString());
			this.out(this, JSON, obj, 1);
		}, error);
	}
}
