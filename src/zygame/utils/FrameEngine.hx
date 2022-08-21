package zygame.utils;

import zygame.display.base.IRefresher;
import zygame.core.Start;

/**
 * 纯帧事件逻辑驱动工具：
 * FrameEngine.create(function(engine){
 *  //帧逻辑
 *  engine.stop(); //停止
 * })
 */
class FrameEngine implements IRefresher {
	/**
	 * 停止所有FrameEngine逻辑
	 */
	public static function stopAllFrameEngine():Void {
		var array = @:privateAccess Start.current._updates;
		var len = array.length;
		while (len >= 0) {
			len--;
			if (Std.isOfType(array[len], FrameEngine)) {
				array.remove(array[len]);
			}
		}
	}

	public var dt:Float = 0;

	public function new() {}

	public static function create(cb:FrameEngine->Void) {
		var engine:FrameEngine = new FrameEngine();
		engine.onFrameEvent = cb;
		engine.start();
		return engine;
	}

	/**
	 * 帧事件处理
	 * @param event 
	 */
	dynamic public function onFrameEvent(event:FrameEngine) {}

	/**
	 * 开始帧事件
	 */
	public function start():Void {
		Start.current.addToUpdate(this);
	}

	/**
	 * 停止帧事件
	 */
	public function stop():Void {
		Start.current.removeToUpdate(this);
	}

	public function update(dt:Float) {
		this.dt = dt;
		onFrameEvent(this);
	}
}
