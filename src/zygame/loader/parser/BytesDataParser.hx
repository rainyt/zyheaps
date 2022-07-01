package zygame.loader.parser;

import haxe.io.Bytes;
import zygame.utils.AssetsUtils;

class BytesDataParser extends BaseParser {
	// private static var gc:Map<String, Bytes> = [];
	public static function support(type:String):Bool {
		return true;
	}

	override function process() {
		AssetsUtils.loadBytes(getData(), function(data) {
			// 对它进行引用
			// gc.set(this.getData(), data);
			this.out(this, BYTES, data, 1);
		}, error);
	}
}
