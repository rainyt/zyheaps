package zygame.utils;

import zygame.core.Start;

/**
 * 时间运行环境
 */
class TimeRuntime {
	public function new() {}

	/**
	 * 当游戏恢复时调用
	 */
	private var _resumecall:Map<Int, Call> = new Map<Int, Call>();

	private var _timecall:Map<Int, Call> = new Map<Int, Call>();

	/**
	 * 渲染事件引用数
	 */
	public var renderCounts = 0;

	private var _rendercall:Map<Int, Call> = new Map<Int, Call>();

	private var _interval:Map<Int, Call> = new Map<Int, Call>();

	private var _arraycall:Array<Call> = [];

	private var _id:Int = 0;

	/**
	 * 每帧发生处理，由Start执行
	 */
	public function onFrame():Void {
		var keys:Iterator<Int> = _timecall.keys();
		while (keys.hasNext()) {
			var id:Int = keys.next();
			var call:Call = _timecall.get(id);
			_arraycall.push(call);
		}
		_arraycall.sort((a, b) -> a.id < b.id ? -1 : 1);
		for (call in _arraycall) {
			if (call != null && call.call())
				_timecall.remove(call.id);
		}
		_arraycall.splice(0, _arraycall.length);
		var intervals:Iterator<Call> = _interval.iterator();
		while (intervals.hasNext()) {
			var call:Call = intervals.next();
			call.call(true);
		}
		// 使用onRender处理
		// onResume();
	}

	/**
	 * 当活动恢复时触发
	 */
	public function onResume():Void {
		var keys:Iterator<Int> = _resumecall.keys();
		while (keys.hasNext()) {
			var id:Int = keys.next();
			var call:Call = _resumecall.get(id);
			if (call != null && call.call())
				_resumecall.remove(id);
		}
	}

	public function hasRenderEvent():Bool {
		return renderCounts > 0;
	}

	/**
	 * 当活动渲染时
	 */
	public function onRender():Void {
		// this.onResume();
		var keys:Iterator<Int> = _rendercall.keys();
		while (keys.hasNext()) {
			var id:Int = keys.next();
			var call:Call = _rendercall.get(id);
			if (call != null && call.call()) {
				_rendercall.remove(id);
				renderCounts--;
			}
		}
	}

	/**
	 * 下一帧调用
	 * @param closure
	 * @param delay
	 * @param args
	 * @return Int
	 */
	public function nextFrameCall(closure:Dynamic, args:Array<Dynamic> = null):Int {
		return setTimeout(closure, 0, args);
	}

	/**
	 * 处理了自动释放处理
	 * @param closure
	 * @param delay
	 * @param args
	 * @return Int
	 */
	public function setTimeout(closure:Dynamic, delay:Int, args:Array<Dynamic> = null):Int {
		_id++;
		if (delay <= 0)
			delay = 1;
		_timecall.set(_id, new Call(_id, delay, closure, args));
		return _id;
	}

	/**
	 * 清理计时器
	 * @param id
	 */
	public function clearTimeout(id:Int):Void {
		_timecall.remove(id);
	}

	/**
	 * 设置循环事件
	 * @param closure
	 * @param delay
	 * @param args
	 * @return Int
	 */
	public function setInterval(closure:Dynamic, delay:Int = 0, args:Array<Dynamic> = null):Int {
		_id++;
		if (delay <= 0)
			delay = 1;
		_interval.set(_id, new Call(_id, delay, closure, args));
		return _id;
	}

	/**
	 * 重置计时器，重新计算
	 * @param id
	 */
	public function resetInterval(id:Int):Void {
		if (_interval.exists(id))
			_interval.get(id).reset();
	}

	/**
	 * 清理计时器
	 * @param id
	 */
	public function clearInterval(id:Int):Void {
		_interval.remove(id);
	}

	/**
	 * 清空所有计时器
	 */
	public function clear():Void {
		_interval = new Map();
		_timecall = new Map();
		_resumecall = new Map();
	}

	/**
	 * 当活动恢复时，进行调用
	 * @param closure
	 * @param args
	 * @param delay
	 * @return Int
	 */
	public function resumeCall(closure:Dynamic, args:Array<Dynamic> = null):Int {
		_id++;
		_resumecall.set(_id, new Call(_id, 0, closure, args));
		return _id;
	}

	/**
	 * 当游戏正确渲染时进行调用
	 * @param closure
	 * @param args
	 * @return Int
	 */
	public function renderCall(closure:Dynamic, args:Array<Dynamic> = null):Int {
		// 当活动是处于活动的情况下，则直接走setTimeout
		_id++;
		_rendercall.set(_id, new Call(_id, 0, closure, args));
		renderCounts++;
		return _id;
	}
}

class Call {
	private var closure:Dynamic;

	private var args:Array<Dynamic>;

	private var frame:Int = 0;

	private var maxframe:Int = 0;

	public var id:Int = 0;

	#if zygameui13
	private var _dt:Float = 0;
	#end

	/**
	 *
	 * @param time 毫秒
	 * @param closure 回调
	 * @param args
	 */
	public function new(id:Int, time:Int, closure:Dynamic, args:Array<Dynamic>) {
		this.id = id;
		frame = Std.int(time / 1000 * 60);
		maxframe = frame;
		this.closure = closure;
		this.args = args;
	}

	/**
	 * 尝试呼叫方法
	 * @return Bool
	 */
	public function call(isInterval:Bool = false):Bool {
		#if zygameui13
		_dt += Start.current.frameDt;
		var add_frame = Std.int(_dt / Start.FRAME_DT_STEP);
		if (add_frame < 0) {
			_dt = 0;
			add_frame = 0;
		} else {
			_dt -= add_frame * Start.FRAME_DT_STEP;
			frame -= add_frame;
		}
		#else
		frame--;
		#end
		if (frame <= 0) {
			Reflect.callMethod(closure, closure, args == null ? [] : args);
			if (!isInterval)
				stop();
			else
				reset();
			return true;
		}
		return false;
	}

	/**
	 * 停止计时回调，isInterval=true时方法无效
	 */
	public function stop():Void {
		closure = null;
		args = null;
	}

	/**
	 * 重置为原始值
	 */
	public function reset():Void {
		frame = maxframe;
	}
}
