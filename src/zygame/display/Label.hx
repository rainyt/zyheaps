package zygame.display;

import h2d.RenderContext;
import zygame.core.Start;
import zygame.display.base.IDisplayObject;
import h2d.Object;
import h2d.Font;
import zygame.res.FontBuilder;
import h2d.Text;

/**
 * 文本类
 */
class Label extends Text implements IDisplayObject {
	/**
	 * 默认字体
	 */
	public static var defaultFont:String = "黑体";

	public var dirt:Bool = false;

	public var width(default, set):Null<Float>;

	function set_width(width:Null<Float>):Null<Float> {
		this.width = width;
		dirt = true;
		return width;
	}

	public var height(default, set):Null<Float>;

	function set_height(height:Null<Float>):Null<Float> {
		this.height = height;
		dirt = true;
		return height;
	}

	/**
	 * 距离左边
	 */
	public var left:Null<Float>;

	/**
	 * 距离右边
	 */
	public var right:Null<Float>;

	/**
	 * 距离顶部
	 */
	public var top:Null<Float>;

	/**
	 * 距离底部
	 */
	public var bottom:Null<Float>;

	/**
	 * 居中X
	 */
	public var centerX:Null<Float>;

	/**
	 * 居中Y
	 */
	public var centerY:Null<Float>;

	/**
	 * 布局自身
	 */
	public function layout():Void {}

	/**
	 * 构造一个Label文本
	 * @param text 
	 */
	public function new(text:String = null, parent:Object = null) {
		super(null, parent);
		if (text != null)
			this.text = text;
	}

	/**
	 * 指定使用的字体
	 */
	public var useFont:Font;

	override function set_text(t:String):String {
		if (font != null && t == this.text)
			return t;
		// 当文本存在时，将旧的文本清理，重新构造
		if (useFont != null) {
			if (font != useFont) {
				this.font.dispose();
			}
			this.font = useFont;
		} else {
			if (this.font != null) {
				this.font.dispose();
			}
			this.font = FontBuilder.getFont(defaultFont, _size, {
				chars: t
			});
		}
		this.dirt = true;
		return super.set_text(t);
	}

	private var _size:Int = 40;

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

	public function get_stageWidth():Float {
		return Start.current.stageWidth;
	}

	public var stageWidth(get, never):Float;

	public function get_stageHeight():Float {
		return Start.current.stageHeight;
	}

	public var stageHeight(get, never):Float;

	override function draw(ctx:RenderContext) {
		dirt = false;
		super.draw(ctx);
	}
}
