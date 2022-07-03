import sys.FileSystem;
import lime.tools.AssetHelper;
import hxp.System;
import platform.BasePlatform;
import platform.AllPlatform;
import hxp.Log;
import hxp.PlatformTools;

/**
 * zyhepas的构造工具
**/
class Tools {
	/**
	 * 项目目录
	 */
	public static var projectDirPath:String;

	/** 编译平台 **/
	public static var buildPlatform:String;

	static function main() {
		var args = Sys.args();
		projectDirPath = args[args.length - 1];
		buildPlatform = args[1];
		switch (args[0]) {
			case "hxml":
				var c = "platform." + buildPlatform.charAt(0).toUpperCase() + buildPlatform.substr(1).toLowerCase();
				var tc = Type.resolveClass(c);
				if (tc != null) {
					var base:BasePlatform = Type.createInstance(tc, []);
					base.initHxml();
					var content:String = base.hxml;
					content = StringTools.replace(content, projectDirPath, "");
					var dir = projectDirPath + "Export/.hxml/";
					if (!FileSystem.exists(dir))
						FileSystem.createDirectory(dir);
					System.writeText(content, dir + "target.hxml");
					Log.info(content);
				}
			case "build", "test":
				Log.info("build platform " + buildPlatform);
				var c = "platform." + buildPlatform.charAt(0).toUpperCase() + buildPlatform.substr(1).toLowerCase();
				var tc = Type.resolveClass(c);
				if (tc != null) {
					var base:BasePlatform = Type.createInstance(tc, []);
					base.onBuild();
					base.onBuilded();
					if (args[0] == "test") {
						base.onTest();
					}
				} else {
					Log.error('Target ${buildPlatform} is unavailable.');
				}
			default:
				Log.info("Welcome to zyheaps");
				Log.info('working ${projectDirPath}');
				Log.info("Use:");
				Log.info("haxelib run zyhepas build ${platform}");
				Log.info("haxelib run zyhepas test ${platform}");
				Log.info("platform optional:");
				for (c in AllPlatform.platforms) {
					var n = Type.getClassName(c);
					n = n.substr(n.indexOf(".") + 1);
					n = n.toLowerCase();
					Log.info(n);
				}
		}
	}
}
