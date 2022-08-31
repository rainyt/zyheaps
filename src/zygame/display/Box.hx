package zygame.display;

import zygame.events.EventTools;
import zygame.events.Event;
import zygame.events.EventType;
import zygame.events.EventListener;
import zygame.display.base.IEventListener;
import zygame.layout.ILayout;
import zygame.display.base.IInteractiveObject;
import h2d.Object;
import h2d.RenderContext;
import h2d.Interactive;
import zygame.core.Start;
import zygame.display.base.IDisplayObject;

/**
 * 基础容器
 */
class Box extends h2d.Object implements IInteractiveObject implements IEventListener {
	public var dirt:Bool = false;

	public var enableInteractive(default, set):Bool;

	public function new(?parent:Object) {
		super(parent);
		this.onInit();
	}

	public function onInit():Void {}

	override function addChildAt(s:Object, pos:Int) {
		super.addChildAt(s, pos);
	}

	function set_enableInteractive(enableInteractive:Bool):Bool {
		this.enableInteractive = enableInteractive;
		if (this.enableInteractive) {
			// 开启触摸
			if (interactive == null) {
				var interactive = new h2d.Interactive(0, 0);
				super.addChildAt(interactive, numChildren);
				this.interactive = interactive;
				interactive.cursor = Default;
				// interactive.backgroundColor = 0x33ff0000;
			}
		} else {
			// 关闭触摸
			if (interactive != null) {
				interactive.remove();
				interactive = null;
			}
		}
		dirt = true;
		return this.enableInteractive;
	}

	/**
	 * 交互器
	 */
	public var interactive:Interactive;

	public function get_stageWidth():Float {
		return Start.current.stageWidth;
	}

	public var stageWidth(get, never):Float;

	public function get_stageHeight():Float {
		return Start.current.stageHeight;
	}

	public var stageHeight(get, never):Float;

	public var width(default, set):Null<Float>;

	function set_width(width:Null<Float>):Null<Float> {
		this.width = width;
		dirt = true;
		return width;
	}

	public var height(default, set):Null<Float>;

	function set_height(height:Null<Float>):Null<Float> {
		this.height = height;
		dirt = true;
		return height;
	}

	override function draw(ctx:RenderContext) {
		if (dirt) {
			if (interactive != null) {
				interactive.width = this.contentWidth;
				interactive.height = this.contentHeight;
			}
			dirt = false;
		}
		super.draw(ctx);
	}

	/**
	 * 距离左边
	 */
	public var left:Null<Float>;

	/**
	 * 距离右边
	 */
	public var right:Null<Float>;

	/**
	 * 距离顶部
	 */
	public var top:Null<Float>;

	/**
	 * 距离底部
	 */
	public var bottom:Null<Float>;

	/**
	 * 居中X
	 */
	public var centerX:Null<Float>;

	/**
	 * 居中Y
	 */
	public var centerY:Null<Float>;

	public var layout:ILayout;

	/**
	 * 布局自身
	 */
	public function updateLayout():Void {
		layoutIDisplayObject(this);
	}

	public var ids:Map<String, Object>;

	public function get<T:Object>(id:String, c:Class<T>):T {
		if (ids != null)
			return cast ids.get(id);
		return null;
	}

	public var contentWidth(get, null):Float;

	public function get_contentWidth():Float {
		return getWidth(this);
	}

	public var contentHeight(get, null):Float;

	public function get_contentHeight():Float {
		return getHeight(this);
	}

	private var __events:EventListener = new EventListener();

	public function addEventListener<T>(type:EventType<T>, listener:T->Void) {
		__events.addEventListener(type, listener);
	}

	public function removeEventListener<T>(type:EventType<T>, listener:T->Void) {
		__events.removeEventListener(type, listener);
	}

	public function hasEventListener<T>(type:EventType<T>):Bool {
		return __events.hasEventListener(type);
	}

	public function dispatchEvent(event:Event, bubble:Bool = false):Void {
		if (!mouseChildren || @:privateAccess event.__target == null)
			@:privateAccess event.__target = this;
		this.__events.dispatchEvent(event, bubble);
		EventTools.dispatchParentEvent(this, event, bubble);
	}

	public var mouseChildren:Bool = true;

	public var percentageWidth(default, set):Null<Float>;

	public function set_percentageWidth(value:Null<Float>):Null<Float> {
		this.percentageWidth = value;
		return value;
	}

	public var percentageHeight(default, set):Null<Float>;

	public function set_percentageHeight(value:Null<Float>):Null<Float> {
		this.percentageHeight = value;
		return value;
	}
}
