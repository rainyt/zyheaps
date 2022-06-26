package;

import zygame.display.Label;
import zygame.core.Start;

class MainTest extends Start {
	static function main() {
		var app = new MainTest();
	}

	public function new() {
		super();
	}

	override function init() {
		super.init();

		var label = new Label();
		this.s2d.add(label);
		label.setSize(36);
        label.setColor(0xff0000);
		label.text = "我直接显示中文怎么了！";

	}
}
