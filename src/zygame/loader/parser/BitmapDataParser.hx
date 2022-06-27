package zygame.loader.parser;

import hxd.fs.BytesFileSystem;
import hxd.net.BinaryLoader;

/**
 * 加载图片解析器
 */
class BitmapDataParser extends BaseParser {
	public static function support(type:String):Bool {
		return type == "png" || type == "jpg";
	}

	override function process() {
		var loader = new BinaryLoader(getData());
		loader.onProgress = function(a, b) {
			trace("加载进度：", a, b);
		}
		loader.onLoaded = function(data) {
			var fs = new BytesFileEntry(getData(), data);
			fs.loadBitmap(function(data) {
				this.out(this, BITMAP, data, 1);
			});
		};
		loader.onError = function(err) {
			trace("加载失败：", err);
		}
		loader.load();
	}
}
