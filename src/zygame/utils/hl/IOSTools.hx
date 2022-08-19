package zygame.utils.hl;

import hxd.impl.Float32;

@:hlNative("iostools")
class IOSTools {
	/**
	 * 获取Mac的分辨率Dpi比
	 * @return Float32
	 */
	public static function get_pixel_ratio():Float32 {
		return 1;
	}

	/**
	 * 打开文件选择器
	 */
	public static function open_select_dir(cb:Dynamic->Void):Void {}
}
