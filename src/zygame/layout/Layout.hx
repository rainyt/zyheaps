package zygame.layout;

import zygame.display.base.IObject;
import h2d.Object;

class Layout implements ILayout {
	public var paddingLeft:Null<Float>;

	public var paddingRight:Null<Float>;

	public var paddingTop:Null<Float>;

	public var paddingBottom:Null<Float>;

	public var padding:Null<Float>;

	public function new() {}

	public function updateLayout(self:IObject, children:Array<Object>) {}

	public var autoLayout:Bool = true;
}
