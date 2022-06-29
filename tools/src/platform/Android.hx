package platform;

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
			AssetHelper.copyAsset(asset, project.app.path + "/app/src/main/assets/" + platform + "/" + asset.targetPath);
		}
		// 解压对应的cpp文件
		var cppDir = project.app.path + "/app/src/cpp/";
		var cpps = FileSystem.readDirectory(cppDir);
		for (file in cpps) {
			if (file.charAt(0) != "." && file.endsWith("zip")) {
				var dirname = file.substr(0, file.lastIndexOf("."));
				if (!FileSystem.exists(cppDir + dirname)) {
                    // 开始解压
                }
			}
            else {
                
            }
		}
	}
}
