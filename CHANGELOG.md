## 0.0.2
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