package zygame.display.data;

import zygame.display.base.IItemRenderer;

class ObjectRecycler<T:IItemRenderer> {
	public function new(create:Void->T, ?reset:T->Void) {
		this.create = create;
		this.reset = reset;
	}

	dynamic public function create():T {
		return null;
	}

	dynamic public function reset(obj:T):Void {}
}
