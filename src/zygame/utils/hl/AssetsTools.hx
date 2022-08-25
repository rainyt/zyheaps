package zygame.utils.hl;

import sys.thread.Thread;
import hxd.File;
import haxe.io.Bytes;

/**
	Hashlink的资源工具
**/
class AssetsTools {
	#if android
	@:hlNative("Java_org_haxe_HashLinkActivity")
	private static function getAssetBytes(path:String):hl.Bytes {
		return null;
	}

	@:hlNative("Java_org_haxe_HashLinkActivity")
	private static function tmpSize():Int {
		return 0;
	}
	#end

	/**
	 * 通过路径获取二进制数据
	 * @param path 
	 * @return Bytes
	 */
	static public function getBytes(path:String):Bytes {
		#if android
		var bytes = getAssetBytes(path);
		if (bytes == null)
			return null;
		var tmpSize = tmpSize();
		return bytes.toBytes(tmpSize);
		#elseif ios
		trace("ios load file:", path);
		return File.getBytes("assets/" + path);
		#elseif mac
		var loadpath = path;
		if (loadpath.indexOf("/") != 0) {
			var root = Sys.programPath();
			root = root.substr(0, root.lastIndexOf("/"));
			loadpath = root + "/../Resources/" + loadpath;
		}
		try {
			return File.getBytes(loadpath);
		} catch (e:Dynamic) {
			throw("load fail:" + loadpath);
		}
		#elseif window
		var loadpath = path;
		if (loadpath.indexOf("/") != 0) {
			var root = Sys.programPath();
			root = root.substr(0, root.lastIndexOf("\\")) + "/res/" + path;
			loadpath = root;
		}
		try {
			return File.getBytes(root);
		} catch (e:Dynamic) {
			throw("load fail:" + root);
		}
		#elseif hl
		return File.getBytes(path);
		#else
		return null;
		#end
	}

	public static function loadBytes(path:String):ILoader {
		return new BytesLoader(path);
	}
}
