package zygame.utils;

/**
 * 整数迭代器，可以正向和反向
 * @param start 
 * @param end 
 */
function intIterator(start:Int, end:Int, step:Int = 1):BaseIterator {
	if (start > end) {
		return new IntSubIterator(end, start, step);
	} else {
		return new IntAddIterator(start, end, step);
	}
}

private class IntAddIterator extends BaseIterator {
	override function hasNext():Bool {
		return min < max;
	}

	override function next():Int {
		var value = min;
		min += step;
		return value;
	}
}

private class IntSubIterator extends BaseIterator {
	override function hasNext():Bool {
		return max > min;
	}

	override function next():Int {
		max -= step;
		return max;
	}
}

private class BaseIterator {
	private var min:Int;
	private var max:Int;
	private var step:Int;

	public inline function new(min, max, step = 1) {
		this.min = min;
		this.max = max;
		this.step = step;
	}

	public function hasNext():Bool {
		throw "Not support";
	}

	public function next():Int {
		throw "Not support";
	}
}
