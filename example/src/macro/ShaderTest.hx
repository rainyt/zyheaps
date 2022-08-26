package macro;

import haxe.macro.Expr.ComplexType;
import haxe.macro.Context;
import haxe.macro.Expr.Field;

class ShaderTest {
	macro public function build():Array<Field> {
		var fields = Context.getBuildFields();
		for (index => value in fields) {
			if (value.name == "SRC") {
				// trace(value);
			} else {
				// trace(value);
			}
		}
		return null;
	}
}
