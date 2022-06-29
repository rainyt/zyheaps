## zyheaps
这是一个基于heaps引擎之上的简化版api。旨意让它拥有可用的Android/IOS/Mac/Window/HTML5/小游戏等平台开箱即用的能力。
This is a simplified API based on the heaps engine. The purpose is to make it have the out of the box ability of available android/ios/mac/window/html5/ games and other platforms.

## 记录问题
当前状态是开放中，会存在大量问题需要解决。
The current status is open, and there will be a lot of problems to be solved.

## 开发安装
```shell
haxelib git zyheaps https://github.com/rainyt/zyheaps.git
```

## 项目基础配置
需要在项目根目录下，建立一个`zyheaps.xml`文件，它跟openfl的`project.xml`功能相似。但功能还未完全实现。它基于[https://github.com/jgranick/lime-tools](https://github.com/jgranick/lime-tools)实现。一个基础的配置：
You need to create a `zyheaps.xml` file, which is similar to openfl's `project.xml` has similar functions. However, the function has not been fully realized.
```xml
<project>
    <meta title="ILandes" package="com.sample.ilandes" version="1.0.0" company="Company Name" />
    <!-- 指定类型 -->
    <app main="Main" path="Export" file="ILandes"/>
    <!-- 指定资源目录 -->
    <assets path="Assets" rename="assets" />
    <!-- 指定库 -->
    <haxelib name="zyheaps" />
    <haxelib name="heaps" />
    <!-- 指定源码位置 -->
    <source name="src" />
    <!-- 安卓配置 -->
    <define name="NDK_DIR" value="/Users/xxxxxx/Documents/SDK/android-ndk-r18b" />
    <define name="ANDROID_SDK_DIR" value="/Users/xxxxxx/Library/Android/sdk" />
    <define name="NDK_VERSION" value="18.1.5063045" />
</project>
```

## HTML5目标
使用HTML5目标时，编译可使用：
When using HTML5 targets, the compilation can use:
```shell
haxelib run zyheaps build html5
```
当需要测试HTML5目标时：
When you need to test HTML5 goals:
```shell
haxelib run zyheaps test html5
```

## 安卓目标
编译安卓时，需要配置好对应的NDK版本号：
When compiling Android, you need to configure the corresponding NDK version number:
```xml
<!-- NDK目录 -->
<define name="NDK_DIR" value=""/>
<!-- Android SDK目录 -->
<define name="ANDROID_SDK_DIR" value=""/>
<!-- NDK版本 -->
<define name="NDK_VERSION" value=""/>
```
再通过以下命令进行快速编译：
Then quickly compile with the following commands:
```shell
haxelib run zyheaps build android
```

## 微信小游戏
它支持微信小游戏，编译时使用：
```shell
haxelib run zyheaps build wechat
```