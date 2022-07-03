package zygame.display.data;

import zygame.res.AssetsBuilder;
import h2d.Tile;

/**
 * 按钮皮肤，如果只提供松开纹理时，则会呈现缩放效果
 */
class ButtonSkin {
	/**
	 * 松开时显示的纹理
	 */
	public var up:Tile;

	/**
	 * 按下时显示的纹理
	 */
	public var down:Tile;

	/**
	 * 构造一个按钮皮肤，如果只提供松开纹理时，则会呈现缩放效果
	 * @param up 
	 * @param down 
	 */
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
