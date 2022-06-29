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
		Log.info("Welcome to zyheaps");
		var args = Sys.args();
		projectDirPath = args[args.length - 1];
		buildPlatform = args[1];
		Log.info('working ${projectDirPath}');
		switch (args[0]) {
			case "build", "test":
				Log.info("build platform " + buildPlatform);
				var c = "platform." + buildPlatform.charAt(0).toUpperCase() + buildPlatform.substr(1).toLowerCase();
				var tc = Type.resolveClass(c);
				if (tc != null) {
					var base:BasePlatform = Type.createInstance(tc, []);
					base.onBuild();
					base.onBuilded();
					if(args[0] == "test"){
						base.onTest();
					}
				} else {
					Log.error('Target ${buildPlatform} is unavailable.');
				}
			default:
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
