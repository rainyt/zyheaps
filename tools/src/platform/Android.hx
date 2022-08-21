package platform;

import utils.AssetHelperExt;
import hxp.HXML;
import haxe.Json;
import hxp.Haxelib;
import hxp.Log;
import haxe.Exception;
import haxe.io.Input;
import haxe.zip.Reader;
import haxe.zip.Tools;
import hxp.System;
import sys.io.File;
import sys.FileSystem;
import lime.tools.AssetHelper;

using StringTools;

/** 安卓目标 **/
class Android extends BasePlatform {
	public function new() {
		super("android");
	}

	override function onCopyAssets() {
		for (asset in project.assets) {
			AssetHelperExt.copyAsset(asset, project.app.path + "/" + platform + "/app/src/main/assets/" + asset.targetPath);
		}
		// 解压对应的cpp文件
		var cppDir = project.app.path + "/" + platform + "/app/src/main/cpp/";
		var cpplibs = Sys.getCwd() + "tools/templates/android-cpp-libs/";
		var cpps = FileSystem.readDirectory(cpplibs);
		for (file in cpps) {
			if (file.charAt(0) != "." && file.endsWith("zip")) {
				var dirname = file.substr(0, file.lastIndexOf("."));
				if (!FileSystem.exists(cppDir + dirname)) {
					Log.info("add_library " + dirname);
					// 开始解压
					var zip = new Reader(File.read(cpplibs + file));
					var list = zip.read();
					for (item in list.iterator()) {
						if (item.fileName.indexOf("/") != -1) {
							var dir = cppDir + item.fileName.substr(0, item.fileName.lastIndexOf("/"));
							if (!FileSystem.exists(dir))
								FileSystem.createDirectory(dir);
						}
						try {
							if (item.compressed) {
								var newBytes = Reader.unzip(item);
								File.saveBytes(cppDir + item.fileName, newBytes);
							} else
								File.saveBytes(cppDir + item.fileName, item.data);
						} catch (e:Exception) {
							// trace("Error:", cppDir + item.fileName, item.dataSize);
						}
					}
				}
			}
		}
		// 需要对openal-nativetools的bin2h/bsincgen提供权限
		if (Sys.systemName() != "Windows") {
			System.runCommand("", "chmod", ["755", cppDir + "openal-nativetools/bin2h"]);
			System.runCommand("", "chmod", ["755", cppDir + "openal-nativetools/bsincgen"]);
		}
	}

	override function initHxml():HXML {
		super.initHxml();
		hxml.lib("hlsdl");
		hxml.hl = project.app.path + "/" + platform + "/app/src/main/cpp/out/main.c";
		return hxml;
	}

	override function onBuild() {
		super.onBuild();
		// 开始编译cpp目标
		var hxml = initHxml();
		hxml.build();
		System.writeText(hxml, project.app.path + "/" + platform + "/app/src/main/build.hxml");
		// 从android studio编译
		Sys.setCwd(project.app.path + "/" + platform);
		var cmd = project.app.path + "/" + platform + "/gradlew";
		if (Sys.systemName() != "Windows") {
			System.runCommand("", "chmod", ["755", cmd]);
		}
		// gradlew assembleDebug assembleRelease
		if (Sys.args().indexOf("-final") != -1) {
			Sys.command(cmd + " assembleRelease");
		} else
			Sys.command(cmd + " assembleDebug");
	}
}
