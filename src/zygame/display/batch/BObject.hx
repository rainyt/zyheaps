package zygame.display.batch;

import zygame.display.base.IDisplayObject;
import zygame.layout.ILayout;
import h2d.col.Bounds;
import h2d.Interactive;
import h2d.col.Matrix;
import h2d.SpriteBatch.BasicElement;
import zygame.core.Start;
import zygame.display.base.IBatchDisplayObject;

/**
 * 批处理基础类
 */
class BObject implements IBatchDisplayObject {
	private var __transform:Matrix = new Matrix();

	/**
	 * 是否使用父节点的尺寸，如ScrollView通常自身会有一个`Box`，布局尺寸应该按`ScrollView`获取。
	 */
	public var useLayoutParent:IDisplayObject;

	private var __worldTransform:Matrix = new Matrix();

	public var numChildren(get, null):Int;

	private function get_numChildren():Int {
		return children.length;
	}

	public function getChildAt(index:Int):BObject {
		return children[index];
	}

	private function __update():Void {
		__transform.identity();
		__transform.rotate(this.rotation * Math.PI / 180);
		__transform.scale(this.scaleX, this.scaleY);
		__transform.translate(this.x, this.y);
		__worldTransform.identity();
		if (this.parent == null) {
			__worldTransform.multiply(__transform, __worldTransform);
		} else {
			__worldTransform.multiply(__transform, @:privateAccess parent.__worldTransform);
		}
	}

	public var children:Array<BObject> = [];

	public function addChild(child:BObject):Void {
		this.addChildAt(child, children.length);
	}

	public function addChildAt(child:BObject, pos:Int):Void {
		if (child.parent != null) {
			removeChild(child);
		}
		child.parent = this;
		children[pos] = child;
	}

	public function removeChild(child:BObject):Void {
		if (child.parent == this) {
			children.remove(child);
			child.parent = null;
		}
	}

	public function new(?parent:BObject) {
		this.x = 0;
		this.y = 0;
		this.scaleX = 1;
		this.scaleY = 1;
		this.rotation = 0;
		if (parent != null)
			parent.addChild(this);
		onInit();
	}

	public var dirt:Bool;

	public function get_stageWidth():Float {
		return Start.current.stageWidth;
	}

	public var stageWidth(get, never):Float;

	public function get_stageHeight():Float {
		return Start.current.stageHeight;
	}

	public var stageHeight(get, never):Float;

	public var parent(default, null):BObject;

	public function set_x(value:Float):Float {
		this.x = value;
		return value;
	}

	public var x(default, set):Float;

	public function set_y(value:Float):Float {
		this.y = value;
		return value;
	}

	public var y(default, set):Float;

	public function set_width(value:Null<Float>):Null<Float> {
		this.width = value;
		return value;
	}

	public var width(default, set):Null<Float>;

	public var height(default, set):Null<Float>;

	public function set_height(value:Null<Float>):Null<Float> {
		this.height = value;
		return value;
	}

	public var scaleX(default, set):Float;

	public function set_scaleX(value:Float):Float {
		this.scaleX = value;
		return value;
	}

	public var scaleY(default, set):Float;

	public function set_scaleY(value:Float):Float {
		this.scaleY = value;
		return value;
	}

	public var left:Null<Float>;

	public var right:Null<Float>;

	public var top:Null<Float>;

	public var bottom:Null<Float>;

	public var centerX:Null<Float>;

	public var centerY:Null<Float>;

	public var layout:ILayout;

	/**
	 * 布局自身
	 */
	public function updateLayout():Void {
		layoutIDisplayObject(this);
	}

	public function onInit() {}

	public var rotation(default, set):Null<Float>;

	public function set_rotation(value:Null<Float>):Null<Float> {
		this.rotation = value;
		return value;
	}

	/**
	 * 开启交互
	 */
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
				// addChildAt(interactive, 0);
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

	/**
	 * 获取尺寸
	 * @return Bounds
	 */
	public function getSize():Bounds {
		var b = new Bounds();
		b.x = 0;
		b.y = 0;
		b.width = width == null ? 0 : width;
		b.height = height == null ? 0 : height;
		for (object in children) {
			var b2 = object.getSize();
			b2.addPos(object.x, object.y);
			b.addBounds(b2);
		}
		return b;
	}

	public function toString():String {
		return Type.getClassName(Type.getClass(this));
	}

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
