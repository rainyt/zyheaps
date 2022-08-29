package zygame.utils;

import haxe.io.Bytes;
#if !hl
import hxd.net.BinaryLoader;
#else
import zygame.utils.hl.BytesLoader;
#end

/**
 * 资源工具
 */
class AssetsUtils {
	/**
	 * 载入二进制数据，兼容hashlink，html5
	 * @param path 载入路径
	 * @param success 载入完成事件
	 * @param fail 载入失败事件
	 */
	public static function loadBytes(path:String, success:Bytes->Void, fail:String->Void):Void {
		#if hl
		#if sync_load_bytes
		// 同步接口
		trace("sync_load_bytes=", path);
		var data = zygame.utils.hl.AssetsTools.getBytes(path);
		trace("sync_load_bytes2=", data);
		if (data != null) {
			success(data);
		} else {
			fail("load fail:" + path);
		}
		#else
		// 异步接口
		var loader = new BytesLoader(path);
		loader.onSuccess = success;
		loader.onError = fail;
		#end
		#else
		var loader = new BinaryLoader(path);
		loader.onProgress = function(a, b) {}
		loader.onLoaded = function(data) {
			success(data);
		};
		loader.onError = function(err) {
			fail("load fail:" + path);
		}
		loader.load();
		#end
	}
}
