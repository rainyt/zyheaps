package zygame.display.base;

import zygame.events.EventListener;
import zygame.events.EventTools;
import zygame.events.EventType;
import zygame.events.Event;
import zygame.layout.ILayout;
import h2d.RenderContext;
import h2d.Interactive;
import zygame.utils.SceneManager;
import h2d.Object;
import zygame.core.Start;
import h2d.Graphics;
import zygame.display.base.IDisplayObject;

/**
 * 基础的绘制类型
 */
class BaseGraphics extends Graphics implements IInteractiveObject implements IEventListener {
	public var dirt:Bool = false;

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

	public function get_stageWidth():Float {
		return Start.current.stageWidth;
	}

	override function addChildAt(s:Object, pos:Int) {
		// TODO 这里不能直接更新，否则ListView会引起循环dirt的错误
		// @:privateAccess SceneManager.setDirt();
		super.addChildAt(s, pos);
	}

	/**
	 * 获取舞台宽度
	 */
	public var stageWidth(get, never):Float;

	public function get_stageHeight():Float {
		return Start.current.stageHeight;
	}

	/**
	 * 获取舞台高度
	 */
	public var stageHeight(get, never):Float;

	public var layout:ILayout;

	/**
	 * 布局自身
	 */
	public function updateLayout():Void {
		layoutIDisplayObject(this);
	}

	public function onInit():Void {}

	/**
	 * 设置脏
	 */
	inline public function setDirty(d:Bool = true):Void {
		dirt = d;
	}

	/**
	 * 获取图形宽度
	 */
	public var width(default, set):Null<Float>;

	function set_width(width:Null<Float>):Null<Float> {
		this.width = width;
		this.setDirty();
		return width;
	}

	/**
	 * 获取图形高度
	 */
	public var height(default, set):Null<Float>;

	function set_height(height:Null<Float>):Null<Float> {
		this.height = height;
		this.setDirty();
		return height;
	}

	public var ids:Map<String, Object>;

	public function get<T:Object>(id:String, c:Class<T>):T {
		if (ids != null)
			return cast ids.get(id);
		return null;
	}

	public var enableInteractive(default, set):Bool;

	public function set_enableInteractive(value:Bool):Bool {
		this.enableInteractive = value;
		if (this.enableInteractive) {
			// 开启触摸
			if (interactive == null) {
				var interactive = new h2d.Interactive(0, 0);
				addChildAt(interactive, 0);
				this.interactive = interactive;
				interactive.cursor = Default;
				interactive.onPush = function(e) {
					this.onMousePush();
				}
				interactive.onRelease = function(e) {
					this.onMouseRelease();
				}
			}
		} else {
			// 关闭触摸
			if (interactive != null) {
				interactive.remove();
				interactive = null;
			}
		}
		setDirty();
		return this.enableInteractive;
	}

	public var interactive:Interactive;

	override function draw(ctx:RenderContext) {
		if (dirt) {
			if (interactive != null) {
				interactive.width = contentWidth;
				interactive.height = contentHeight;
			}
			dirt = false;
		}
		super.draw(ctx);
	}

	public var contentWidth(get, null):Float;

	public function get_contentWidth():Float {
		return getWidth(this);
	}

	public var contentHeight(get, null):Float;

	public function get_contentHeight():Float {
		return getHeight(this);
	}

	dynamic public function onMousePush():Void {
		this.dispatchEvent(new Event(Event.PUSH), true);
	}

	dynamic public function onMouseRelease():Void {
		this.dispatchEvent(new Event(Event.RELEASE), true);
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
}
