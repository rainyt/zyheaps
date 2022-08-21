package utils;

import haxe.crypto.Md5;
import haxe.Json;
import sys.io.File;
import hxd.fs.Convert.ConvertFBX2HMD;
import sys.FileSystem;
import lime.tools.AssetHelper;
import lime.tools.Asset;

class AssetHelperExt {
	public static var hmdcache:Dynamic;

	public static function copyAsset(asset:Asset, destination:String, context:Dynamic = null) {
		AssetHelper.copyAsset(asset, destination, context);
		// 需要遍历该目标目录下的所有3d资产，将FBX转换为HMD
		convertFBX2HMD(asset.sourcePath, destination);
	}

	public static function convertFBX2HMD(sourcePath:String, filepath:String):Void {
		if (StringTools.endsWith(filepath.toLowerCase(), ".fbx")) {
			var cacheFile = filepath.substr(0, filepath.lastIndexOf("/") + 1) + "hmdcache.json";
			if (hmdcache == null) {
				if (FileSystem.exists(cacheFile))
					hmdcache = Json.parse(File.getContent(cacheFile))
				else {
					hmdcache = {};
				}
			}
			var stat = FileSystem.stat(sourcePath);
			var time = stat.mtime.getTime();
			var cacheid = filepath;
			var lasttime = Reflect.getProperty(hmdcache, cacheid);
			if (lasttime == time) {
				trace("[Cached]FBX2HDM:", StringTools.replace(filepath.toLowerCase(), ".fbx", ".hmd"));
				FileSystem.deleteFile(filepath);
				return;
			}
			Reflect.setProperty(hmdcache, cacheid, time);
			// 转换为HMD
			var c = new ConvertFBX2HMD();
			c.originalFilename = filepath.substr(filepath.lastIndexOf("/") + 1);
			c.srcPath = filepath;
			c.srcBytes = File.getBytes(filepath);
			c.dstPath = StringTools.replace(filepath.toLowerCase(), ".fbx", ".hmd");
			c.convert();
			File.saveContent(cacheFile, Json.stringify(hmdcache));
			FileSystem.deleteFile(filepath);
			trace("FBX2HDM:", c.dstPath);
		}
	}
}
