package zygame.utils;

/**
 * 缩放比例工具
 */
class ScaleUtils {
	/**
	 * 计算出适合的缩放比例
	 * @param stageWidth 
	 * @param stageHeight 
	 * @param hdwidth 
	 * @param hdheight 
	 * @param lockLandscape 
	 * @param scalePower 
	 * @return Float
	 */
	public static function mathScale(stageWidth:Float, stageHeight:Float, hdwidth:Float, hdheight:Float, lockLandscape:Bool = false,
			scalePower:Bool = false):Float {
		if (hdwidth == 0 || hdheight == 0)
			return 1;
		var currentScale:Float = 1;
		var wscale:Float = 1;
		var hscale:Float = 1;
		if (lockLandscape && stageWidth < stageHeight) {
			hscale = Math.round(stageWidth / hdheight * 1000000) / 1000000;
			wscale = Math.round(stageHeight / hdwidth * 1000000) / 1000000;
		} else {
			wscale = Math.round(stageWidth / hdwidth * 1000000) / 1000000;
			hscale = Math.round(stageHeight / hdheight * 1000000) / 1000000;
		}

		if (wscale < hscale) {
			currentScale = wscale;
		} else {
			currentScale = hscale;
		}

		if (scalePower) {
			var currentScale3 = Std.int(currentScale);
			if (currentScale != currentScale3) {
				currentScale = currentScale3 + 1;
			}
			if (currentScale < 1) {
				currentScale = 1;
			}
		}

		return currentScale;
	}
}
