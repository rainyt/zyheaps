package zygame.display;

import h2d.RenderContext;
import zygame.display.base.IDisplayObject;
import h2d.Object;

/**
 * 进度条
 */
class Progress extends Box {
	/**
	 * 底部显示对象
	 */
	private var _bgdisplay:IDisplayObject;

	/**
	 * 底部显示对象
	 */
	private var _topdisplay:IDisplayObject;

	/**
	 * 进度条样式，默认是横向的进度条
	 */
	public var style(default, set):ProgressStyle = HORIZONTAL;

	private function set_style(s:ProgressStyle):ProgressStyle {
		this.dirt = true;
		this.style = s;
		return s;
	}

	/**
	 * 构造一个进度条组件
	 * @param bg 进度条底部
	 * @param top 进度条显示对象
	 * @param parent 父节点
	 */
	public function new(bg:Dynamic, top:Dynamic, ?parent:Object) {
		super(parent);
		_bgdisplay = convertIDisplayObject(bg, this);
		_topdisplay = convertIDisplayObject(top, this);
		this.dirt = true;
	}

	/**
	 * 设置进度值
	 */
	public var progress(default, set):Float = 1;

	function set_progress(progress:Float):Float {
		this.dirt = true;
		this.progress = progress;
		return progress;
	}

	override function draw(ctx:RenderContext) {
		if (dirt) {
			switch style {
				case VERTICAL:
					_topdisplay.width = _bgdisplay.width;
					_topdisplay.height = _bgdisplay.height * this.progress;
					_topdisplay.x = 0;
					_topdisplay.y = _bgdisplay.height - _topdisplay.height;
				case HORIZONTAL:
					_topdisplay.height = _bgdisplay.height;
					_topdisplay.width = _bgdisplay.width * this.progress;
					_topdisplay.x = 0;
					_topdisplay.y = 0;
			}
		}
		super.draw(ctx);
	}
}

/**
 * 进度条样式
 */
enum abstract ProgressStyle(String) to String {
	/**
	 * 竖向
	 */
	var VERTICAL = "vertical";

	/**
	 * 横向
	 */
	var HORIZONTAL = "horizontal";
}
