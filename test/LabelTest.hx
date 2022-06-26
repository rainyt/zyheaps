package;

import h3d.Engine;
import h2d.Font;
import hxd.res.FontBuilder;
import hxd.Event;
import zygame.display.Label;
import zygame.core.Start;

class LabelTest extends Start {
	static function main() {
		var app = new LabelTest();
	}

	public function new() {
		super();
	}

	override function init() {
		super.init();
		font = FontBuilder.getFont("黑体", 56, {
			chars: "我直接显示中文怎么了"
		});
	}

	public var times = 1000;

	public var font:Font;

	public var label:Label;

	override function update(dt:Float) {
		super.update(dt);
		times--;
		if (times > 0) {
			label = new Label();
			this.s2d.add(label);
			label.useFont = font;
			label.setColor(0xff0000);
			label.text = "我直接显示中文怎么了！";
			label.x = Math.random() * s2d.width;
			label.y = Math.random() * s2d.height;
		}
        label.x += 0.2;
		trace(Engine.getCurrent().drawCalls);
	}
}
