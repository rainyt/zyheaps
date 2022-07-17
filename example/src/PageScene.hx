import zygame.display.VBox;
import zygame.display.Button;
import zygame.display.Scene;

class PageScene extends Scene {
	override function onInit() {
		super.onInit();

		var vbox = new VBox(this);
		vbox.gap = 50;
        vbox.height = 300;

		var button = Button.create("btn_LvSe");
		vbox.addChild(button);
		button.width = 600;
		button.label.setColor(0x0);
		button.text = "返回上一个场景";
		button.onClick = function(btn, e) {
			this.replaceScene(MainScene);
		}

		var button2 = Button.create("btn_LvSe");
		vbox.addChild(button2);
		button2.width = 600;
		button2.label.setColor(0x0);
		button2.text = "返回上一个场景释放";
		button2.onClick = function(btn, e) {
			this.replaceScene(MainScene, true);
		}

		vbox.centerX = 0;
		vbox.centerY = 0;
        
	}

	override function onRelease() {
		super.onRelease();
		trace("我被释放了");
	}
}
