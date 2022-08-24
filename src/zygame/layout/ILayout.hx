package zygame.layout;

import zygame.display.base.IObject;
import h2d.Object;

interface ILayout {
	public function updateLayout(self:IObject, children:Array<Object>):Void;
}
