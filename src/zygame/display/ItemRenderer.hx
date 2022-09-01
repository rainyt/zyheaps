package zygame.display;

import zygame.display.base.IListView;
import h2d.RenderContext;
import zygame.events.Event;
import h2d.Object;
import zygame.display.base.IItemRenderer;

/**
 * 基础的ItemRenderer渲染器
 * ### 事件列表：
 * ```haxe
 * Event.CLICK（点击事件，通过该事件会返回到ListView中）
 * ```
 */
class ItemRenderer extends Box implements IItemRenderer {
	public var data(default, set):Dynamic;

	public function set_data(value:Dynamic):Dynamic {
		this.data = value;
		return value;
	}

	public var selected(default, set):Bool;

	public function set_selected(value:Bool):Bool {
		this.selected = value;
		return value;
	}

	public function new(?parent:Object) {
		super(parent);
		this.enableInteractive = true;
		this.interactive.propagateEvents = true;
		this.interactive.onClick = function(e) {
			this.dispatchEvent(new Event(Event.CLICK), true);
		}
	}

	override function draw(ctx:RenderContext) {
		if(dirt){
			this.updateLayout();
		}
		super.draw(ctx);
	}

	public var listView:IListView;
}
