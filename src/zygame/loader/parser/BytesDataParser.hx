package zygame.loader.parser;

import zygame.utils.AssetsUtils;

class BytesDataParser extends BaseParser {
	public static function support(type:String):Bool {
		return true;
	}

	override function process() {
		AssetsUtils.loadBytes(getData(), function(data) {
			this.out(this, BYTES, data, 1);
		}, error);
	}
}
