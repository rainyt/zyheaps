package platform;

import sys.FileSystem;
import lime.tools.AssetHelper;

class Window extends BasePlatform {
	public var osPath:String = "";

	public function new() {
		super("window");
	}

	override function onCopyAssets() {
		osPath = project.app.path + "/" + platform;
		for (asset in project.assets) {
			AssetHelper.copyAsset(asset, project.app.path + "/" + platform + "/res/" + asset.targetPath);
		}
	}

	override function onBuild() {
		super.onBuild();
		// 编译hl
		var hxml = initHxml();
		if (project.defines.exists("dx")) {
			hxml.lib("hldx");
		} else {
			hxml.lib("hlsdl");
		}
		hxml.hl = osPath + "/main.hl";
		hxml.build();
	}
}
