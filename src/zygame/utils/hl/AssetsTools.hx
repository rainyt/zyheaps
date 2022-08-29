package zygame.utils.hl;

import sys.FileSystem;
import haxe.Exception;
import sys.thread.Thread;
import sys.io.File;
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
		return File.getBytes("assets/" + path);
		#elseif mac
		var loadpath = path;
		if (loadpath.indexOf("/") != 0) {
			var root = Sys.programPath();
			root = root.substr(0, root.lastIndexOf("/"));
			loadpath = root + "/../Resources/" + loadpath;
		}
		try {
			var data = File.getContent(loadpath);
			var bytes = File.getBytes(loadpath);
			return bytes;
		} catch (e:Exception) {
			trace(e.message);
			return null;
		}
		#elseif window
		var loadpath = path;
		if (loadpath.indexOf("/") != 0 && loadpath.indexOf(":/") == -1) {
			var root = Sys.programPath();
			root = root.substr(0, root.lastIndexOf("\\")) + "/res/" + path;
			loadpath = root;
		}
		try {
			return File.getBytes(loadpath);
		} catch (e:Dynamic) {
			return null;
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
