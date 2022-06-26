package zygame.core;

import zygame.utils.ScaleUtils;
import hxd.App;

/**
 * 启动类
 */
class Start extends App {
	private var _hdsize = {
		width: 0,
		height: 0
	}

	/**
	 * 构造一个启动类
	 * @param width 适配宽度
	 * @param height 适配高度
	 * @param debug 是否开启调试信息
	 */
	public function new(width:Int = 1920, height:Int = 1080, debug:Bool = false) {
		super();
		_hdsize.width = width;
		_hdsize.height = height;
	}

	override function init() {
		super.init();
		this.onResize();
	}

	override function onResize() {
		super.onResize();
		trace("stage size:", this.s2d.width, this.s2d.height);
		var scale = ScaleUtils.mathScale(this.s2d.width, this.s2d.height, _hdsize.width, _hdsize.height);
		this.s2d.setScale(scale);
		trace("changed scale:", scale, "size:", this.s2d.width, this.s2d.height);
	}
}
