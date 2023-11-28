import h2d.Tile;
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
		Start.current.s3d.camera.pos.z = 15;
		obj.scale(1);
		obj.x = -1;
		var tree = obj;

		Start.current.engine.backgroundColor = 0x061626;

		var assets = new Assets();
		assets.loadFile("assets/monkey.fbx");
		assets.loadFile("assets/cude.fbx");
		assets.start((f) -> {
			if (f == 1) {
				var cude = assets.create3DModel("cude");
				Start.current.s3d.addChild(cude);
				cude.scale(1);
				cude.x = 1;

				var obj = assets.create3DModel("monkey");
				Start.current.s3d.addChild(obj);
				obj.scale(1);
				// 快捷创建一个帧事件
				zygame.utils.FrameEngine.create((f) -> {
					cude.rotate(Lib.angleToRadian(1), Lib.angleToRadian(1), Lib.angleToRadian(1));
					obj.rotate(Lib.angleToRadian(1), Lib.angleToRadian(1), Lib.angleToRadian(1));
					tree.rotate(Lib.angleToRadian(1), Lib.angleToRadian(1), Lib.angleToRadian(1));
				});
			}
		});

		var light = new h3d.scene.fwd.DirLight(new h3d.Vector(0.5, 0.5, -0.5), Start.current.s3d);
		light.enableSpecular = true;
	}
}
