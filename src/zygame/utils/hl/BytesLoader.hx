package zygame.utils.hl;

import haxe.io.Bytes;
import sys.thread.Thread;

/**
 * 异步加载器
 */
class BytesLoader implements ILoader {
	/**
	 * 线程管理
	 */
	private static var threads:Map<Int, BytesLoader> = [];

	/**
	 * 异步线程数量
	 */
	private static var count:Int = 0;

	public static function loop():Void {
		if (count == 0) {
			return;
		}
		var data = Thread.readMessage(true);
		if (data != null) {
			var l = threads.get(data.uid);
			l.onSuccess(data.bytes);
			threads.remove(data.uid);
			count--;
		}
	}

	/**
	 * 线程唯一UID
	 */
	private static var uid:Int = 0;

	private var _t:Thread;

	public function new(path:String) {
		count++;
		threads.set(++uid, this);
		var mainThread = Thread.current();
		// 创建一个线程
		_t = Thread.create(function() {
			var bytes = AssetsTools.getBytes(path);
			// 载入完毕后，直接返回
			mainThread.sendMessage({
				uid: uid,
				bytes: bytes
			});
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
