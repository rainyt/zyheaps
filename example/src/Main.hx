import zygame.display.Quad;
import zygame.core.Start;

class Main extends Start {
	static function main() {
		Start.initApp(Main, 1080, 1920);
	}

	override function init() {
		super.init();
		var quad = new Quad(300, 300, 0xff0000, s2d);
		quad.y = quad.x = 300;
	}
}
