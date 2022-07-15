package zygame.macro;

import haxe.macro.Context;
import haxe.macro.Expr;

/**
 * 取消内联
 */
class Uninline {
	macro public function build(args:Array<String>):Array<Field> {
		var array = Context.getBuildFields();
		for (key in array) {
			if (args.indexOf(key.name) != -1) {
				key.access.remove(Access.AInline);
			}
		}
		return array;
	}
}
