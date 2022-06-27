package;

import h3d.Engine;
import h2d.Font;
import hxd.res.FontBuilder;
import hxd.Event;
import zygame.display.Label;
import zygame.core.Start;

class LabelTest extends Start {
	static function main() {
		Start.initApp(LabelTest);
	}

	public function new() {
		super(1080,1920);
	}

	override function init() {
		super.init();
		Engine.getCurrent().backgroundColor = 0xffffffff;
	}

	public var times = 100;

	public var label:Label;

	override function update(dt:Float) {
		super.update(dt);
		times--;
		if (times > 0) {
			label = new Label();
			this.s2d.add(label);
			label.setColor(0xff0000);
			label.setSize(80);
			label.text = "我直接显示中文怎么了！我直接显示中文怎么了！";
			label.x = Math.random() * s2d.width;
			label.y = Math.random() * s2d.height;
		}
        label.x += 0.2;
	}
}
