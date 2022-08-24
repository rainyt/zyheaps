package zygame.events;

import zygame.display.base.IEventListener;
import h2d.Object;

class EventTools {
	public static function dispatchParentEvent(self:Object, event:Event, bubble:Bool):Void {
		if (bubble) {
			// 向上冒泡
			if (self.parent != null) {
				if (self.parent is IEventListener)
					cast(self.parent, IEventListener).dispatchEvent(event, bubble);
				else
					dispatchParentEvent(self.parent, event, bubble);
			}
		}
	}
}
