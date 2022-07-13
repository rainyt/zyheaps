package zygame.display;

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

	function get_enableInteractive():Bool {
		return _enableInteractive;
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

	public var width(get, set):Float;

	private var _width:Null<Float>;

	function get_width():Float {
		if (_width == null)
			return getSize().width;
		return _width;
	}

	function set_width(width:Float):Float {
		_width = width;
		dirt = true;
		return _width;
	}

	public var height(get, set):Float;

	private var _height:Null<Float>;

	function get_height():Float {
		if (_height == null)
			return getSize().height;
		return _height;
	}

	function set_height(height:Float):Float {
		_height = height;
		dirt = true;
		return _height;
	}

	override function draw(ctx:RenderContext) {
		if (dirt) {
			interactive.width = this.width;
			interactive.height = this.height;
			dirt = false;
		}
		super.draw(ctx);
	}
}
