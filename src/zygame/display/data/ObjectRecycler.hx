package zygame.display.data;

import zygame.display.base.IItemRenderer;

/**
 * ObjectRecycler用于垃圾回收处理
 */
class ObjectRecycler<T:IItemRenderer> {
	private var _array:Array<T> = [];

	public function new(create:Void->T, ?reset:T->Void) {
		this._create = create;
		this._reset = reset;
	}

	dynamic private function _create():T {
		return null;
	}

	dynamic private function _reset(obj:T):Void {}

	public function create():T {
		if (_array.length > 0) {
			return _array.shift();
		}
		return _create();
	}

	public function release(obj:T):Void {
		if (_array.indexOf(obj) == -1) {
			_array.push(obj);
			_reset(obj);
		}
	}

	/**
	 * 检测类型是否一致
	 * @param obj 
	 */
	public function testClass(obj:Dynamic):Bool {
		var item = create();
		var type = Type.getClass(item);
		var type2 = Type.getClass(obj);
		return type == type2;
	}
}
