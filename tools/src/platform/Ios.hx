package platform;

import utils.FixHashLinkNative;
import utils.AssetHelperExt;
import lime.tools.ProjectHelper;
import hxp.HXML;
import haxe.Exception;
import hxp.Log;
import sys.io.File;
import haxe.zip.Reader;
import sys.FileSystem;

using StringTools;

class Ios extends BasePlatform {
	public function new() {
		super("ios");
	}

	override function onBuilded() {
		// IOS需要检测是否已经存在了App.xcodeproj，如果存在，则不会主动更新了，避免刷新
		var appxcodeproj = project.app.path + "/" + platform + "/App.xcodeproj";
		if (!FileSystem.exists(appxcodeproj)) {
			ProjectHelper.recursiveSmartCopyTemplate(project, "ios-project", project.app.path + "/" + platform, project.templateContext);
		}
		super.onBuilded();
	}

	override function onCopyAssets() {
		for (asset in project.assets) {
			AssetHelperExt.copyAsset(asset, project.app.path + "/" + platform + "/assets/" + asset.targetPath);
		}
		// 解压对应的cpp文件
		var cppDir = project.app.path + "/" + platform + "/deps/";
		var cpplibs = Sys.getCwd() + "tools/templates/ios-cpp-libs/";
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
	}

	override function initHxml():HXML {
		super.initHxml();
		hxml.lib("hlsdl");
		hxml.hl = project.app.path + "/" + platform + "/out/main.c";
		return hxml;
	}

	override function onBuild() {
		super.onBuild();
		// 开始编译cpp目标
		var hxml = initHxml();
		hxml.build();
		// Fix
		FixHashLinkNative.fix(project.app.path + "/" + platform + "/out/");
		// System.writeText(hxml, project.app.path + "/" + platform + "/app/src/main/build.hxml");
	}
}
