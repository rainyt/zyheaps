package zygame.utils;

import h2d.col.Bounds;

class Rectangle extends Bounds {
	public function copy():Rectangle {
		var rect = new Rectangle();
		rect.x = this.x;
		rect.y = this.y;
		rect.width = this.width;
		rect.height = this.height;
		return rect;
	}
}
