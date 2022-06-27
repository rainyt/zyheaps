import h2d.Bitmap;
import h2d.Graphics;
import h2d.SpriteBatch;
import zygame.display.Label;
import zygame.display.ImageBitmap;
import zygame.utils.Assets;
import zygame.core.Start;

class ImageTest extends Start {
	static function main() {
		hxd.Res.initEmbed();
		#if wechat
		untyped window.start = function() {
			new ImageTest();
		}
		#else
		new ImageTest();
		#end
	}

	public function new() {
		super();
	}

	private var _imgs:Array<ImageBitmap> = [];

	override function init() {
		super.init();
		// 构造一个加载器
		var assets:Assets = new Assets();
		assets.loadFile("img.png");
		assets.start(function(f) {
			if (f == 1) {
				var sprite:SpriteBatch = new SpriteBatch(assets.getBitmapDataTile("img"), s2d);
				// 加载完成，渲染图片
				for (i in 0...1000) {
					var bmd = new BatchElement(sprite.tile);
					sprite.add(bmd);
					// var bmd = new ImageBitmap(assets.getBitmapDataTile("img"));
					// var bmd = new ImageBitmap(hxd.Res.img.toTile());
					// Start.current.s2d.add(bmd);
					// sprite.addChild(bmd);
					bmd.x = Std.random(Start.current.s2d.width);
					bmd.y = Std.random(Start.current.s2d.height);
					// _imgs.push(bmd);
				}
				var tile = assets.getBitmapDataTile("img");
				tile.setCenterRatio();
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
