package zygame.display.base;

import zygame.display.data.ObjectRecycler;
import h2d.col.Point;
import format.bmp.Tools;
import zygame.core.Start;
import hxd.Event;
import h2d.RenderContext;
import h2d.Object;

/**
 * 基础分割器
 */
class BaseDividedBox extends Box {
	private static var defalutObjectRecycler:ObjectRecycler<DragDividedRenderer> = new ObjectRecycler(() -> {
		return new DragDividedRenderer();
	});

	public var dragItemRenderer:ObjectRecycler<DragDividedRenderer> = null;

	private var __children:Array<Object> = [];

	private var __moveItem:DragDividedRenderer;

	private var __moveIndex:Int = -1;

	private var __moveOffest:Float = 0;

	private var __dividedState:Map<Int, Float> = [];

	public function getChilds():Array<Object> {
		return __children;
	}

	override function addChildAt(s:Object, pos:Int) {
		if (__children.indexOf(s) == -1) {
			__children.push(s);
		}
		this.dirt = true;
	}

	public function createDragItemRenderer():DragDividedRenderer {
		return dragItemRenderer == null ? defalutObjectRecycler.create() : dragItemRenderer.create();
	}

	override function draw(ctx:RenderContext) {
		if (dirt) {
			this.updateLayout();
		}
		super.draw(ctx);
	}

	override function onInit() {
		super.onInit();
		this.addEventListener(zygame.events.Event.PUSH, onItemPush);
		this.addEventListener(zygame.events.Event.RELEASE, onItemRelease);
	}

	private function onItemPush(e:zygame.events.Event):Void {
		e.preventDefault();
		__moveItem = e.target;
		__moveOffest = 0;
		Start.current.s2d.startCapture(onMove);
	}

	private function onItemRelease(e:zygame.events.Event):Void {
		Start.current.s2d.stopCapture();
	}

	private function superAddChild(obj:Object, index:Null<Int> = null):Void {
		super.addChildAt(cast obj, index == null ? this.numChildren : index);
	}

	public function onMove(e:Event):Void {}

	public function setDividedState(index:Int, width:Float):Void {
		__dividedState.set(index, width);
		this.updateLayout();
	}
}
