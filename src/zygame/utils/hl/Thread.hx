package zygame.utils.hl;

/**
 * 线程管理器，如果使用zyheaps，请使用zyheas的`zygame.utils.hl.Thread`线程功能，避免线程溢出发生错误。
 */
class Thread {
	/**
	 * 线程列表
	 */
	private static var _threads:Map<Int, Thread> = [];

	private static var _uid:Int = 0;

	private static var _counts = 0;

	public static function create(cb:Void->Void, message:ThreadMessage->Void):Thread {
		return new Thread(cb, message);
	}

	public static function current():sys.thread.Thread {
		return sys.thread.Thread.current();
	}

	public static function loop():Void {
		if (_counts == 0) {
			return;
		}
		var data:ThreadMessage = sys.thread.Thread.readMessage(true);
		if (data != null) {
			switch (data.code) {
				case 200:
					_threads.remove(data.uid);
					_counts--;
				default:
					_threads.get(data.uid).onMessage(data);
			}
		}
	}

	private var _t:sys.thread.Thread;

	public var uid:Int = -1;

	dynamic public function onMessage(message:ThreadMessage):Void {}

	public function new(cb:Void->Void, message:Dynamic->Void) {
		uid = ++_uid;
		_counts++;
		_threads.set(uid, this);
		onMessage = message;
		var mainThread = Thread.current();
		_t = sys.thread.Thread.create(function() {
			cb();
			// 这里触发删除线程
			mainThread.sendMessage({
				uid: uid,
				data: null,
				code: 200
			});
		});
	}
}

typedef ThreadMessage = {
	uid:Int,
	data:Dynamic,
	code:Int
}
