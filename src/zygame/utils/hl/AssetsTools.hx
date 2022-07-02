package zygame.utils.hl;

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

	/** 根据路径获取字符串 **/
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
		#else
		return null;
		#end
	}
}
