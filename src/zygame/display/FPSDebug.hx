package zygame.display;

import h3d.Engine;
import hxd.res.DefaultFont;
import h2d.Text;

class FPSDebug extends Text {
	public function new() {
		super(DefaultFont.get());
        this.setScale(4);
		this.textColor = 0xff0000;
	}

	public function update():Void {
		this.text = "FPS:"
			+ Engine.getCurrent().fps
			+ "\nDrawCall:"
			+ Engine.getCurrent().drawCalls
			+ "\nTri:"
			+ Engine.getCurrent().drawTriangles;
	}
}
