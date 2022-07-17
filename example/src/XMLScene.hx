import zygame.display.Button;
import zygame.res.XMLBuilder;
import zygame.display.Scene;

/**
 * XML格式的UI测试
 */
class XMLScene extends Scene {
	override function onInit() {
		super.onInit();
		XMLBuilder.parserFromId("XmlScene", this);
        get("button",Button).onClick = function(btn,e){
            this.replaceScene(MainScene);
        };
	}
}
