import zygame.display.TextInput;
import zygame.display.Scene;

class InputScene extends Scene {
	override function onInit() {
		super.onInit();
		// 测试输入法
		var input:TextInput = new TextInput();
		// input.setSize(80);
		// input.backgroundColor = 0xffff0000;
		this.addChild(input);
		// input.inputWidth = 300;
		input.height = 80;
		input.left = 20;
		input.right = 20;
		input.centerY = 100;
	}
}
