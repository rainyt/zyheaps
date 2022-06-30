package zygame.loader.parser;

import hxd.res.Loader;
import hxd.res.Image;
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
		#if hl
		trace("CPP Platform is unavailable.");
		#else
		var loader = new BinaryLoader(getData());
		loader.onProgress = function(a, b) {
			trace("加载进度：", a, b);
		}
		loader.onLoaded = function(data) {
			var fs = new BytesFileEntry(getData(), data);
			var image:Image = new Image(fs);
			this.out(this, BITMAP, image, 1);
		};
		loader.onError = function(err) {
			trace("加载失败：", err);
		}
		loader.load();
		#end
	}
}
