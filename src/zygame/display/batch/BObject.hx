package zygame.display.batch;

import h2d.SpriteBatch.BasicElement;
import zygame.core.Start;
import zygame.display.base.IBatchDisplayObject;

/**
 * 批处理基础类
 */
class BObject implements IBatchDisplayObject {
	private var __worldX:Float = 0;

	private var __worldY:Float = 0;

	public var children:Array<BObject> = [];

	public function addChild(child:BObject):Void {
		this.addChildAt(child, children.length);
	}

	public function addChildAt(child:BObject, pos:Int):Void {
		if (child.parent != null) {
			removeChild(child);
		}
		children[pos] = child;
	}

	public function removeChild(child:BObject):Void {
		if (child.parent == this) {
			children.remove(child);
		}
	}

	public function new() {
        this.x = 0;
        this.y = 0;
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

	public var parent(default, null):BImage;

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
}
