package zygame.loader.parser;

import hxd.File;
import hxd.res.Image;
import hxd.fs.BytesFileSystem;
#if hl
import hxd.File;
#else
import hxd.res.Loader;
import hxd.net.BinaryLoader;
#end

/**
 * 加载图片解析器
 */
class BitmapDataParser extends BaseParser {
	public static function support(type:String):Bool {
		return type == "png" || type == "jpg";
	}

	override function process() {
		#if hl
		trace("hl load", getData());
		File.load(getData(), function(data) {
			trace("load success");
			var fs = new BytesFileEntry(getData(), data);
			var image:Image = new Image(fs);
			this.out(this, BITMAP, image, 1);
		}, function(err) {
			trace("load fail:", err);
		});
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
