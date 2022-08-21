package zygame.display;

import hxd.Window;
import h2d.col.Point;
import hxd.Event;
import h2d.col.Bounds;
import h2d.Object;
import h2d.Mask;

/**
 * ScrollView，含遮罩可滑动的容器
 */
class ScrollView extends Box {
	private var view:Mask;

	private var _touchid:Int = -1;

	private var _beginPos:Point = new Point();
	private var _beginTouchPos:Point;

	public function new(?parent:Object) {
		super(parent);
		this.view = new Mask(0, 0);
		super.addChildAt(view, 0);
		this.height = this.width = 300;
		this.enableInteractive = true;
		this.interactive.onPush = function(e:Event) {
			if (_touchid != e.touchId) {
				_touchid = e.touchId;
				_beginPos.x = view.scrollX;
				_beginPos.y = view.scrollY;
				_beginTouchPos = new Point(e.relX, e.relY);
				trace(e.relX, e.relY);
				Window.getInstance().addEventTarget(onTouchMove);
			}
		}
		this.interactive.onRelease = function(e:Event) {
			if (_touchid == e.touchId) {
				_touchid = -1;
				Window.getInstance().removeEventTarget(onTouchMove);
			}
		}
	}

	private function onTouchMove(e:Event):Void {
		switch e.kind {
			case EMove:
				if (_touchid == e.touchId) {
					// 移动计算
					var movepos = this.globalToLocal(new Point(e.relX, e.relY));
					var setX = _beginPos.x - (movepos.x - _beginTouchPos.x);
					var setY = _beginPos.y - (movepos.y - _beginTouchPos.y);
					this.view.scrollX = setX;
					this.view.scrollY = setY;
					trace(_beginPos, _beginTouchPos, movepos);
				}
			case EWheel:
			default:
		}
	}

	override function set_width(width:Null<Float>):Null<Float> {
		this.view.width = Std.int(width);
		return super.set_width(width);
	}

	override function set_height(height:Null<Float>):Null<Float> {
		this.view.height = Std.int(height);
		return super.set_height(height);
	}

	override function addChildAt(s:Object, i:Int) {
		view.addChildAt(s, i);
	}
}
