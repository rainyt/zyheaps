package zygame.events;

import zygame.display.base.IEventListener;

/**
 * 事件侦听器
 */
class EventListener implements IEventListener {
	/**
	 * 侦听器列表
	 */
	private var __listener:Map<String, Array<Dynamic->Void>> = [];

	public function new() {}

	/**
	 * 侦听事件
	 * @param type 
	 */
	public function addEventListener<T>(type:EventType<T>, listener:T->Void) {
		if (!hasEventListener(type)) {
			__listener.set(type, []);
		}
		__listener.get(type).push(listener);
	}

	/**
	 * 删除事件
	 * @param type 
	 */
	public function removeEventListener<T>(type:EventType<T>, listener:T->Void) {
		if (hasEventListener(type)) {
			__listener.get(type).remove(listener);
		}
	}

	/**
	 * 是否存在事件
	 * @param type 
	 */
	public function hasEventListener<T>(type:EventType<T>):Bool {
		if (__listener.exists(type)) {
			return true;
		}
		return false;
	}

	/**
	 * 回调事件
	 * @param type 
	 */
	public function dispatchEvent(event:Event, bubble:Bool = false):Void {
		if (hasEventListener(event.type)) {
			for (e in __listener.get(event.type)) {
				e(event);
			}
		}
	}
}
