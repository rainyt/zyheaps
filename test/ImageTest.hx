import zygame.display.ImageBitmap;
import h3d.Engine;
import zygame.utils.Assets;
import hxd.BitmapData;
import zygame.core.Start;

class ImageTest extends Start {
	static function main() {
		new ImageTest();
	}

	public function new() {
		super();
	}

	private var _imgs:Array<ImageBitmap> = [];

	override function init() {
		super.init();
		var assets:Assets = new Assets();
		assets.loadFile("img.jpg");
		assets.start(function(f) {
			trace("加载ing：", f);
			if (f == 1) {
				// 加载完成
				trace("加载完成", assets.getBitmapDataTile("img"));
				for (i in 0...1000) {
					var bmd = new ImageBitmap(assets.getBitmapDataTile("img"));
					Start.current.s2d.add(bmd);
					bmd.x = Std.random(Start.current.s2d.width);
					bmd.y = Std.random(Start.current.s2d.height);
                    _imgs.push(bmd);
				}
			}
		});
	}

	override function update(dt:Float) {
		super.update(dt);
		for (bitmap in _imgs) {
            bitmap.rotation += 0.1;
        }
	}
}
