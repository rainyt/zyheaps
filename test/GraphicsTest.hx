import zygame.display.Quad;
import zygame.core.Start;

class GraphicsTest extends Start {
	static function main() {
		Start.initApp(GraphicsTest, 1080, 1920);
	}

	override function init() {
		super.init();
		var quad = new Quad(300, 300, 0xff0000, s2d);
		quad.width = quad.stageWidth - 50;
		quad.height = quad.stageHeight - 50;
		quad.x = 25;
		quad.y = 25;
	}
}
