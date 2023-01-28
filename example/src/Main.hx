import hxd.Window;
import zygame.utils.SceneManager;
import h2d.SpriteBatch;
import zygame.core.Start;

class Main extends Start {
	static function main() {
		Start.initApp(Main, 1080, 1920, true);
	}

	var imgs:Array<BasicElement> = [];

	override function init() {
		super.init();

		// Window.getInstance().vsync = false;
		// Window.getInstance().title = "123";

		s2d.defaultSmooth = true;

		engine.backgroundColor = 0xffffffff;

		#if hl
		zygame.display.Label.defaultFont = "assets/DroidSansFallbackFull.ttf";
		#end

		SceneManager.replaceScene(MainScene);


	}

	override function onResize() {
		super.onResize();
	}

	override function update(dt:Float) {
		super.update(dt);
	}
}
