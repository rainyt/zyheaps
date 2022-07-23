## Spine动画
需要使用`spine-hx`库来处理Spine动画：
```xml
<haxelib name="spine-hx"/>
```

## 路线图支持
- [x] 网格渲染
- [ ] 多图渲染
- [ ] BlendMode
- [x] 遮罩（凸边形遮罩）
- [x] 基本颜色、透明
- [x] 单个Spine合批渲染
- [ ] SpriteBatch-Spine渲染器

## 加载Spine动画
```haxe
var assets = new ZAssets();
assets.loadSpineAtlas(["assets/spineName.png"], "assets/spineName.atlas");
assets.loadFile("assets/spineName.json");
assets.start(function(f){
    if(f == 1){
        // Spine加载完成
    }
});
```

## 创建Spine动画
在资源一切就绪的情况下，开始创建：
```haxe
var spine:Spine = assets.createSpine(spineName, spineName);
this.addChild(spine);
spine.play("actionName");
```

## Spine的相关API
Spine的所有API，都可以直接访问`skeleton`或者`animationState`。