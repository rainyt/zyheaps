## zyheaps
这是一个基于heaps引擎之上的简化版api。旨意让它拥有可用的Android/IOS/Mac/Window/HTML5/小游戏等平台开箱即用的能力。

## 记录问题
当前状态是开放中，会存在大量问题需要解决。

## HTML5目标
使用HTML5目标时，编译可使用：
```shell
haxelib run zyheaps build html5
```
当需要测试HTML5目标时：
```shell
haxelib run zyheaps test html5
```

## 安卓目标
编译安卓时，需要配置好对应的NDK版本号：
```xml
<!-- NDK目录 -->
<define name="NDK_DIR" value=""/>
<!-- Android SDK目录 -->
<define name="ANDROID_SDK_DIR" value=""/>
<!-- NDK版本 -->
<define name="NDK_VERSION" value=""/>
```
再通过以下命令进行快速编译：
```shell
haxelib run zyheaps build android
```