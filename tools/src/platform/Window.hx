package platform;

import utils.AssetHelperExt;
import hxp.HXML;
import sys.FileSystem;

class Window extends BasePlatform {
	public var osPath:String = "";

	public function new() {
		super("window");
	}

	override function onCopyAssets() {
		osPath = project.app.path + "/" + platform;
		for (asset in project.assets) {
			AssetHelperExt.copyAsset(asset, project.app.path + "/" + platform + "/res/" + asset.targetPath);
		}
	}

	override function initHxml():HXML {
		super.initHxml();
		if (project.defines.exists("dx")) {
			hxml.lib("hldx");
		} else {
			hxml.lib("hlsdl");
		}
		hxml.hl = osPath + "/main.hl";
		return hxml;
	}

	override function onBuild() {
		super.onBuild();
		// 编译hl
		var hxml = initHxml();
		hxml.build();
	}
}
