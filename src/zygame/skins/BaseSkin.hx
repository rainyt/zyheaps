package zygame.skins;

import hxd.clipper.Rect;
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

	/**
	 * 请重写该方法，实现自定义的九宫格数据，并通过`builder.setScale9Grid`设置九宫格图数据
	 * @param builder 
	 */
	public function readyScale9Grid():Rect {
		return null;
	}

	public function build(texture:Texture, x:Float, y:Float):Void {
		this.readyGraphics();
		this.x = x;
		this.y = y;
		this.drawTo(texture);
	}
}
