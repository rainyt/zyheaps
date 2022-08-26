import zygame.utils.Lib;
import zygame.utils.Assets;
import zygame.display.Quad;
import zygame.core.Start;
import zygame.res.AssetsBuilder;
import zygame.display.Scene;
import zygame.display.ScrollView;

class Object3DScene extends Scene {
	override function onInit() {
		super.onInit();
		// 创建模型
		var obj = AssetsBuilder.create3DModel("tree");
		Start.current.s3d.addChild(obj);
		obj.scale(0.25);

		Start.current.engine.backgroundColor = 0x061626;

		var scroll:ScrollView = new ScrollView();
		this.addChild(scroll);
		scroll.height = 500;

		var quad = new Quad(600, 400, 0xff0000, scroll);
		var quad2 = new Quad(300, 700, 0x00ff00, scroll);

		var assets = new Assets();
		assets.loadFile("assets/monkey.fbx");
		assets.start((f) -> {
			if (f == 1) {
				var obj = assets.create3DModel("monkey");
				Start.current.s3d.addChild(obj);
				obj.scale(0.25);
				// 快捷创建一个帧事件
				zygame.utils.FrameEngine.create((f) -> {
					obj.rotate(Lib.angleToRadian(1), Lib.angleToRadian(1), Lib.angleToRadian(1));
				});
				Lib.setTimeout(function() {
					trace("1秒后执行");
				}, 1000);
				Lib.setInterval(function() {
					// trace("每2秒执行一次");
				}, 2000);
				Lib.nextFrameCall(() -> {
					trace("下一帧调用");
				});
			}
		});

		
	}
}

