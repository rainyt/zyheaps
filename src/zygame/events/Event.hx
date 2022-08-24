package zygame.events;

class Event {
	/**
	 * CLICK事件
	 */
	public static inline var CLICK:EventType<Event> = "click";

	/**
	 * 数据更改事件
	 */
	public static inline var CHANGE:EventType<Event> = "change";

	public var type:String;

	/**
	 * 触发事件的目标
	 */
	public var target(get, null):Any;

	private var __target:Any;

	private function get_target():Any {
		return __target;
	}

	public function new(type:String) {
		this.type = type;
	}
}
