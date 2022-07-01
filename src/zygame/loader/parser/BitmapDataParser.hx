package zygame.loader.parser;

import zygame.utils.AssetsUtils;
import hxd.res.Image;
import hxd.fs.BytesFileSystem;

/**
 * 加载图片解析器
 */
class BitmapDataParser extends BaseParser {
	public static function support(type:String):Bool {
		return type == "png" || type == "jpg";
	}

	override function process() {
		AssetsUtils.loadBytes(getData(), function(data) {
			trace("bitmapsize", getData(), data.length);
			var fs = new BytesFileEntry(getData(), data);
			var image:Image = new Image(fs);
			this.out(this, BITMAP, image, 1);
		}, error);
	}
}
