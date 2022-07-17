## UI自动构造
通过`zygame.macro.AutoXMLBuilder.build("xmlid")`宏可以自动构造出UI界面，同时会对包含`id`的组件编译成变量，可以直接在Haxe中直接访问。
```haxe
@:build(zygame.macro.AutoXMLBuilder.build("xmlid"))
class Test extends Scene {
    override public function onInit():Void{
        this.button.onClick = function(btn,e){}
    }
}
```

## LoaderXMLScene
如果继承的是`zygame.display.LoaderXMLScene`对象，则会进行载入资源，同时会判断`AssetsBuilder`中是否已经存在这个资源，当存在时，则会直接跳过，不进行加载。
```haxe
@:build(zygame.macro.AutoXMLBuilder.build("xmlid"))
class Test extends LoaderXMLScene {
    override public function onBuilded():Void{
        this.button.onClick = function(btn,e){}
    }

    /**
     * 自定义加载
     **/
    override public function onLoad():Void{
        // 如需要加载其他额外资源，请在这里对assets进行载入
        this.assets.loadFile("test.png");
    }
}
```
注意：`LoaderXMLScene`由于会有需要加载的情况，需要使用`onBuilded`代替`onInit`。

## 其他容器
该`zygame.macro.AutoXMLBuilder`宏支持在其他`h2d.Object`对象上进行使用。