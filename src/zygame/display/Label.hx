package zygame.display;

import hxd.res.FontBuilder;
import h2d.Text;

/**
 * 文本类
 */
class Label extends Text {
	/**
	 * 默认字体
	 */
	public static var defaultFont:String = "黑体";

	/**
	 * 构造一个Label文本
	 * @param text 
	 */
	public function new(text:String = null) {
		super(null);
		if (text != null)
			this.text = text;
	}

	override function set_text(t:String):String {
		if (font != null && t == this.text)
			return t;
		// 当文本存在时，将旧的文本清理，重新构造
		if (this.font != null)
			this.font.dispose();
		this.font = FontBuilder.getFont(defaultFont, _size, {
			chars: t
		});
		return super.set_text(t);
	}

	private var _size:Int = 24;

	/**
	 * 设置文本大小
	 * @param size 
	 */
	public function setSize(size:Int):Void {
		_size = size;
		if (font != null) {
			if (_size != font.size) {
				font = null;
				this.text = this.text;
			}
		}
	}

	/**
	 * 设置文本颜色
	 * @param color 
	 */
	public function setColor(color:UInt):Void {
		this.color.setColor(0xff000000 + color);
	}
}
