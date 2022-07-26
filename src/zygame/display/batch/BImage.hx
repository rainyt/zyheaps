package zygame.display.batch;

import zygame.res.AssetsBuilder;
import h2d.Tile;
import h2d.SpriteBatch.BatchElement;

/**
 * 批渲染显示对象
 */
class BImage extends BObject {
	/**
	 * 基础显示对象
	 */
	private var _basic:BatchElement;

	public function new(tile:Dynamic) {
		var t:Tile = null;
		if (tile is String)
			t = AssetsBuilder.getBitmapDataTile(tile);
		else
			t = tile;
		_basic = new BatchElement(t);
		super();
	}
}
