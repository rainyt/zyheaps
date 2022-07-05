## zyheaps
- 这是一个基于heaps引擎之上的简化版api。旨意让它拥有可用的Android/IOS/Mac/Window/HTML5/小游戏等平台开箱即用的能力。
- This is a simplified API based on the heaps engine. The purpose is to make it have the out of the box ability of available android/ios/mac/window/html5/ games and other platforms.

## Record problems
The current status is open, and there will be a lot of problems to be solved.

## Development installation
```shell
haxelib git zyheaps https://github.com/rainyt/zyheaps.git
```

## Heaps版本
建议使用rainyt分叉的heaps版本：[https://github.com/rainyt/heaps](https://github.com/rainyt/heaps)，它兼容了IOS高DPI，触摸等问题。当`HeapsIo/heaps`正式修正了这些问题后，将合并版本。

|  Support   | IOS  | Android |
|  ----  | ----  | --- |
| 默认的高DPI(High DPI)  | yes | yes |
| 正常触摸(Touch)  | yes | yes |
| 中文渲染TTF(Font TTF)  | yes | yes |
| XML格式精灵图(Sprite XML format)  | yes | yes |
| 动态加载资源(Dynamic load assets)  | yes | yes |

## UI Component
- [x] 色块(Quad) zygame.display.Quad
- [x] 文本(Label) zygame.display.Label （支持中文的文本组件）
- [x] 按钮(Button) zygame.display.Button
- [x] 图片/九宫格图片(ImageBitmap) zygame.display.ImageBitmap
- [ ] 列表/列表Item
- [ ] 场景管理
- [ ] UI自动构造器

## Document description
- [使用文档](https://github.com/rainyt/zyheaps/wiki/%E5%9F%BA%E7%A1%80%E4%BD%BF%E7%94%A8%E6%96%87%E6%A1%A3%EF%BC%88%E4%B8%AD%E6%96%87%EF%BC%89)
- [Use Document](https://github.com/rainyt/zyheaps/wiki/Use-(EN))

## Project inspiration
- IOS:[https://github.com/qkdreyer/heaps-ios](https://github.com/qkdreyer/heaps-ios)
- Android:[https://github.com/altef/heaps-android](https://github.com/altef/heaps-android)
- LimeTools:[https://github.com/jgranick/lime-tools](https://github.com/jgranick/lime-tools)
- Gylyphme:[https://github.com/micomuko/glyphme](https://github.com/micomuko/glyphme)