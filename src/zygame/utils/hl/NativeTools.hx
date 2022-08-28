package zygame.utils.hl;

import sys.io.File;
import sys.io.Process;
import hxd.impl.Float32;

#if !window
@:hlNative("iostools")
#end
class NativeTools {
	#if mac
	/**
	 * 获取Mac的分辨率Dpi比
	 * @return Float32
	 */
	public static function get_pixel_ratio():Float32 {
		return 1;
	}
	#end

	#if window
	public static function open_select_dir(cb:Dynamic->Void):Void {
		Sys.command("Contents\\Frameworks\\filedialog.exe " + Sys.getCwd() + "filedialog.temp");
		var path = File.getContent(Sys.getCwd() + "/filedialog.temp");
		path = StringTools.replace(path, "\\", "/");
		cb({
			path: path
		});
	}

	#elseif mac
	/**
	 * 打开文件选择器
	 */
	public static function open_select_dir(cb:Dynamic->Void):Void {}
	#end
}
