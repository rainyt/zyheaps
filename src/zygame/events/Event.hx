package zygame.events;

class Event {
	/**
	 * CLICK事件
	 */
	public static inline var CLICK:EventType<Event> = "click";

	public var type:String;

	public function new(type:String) {
		this.type = type;
	}
}
