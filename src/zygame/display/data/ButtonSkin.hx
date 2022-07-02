package zygame.display.data;

import h2d.Tile;

/**
	按钮皮肤
**/
class ButtonSkin {
	public var up:Tile;

	public var down:Tile;

	public function new(up:Tile, ?down:Tile) {
		this.up = up;
		this.down = down;
	}
}
