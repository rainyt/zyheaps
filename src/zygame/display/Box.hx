package zygame.display;

import zygame.utils.SceneManager;
import h2d.Object;
import h2d.RenderContext;
import h2d.Interactive;
import zygame.core.Start;
import zygame.display.base.IDisplayObject;

/**
 * 基础容器
 */
class Box extends h2d.Object implements IDisplayObject {
	public var dirt:Bool = false;

	public var enableInteractive(get, set):Bool;

	private var _enableInteractive:Bool;

	public function new(?parent:Object) {
		super(parent);
		this.onInit();
	}

	public function onInit():Void {}

	function get_enableInteractive():Bool {
		return _enableInteractive;
	}

	override function addChildAt(s:Object, pos:Int) {
		@:privateAccess SceneManager.setDirt();
		super.addChildAt(s, pos);
	}

	function set_enableInteractive(enableInteractive:Bool):Bool {
		_enableInteractive = enableInteractive;
		if (_enableInteractive) {
			// 开启触摸
			if (interactive == null) {
				var interactive = new h2d.Interactive(0, 0);
				addChildAt(interactive, 0);
				this.interactive = interactive;
				interactive.cursor = Default;
			}
		} else {
			// 关闭触摸
			if (interactive != null) {
				interactive.remove();
				interactive = null;
			}
		}
		return _enableInteractive;
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
				interactive.width = this.width == null ? 1 : this.width;
				interactive.height = this.height == null ? 1 : this.height;
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

	/**
	 * 布局自身
	 */
	public function layout():Void {
		layoutIDisplayObject(this);
	}
}
