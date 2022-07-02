package zygame.display.data;

import zygame.res.AssetsBuilder;
import h2d.Tile;

/**
	按钮皮肤
**/
class ButtonSkin {
	public var up:Tile;

	public var down:Tile;

	public function new(up:Dynamic, ?down:Dynamic) {
		if (up is String) {
			up = AssetsBuilder.getBitmapDataTile(up);
		}
		if (down is String) {
			down = AssetsBuilder.getBitmapDataTile(down);
		}
		this.up = up;
		this.down = down;
	}
}
