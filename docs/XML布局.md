## XML布局
通过XML进行简单的布局实现：
```xml
<Scene>
    <VBox centerX="0" centerY="0" gap="50">
        <Quad width="100" height="100" color="0xff0000" centerX="0">
            <Image src="FetterDescAtlas:et1001" centerX="0" centerY="0"/>
        </Quad>
        <Button id="button" src="btn_LvSe" color="0x0" text="返回" centerX="0" centerY="200"/>
        <Label id="label" text="大家好，我是一串文字噢！" color="0x0" size="80" centerX="0" centerY="-200"/>
    </VBox>
    <Quad width="100" height="100" left="50" top="50" />
    <Quad width="100" height="100" right="50" top="50" />
    <Quad width="100" height="100" bottom="50" right="50" />
    <Quad width="100" height="100" bottom="50" left="50" />
    <Image src="btn_LvSe" left="50" centerY="0"/>
</Scene>
```

## 解析UI
当所有资源准备就绪后，则可以通过构造UI：
```haxe
/**
 * XML格式的UI测试
 */
class XMLScene extends Scene {
	override function onInit() {
		super.onInit();
        // 开始解析
		XMLBuilder.parserFromId("XmlAssetsId", this);
        // 可通过get方式获取对应id的对象
        get("button",Button).onClick = function(btn,e){
            this.replaceScene(MainScene);
        };
	}
}
```