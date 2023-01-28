import zygame.utils.Assets;
import zygame.display.Scene;

class SpineScene extends Scene {
	override function onInit() {
		super.onInit();
		var assets = new Assets();
		var spineName = "slk";
		assets.loadSpineAtlas(["assets/" + spineName + ".png"], "assets/" + spineName + ".atlas");
		assets.loadFile("assets/" + spineName + ".json");
		assets.start(function(f) {
			if (f == 1) {
				for (i in 0...30) {
					var spine = assets.createSpine(spineName, spineName);
					this.addChild(spine);
					spine.width = 1;
					spine.height = 1;
					spine.scale(3);
					spine.centerX = 0;
					spine.centerY = 0;
					spine.play("idle");
					spine.x = Math.random() * stageWidth;
					spine.y = Math.random() * stageHeight;
				}
			}
		});
	}
}
