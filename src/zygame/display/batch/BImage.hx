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

	public var tile(get, set):Tile;

	private function set_tile(t:Tile):Tile {
		_basic.t = t;
		if (t != null) {
			this.width = t.width;
			this.height = t.height;
		}
		return t;
	}

	private function get_tile():Tile {
		return _basic.t;
	}

	public function new(tile:Dynamic = null, ?parent:BObject) {
		var t:Tile = null;
		if (tile is String)
			t = AssetsBuilder.getBitmapDataTile(tile);
		else
			t = tile;
		_basic = new BatchElement(t);
		this.tile = t;
		super(parent);
	}
}
