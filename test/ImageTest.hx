import zygame.res.AssetsBuilder;
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
		Start.initApp(ImageTest, 1080, 1920);
	}

	private var _imgs:Array<BatchElement> = [];

	override function init() {
		super.init();
		// 构造一个加载器
		var assets:Assets = new Assets();
		AssetsBuilder.bindAssets(assets);
		assets.loadFile("img.png");
		assets.start(function(f) {
			if (f == 1) {
				var tile = AssetsBuilder.getBitmapDataTile("img");
				var sprite:SpriteBatch = new SpriteBatch(tile, s2d);
				sprite.hasRotationScale = true;
				// 加载完成，渲染图片
				for (i in 0...3000) {
					var bmd = new BatchElement(sprite.tile);
					sprite.add(bmd);
					bmd.x = Std.random(Start.current.s2d.width);
					bmd.y = Std.random(Start.current.s2d.height);
					_imgs.push(bmd);
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
