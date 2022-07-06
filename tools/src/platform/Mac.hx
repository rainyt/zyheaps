package platform;

import sys.io.File;
import lime.tools.IconHelper;
import lime.tools.Icon;
import hxp.System;
import sys.FileSystem;
import lime.tools.AssetHelper;

/**
 * Mac Os目标
 */
class Mac extends BasePlatform {
	private var macOsPath:String;

	public function new() {
		super("mac");
		if (System.hostPlatform != MAC) {
			throw "This targt support mac system.";
		}
	}

	override function onCopyAssets() {
		for (asset in project.assets) {
			AssetHelper.copyAsset(asset, project.app.path + "/" + platform + "/App.app/Contents/Resources/" + asset.targetPath);
		}
		// 权限处理
		macOsPath = project.app.path + "/" + platform + "/App.app/Contents/MacOS";
		var files = FileSystem.readDirectory(macOsPath);
		for (file in files) {
			Sys.command("chmod", ["+x", macOsPath + "/" + file]);
		}
	}

	override function onBuild() {
		super.onBuild();
		// 编译hl
		var hxml = initHxml();
		hxml.lib("hlsdl");
		hxml.hl = macOsPath + "/main.hl";
		hxml.build();
		// 改名
		FileSystem.deleteFile(macOsPath + "/hlboot.dat");
		FileSystem.rename(macOsPath + "/main.hl", macOsPath + "/hlboot.dat");
	}
}
