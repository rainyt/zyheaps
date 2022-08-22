package zygame.display;

import zygame.utils.Lib;
import motion.Actuate;
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

	private var _box:Box;

	private var _touchid:Int = -1;

	private var _beginPos:Point = new Point();
	private var _beginTouchPos:Point;
	private var _movePos:Point;
	private var _lastPos:Point;

	public function new(?parent:Object) {
		super(parent);
		this.view = new Mask(0, 0);
		_box = new Box(view);
		super.addChildAt(view, 0);
		this.height = this.width = 300;
		this.enableInteractive = true;
		this.interactive.onPush = function(e:Event) {
			if (_touchid != e.touchId) {
				_lastPos = null;
				if (__actuate != null)
					Actuate.stop(__actuate);
				__actuate = null;
				_touchid = e.touchId;
				_beginPos.x = view.scrollX;
				_beginPos.y = view.scrollY;
				_beginTouchPos = new Point(e.relX, e.relY);
				Window.getInstance().addEventTarget(onTouchMove);
			}
		}
		this.interactive.onRelease = function(e:Event) {
			if (_touchid == e.touchId) {
				_touchid = -1;
				Window.getInstance().removeEventTarget(onTouchMove);
				scrollTo(0, 0);
			}
		}
		this.interactive.onWheel = function(e:Event) {
			this.view.scrollY += e.wheelDelta * 3;
		}
	}

	private function onTouchMove(e:Event):Void {
		switch e.kind {
			case EMove:
				if (_touchid == e.touchId) {
					// 移动计算
					if (_movePos != null) {
						_lastPos = _movePos;
					}
					_movePos = this.globalToLocal(new Point(e.relX, e.relY));
					var setX = _beginPos.x - (_movePos.x - _beginTouchPos.x);
					var setY = _beginPos.y - (_movePos.y - _beginTouchPos.y);
					this.view.scrollX = setX;
					this.view.scrollY = setY;
					Lib.setTimeout(() -> {
						_lastPos = null;
					}, 100);
				}
			default:
		}
	}

	public var timeOffest:Float = 0.5;

	private var __actuate:motion.actuators.GenericActuator<Dynamic>;

	public function scrollTo(x:Float, y:Float):Void {
		var size = this._box.getSize();
		var vx = _lastPos == null ? 0 : (_movePos.x - _lastPos.x) * 10;
		var vy = _lastPos == null ? 0 : (_movePos.y - _lastPos.y) * 10;
		var targetX = view.scrollX - vx;
		var targetY = view.scrollY - vy;
		if (targetX < 0)
			targetX = 0;
		if (targetY < 0)
			targetY = 0;
		size.width -= this.width;
		size.height -= this.height;
		if (targetX > size.width) {
			targetX = size.width;
		}
		if (targetY > size.height) {
			targetY = size.height;
		}
		__actuate = Actuate.update(__scrollTo, timeOffest, [view.scrollX, view.scrollY], [targetX, targetY]);
	}

	private function __scrollTo(x:Float, y:Float):Void {
		view.scrollX = x;
		view.scrollY = y;
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
		_box.addChildAt(s, i);
	}
}
