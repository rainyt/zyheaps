package zygame.utils.hl;

import zygame.utils.hl.Thread.ThreadMessage;
import haxe.io.Bytes;

/**
 * 异步加载器
 */
class BytesLoader implements ILoader {
	/**
	 * 线程唯一UID
	 */
	private static var uid:Int = 0;

	private var _t:Thread;

	public function new(path:String) {
		// 使用线程时，要保留一个主线程进行获取
		var mainThread = Thread.current();
		// 创建一个线程
		_t = Thread.create(function() {
			var bytes = AssetsTools.getBytes(path);
			// 载入完毕后，直接返回
			var data:ThreadMessage = {
				uid: _t.uid,
				data: bytes,
				code: 0
			};
			mainThread.sendMessage(data);
		}, function(data) {
			if (data.data == null)
				onError("load fail");
			else
				onSuccess(data.data);
		});
	}

	/**
	 * 载入完成后
	 * @param bytes 
	 */
	dynamic public function onSuccess(bytes:Bytes):Void {}

	/**
	 * 载入失败
	 * @param msg 
	 */
	dynamic public function onError(msg:String):Void {}
}
