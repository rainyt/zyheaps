package zygame.display.data;

class ArrayCollection<T> {
	public var source:Array<T> = [];

	public function new(array:Array<T>) {
		this.source = array;
	}
}
