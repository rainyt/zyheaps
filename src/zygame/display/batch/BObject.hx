package zygame.display.batch;

import h2d.col.Matrix;
import h2d.SpriteBatch.BasicElement;
import zygame.core.Start;
import zygame.display.base.IBatchDisplayObject;

/**
 * 批处理基础类
 */
class BObject implements IBatchDisplayObject {
	
	private var __transform:Matrix = new Matrix();

	private var __worldTransform:Matrix = new Matrix();

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

	public function new() {
		this.x = 0;
		this.y = 0;
		this.scaleX = 1;
		this.scaleY = 1;
		this.rotation = 0;
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

	public function layout() {}

	public function onInit() {}

	public var rotation(default, set):Null<Float>;

	public function set_rotation(value:Null<Float>):Null<Float> {
		this.rotation = value;
		return value;
	}
}
