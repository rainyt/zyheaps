## 22.8.28
- 升级：Mac/Window SDL更新至2.24.0。
- 新增：Window新增highdpi支持。
- 改进：改进IME输入支持。
- 新增：新增Mac的文件选择器支持。

## 22.8.21
- 新增：新增`AssetsBuilder.getTexture3D`获取3D纹理。
- 新增：新增`AssetsBuilder.getBytes`获取二进制纹理。
- 修复：修复`Assets.getBitmapData`错误的类型转换。
- 新增：工具新增FBX自动转换为HDM的实现。
- 改进：改进`Assets`的获取资源id，可以是名字，也可以是完整的路径。

## 22.8.20
- 新增：新增`Progress`组件。
- 新增：新增`Quad`组件。
- 新增：新增`Button`组件。

## 22.7.25
- 修复：修复异步载入缓慢的问题。

## 22.7.24
- 新增：新增`Spine`支持。
- 新增：新增`Assets`的多线程加载支持。

## 0.0.1
- 新增：新增`Assets`资源管理器，用于加载资源使用。
- 兼容：兼容`BitmapDataParser`在微信小游戏中的正常表现。
- 新增：新增html5目标编译支持。
- 新增：新增android目标编译支持。
- 新增：新增html5压缩`-final`标识支持。
- 修改：使用`hashlink1.11`版本。（用于解决android的crash）
- 新增：新增`zygame.utils.Assets`加载器初步实现，在android上可以直接加载assets资源。
- 新增：新增资源管理的基础文件加载支持。
- 新增：新增IOS high dpi的支持。
    - 1. 需要更改Window.hl类的实现