import zygame.core.Start;
import zygame.display.Label;
import zygame.display.Quad;

class Main extends Start {
	override function init() {
		super.init();

        this.engine.backgroundColor = 0xffffffff;

		var quad = new Quad(300, 300, 0xff0000, s2d);
		quad.x = 25;
		quad.width = quad.stageWidth - 50;
		quad.y = 25;
		quad.height = quad.stageHeight - 50;

		var tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
		tf.text = "Hello World!";
		tf.setScale(4);
	}

	static function main() {
		Start.initApp(Main, 1080, 1920);
	}
}
