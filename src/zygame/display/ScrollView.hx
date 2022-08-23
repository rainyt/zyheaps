package zygame.display;

import h2d.col.Matrix;
import zygame.core.Start;
import zygame.utils.Lib;
import motion.Actuate;
import hxd.Window;
import h2d.col.Point;
import hxd.Event;
import h2d.col.Bounds;
import h2d.Object;
import h2d.Mask;

/**
 * ScrollView，含遮罩可滑动的容器，使用：
 * ```haxe
 * var view = new ScrollView(this);
 * var quad = new Quad(600,600,0xff0000,view);
 * ```
 */
class ScrollView extends Box {
	private var view:Mask;

	private var _box:Box;

	private var _touchid:Int = -1;

	private var _beginPos:Point = new Point();
	private var _beginTouchPos:Point;
	private var _movePos:Point;
	private var _lastPos:Point;

	public var scrollX(get, set):Float;

	function get_scrollX():Float {
		var s = getAbsPos().getScale();
		return view.scrollX / s.x;
	}

	function set_scrollX(scrollX:Float):Float {
		var s = getAbsPos().getScale();
		this.view.scrollX = scrollX * s.x;
		return scrollX;
	}

	public var scrollY(get, set):Float;

	function get_scrollY():Float {
		var s = getAbsPos().getScale();
		return view.scrollY / s.y;
	}

	function set_scrollY(scrollY:Float):Float {
		var s = getAbsPos().getScale();
		view.scrollY = scrollY * s.y;
		return scrollY;
	}

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
				_beginPos.x = this.scrollX;
				_beginPos.y = this.scrollY;
				_beginTouchPos = new Point(e.relX, e.relY);
				Window.getInstance().addEventTarget(onTouchMove);
			}
		}
		this.interactive.onRelease = function(e:Event) {
			if (_touchid == e.touchId) {
				_touchid = -1;
				Window.getInstance().removeEventTarget(onTouchMove);
				var vx = _lastPos == null ? 0 : (_movePos.x - _lastPos.x) * 10;
				var vy = _lastPos == null ? 0 : (_movePos.y - _lastPos.y) * 10;
				scrollTo(this.scrollX - vx, this.scrollY - vy);
			}
		}
		this.interactive.onWheel = function(e:Event) {
			if (__actuate != null)
				Actuate.stop(__actuate);
			__actuate = null;
			this.scrollY -= e.wheelDelta * 3;
			scrollTo(this.scrollX, this.scrollY, 0);
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
					this.scrollX = setX;
					this.scrollY = setY;
					Lib.setTimeout(() -> {
						_lastPos = null;
					}, 100);
				}
			default:
		}
	}

	public var timeOffest:Float = 0.5;

	private var __actuate:motion.actuators.GenericActuator<Dynamic>;

	/**
	 * 移动到对应的X/Y
	 * @param x x轴
	 * @param y y轴
	 * @param overrideTimeOffest 覆盖时间偏移值，没有提供时，则使用timeOffest
	 */
	public function scrollTo(x:Float, y:Float, overrideTimeOffest:Null<Float> = null):Void {
		var size = this._box.getSize();
		var targetX = x;
		var targetY = y;
		if (targetX < 0)
			targetX = 0;
		if (targetY < 0)
			targetY = 0;
		size.width -= this.width;
		size.height -= this.height;
		// size.width *= Start.current.currentScale;
		// size.height *= Start.current.currentScale;
		if (targetX > size.width) {
			targetX = size.width;
		}
		if (targetY > size.height) {
			targetY = size.height;
		}
		if (overrideTimeOffest == 0) {
			this.scrollX = targetX;
			this.scrollY = targetY;
		} else
			__actuate = Actuate.update(__scrollTo, overrideTimeOffest != null ? overrideTimeOffest : timeOffest, [this.scrollX, this.scrollY],
				[targetX, targetY]);
	}

	private function __scrollTo(x:Float, y:Float):Void {
		this.scrollX = x;
		this.scrollY = y;
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
