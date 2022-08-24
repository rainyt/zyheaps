package zygame.display.data;

class ArrayCollection<T> {
	public var source:Array<T> = [];

	public function new(array:Array<T>) {
		this.source = array;
	}

	public function add(data:T):Void {
		this.source.push(data);
		if (onChange != null)
			this.onChange();
	}

	public function remove(data:T):Void {
		this.source.remove(data);
		if (onChange != null)
			this.onChange();
	}

	dynamic public function onChange():Void {}
}
