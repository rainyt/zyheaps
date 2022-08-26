import h2d.Object;
import zygame.display.data.ButtonSkin;
import zygame.display.batch.BObject;
import zygame.display.SceneBatch;
import zygame.display.batch.BImage;
import zygame.display.batch.BButton;
import zygame.display.Quad;
import zygame.display.Scene;

class BatchScene extends Scene {
	private var group = new BObject();

	public function new(?parent:Object) {
		super(parent);
		// group.width = stageWidth;
		// group.height = stageHeight;
	}

	override function onInit() {
		super.onInit();

		new Quad(stageWidth, stageHeight, 0x061616, this);

		// 创建一个批处理场景
		var spriteBatch = new SceneBatch("FetterDescAtlas", this);
		// 创建一个批处理精灵图
		var img:BImage = new BImage("FetterDescAtlas:et1001");
		// 创建一个批处理容器
		group.x = 100;
		group.y = 100;
		group.addChild(img);

		for (i in 0...10) {
			var img:BImage = new BImage("FetterDescAtlas:et1001");
			group.addChild(img);
			img.x = 200 - Math.random() * 400;
			img.y = Math.random() * 400;
		}

		// 添加到批处理对象中
		spriteBatch.group.addChild(group);

		// 放到舞台中间
		group.centerX = 0;
		group.centerY = 0;

		trace("group=", group.getSize());

		// 放一个按钮
		var skin = new ButtonSkin("FetterDescAtlas:et1002");
		var button = new BButton(skin);
		spriteBatch.group.addChild(button);
		button.centerX = 0;
		button.centerY = 0;
		// button.x = stageWidth / 2;
		// button.y = stageHeight / 2;
		button.onClick = function(btn, e) {
			trace("点击成功");
		}
	}

	override function update(dt:Float) {
		super.update(dt);
		// group.x++;
		// group.rotation++;
		// if (group.scaleY > -1)
		// 	group.scaleY -= 0.01;

		// if (group.scaleX > -1)
		// 	group.scaleX -= 0.01;
	}
}
