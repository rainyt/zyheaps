package zygame.utils.hl;

import haxe.Json;
import sys.io.File;
import sys.io.FileOutput;

class Log {
	private static var __content:String = "";

	public static function init(logpath:String):Void {
		var oldTrace = haxe.Log.trace; // store old function
		haxe.Log.trace = function(v, ?infos) {
			__content += haxe.Log.formatOutput(v, infos) + "\n";
			oldTrace(v, infos);
			File.saveContent(logpath, __content);
		}
	}
}
