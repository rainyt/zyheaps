package zygame.skins;

import h3d.mat.Texture;
import zygame.display.Graphics;

/**
 * 基础皮肤类
 */
class BaseSkin extends Graphics {
	public function new() {
		super();
	}

	/**
	 * 请重写该方法，实现自定义的渲染
	 */
	public function readyGraphics():Void {}

	public function build(texture:Texture, x:Float, y:Float):Void {
		this.readyGraphics();
		this.x = x;
		this.y = y;
		this.drawTo(texture);
	}
}
