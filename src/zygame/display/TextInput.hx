package zygame.display;

import h2d.col.Bounds;
import h2d.RenderContext;
import zygame.core.Start;
import zygame.layout.ILayout;
import zygame.display.base.IDisplayObject;
#if hl
import zygame.display.text.glyphme.TrueTypeFont;
#end
import hxd.Event;
import h2d.Font;
import zygame.res.FontBuilder;
import h2d.Object;
import hxd.res.DefaultFont;

/**
 * 自动兼容中文输入的TextInput
 */
class TextInput extends h2d.TextInput implements IDisplayObject {
	private var _select:Quad = new Quad(1, 1);

	public var mouseChildren:Bool = true;

	public function new(?parent:Object) {
		var font = FontBuilder.getFont(Label.defaultFont, _size, {
			chars: " "
		});
		#if hl
		@:privateAccess cast(font, TrueTypeFont).__forceHasChar = true;
		#end
		super(font, parent);
		this.addChildAt(_select, 0);
		_select.alpha = 0.5;
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
				this.font = FontBuilder.getFont(Label.defaultFont, _size, {
					chars: text == "" ? " " : text
				});
				#if hl
				@:privateAccess cast(font, TrueTypeFont).__forceHasChar = true;
				#end
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

	/**
	 * 指定使用的字体
	 */
	public var useFont:Font;

	override function set_text(t:String):String {
		if (t == null) {
			t = "null";
		}
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
				if (font != DefaultFont.get())
					this.font.dispose();
			}
			this.font = FontBuilder.getFont(Label.defaultFont, _size, {
				chars: t
			});
			#if hl
			@:privateAccess cast(this.font, TrueTypeFont).__forceHasChar = true;
			#end
		}
		// this.dirt = true;
		return super.set_text(t);
	}

	public function set_width(value:Null<Float>):Null<Float> {
		this.width = value;
		dirt = true;
		return value;
	}

	public var width(default, set):Null<Float>;

	public var height(default, set):Null<Float>;

	public function set_height(value:Null<Float>):Null<Float> {
		this.height = value;
		dirt = true;
		return value;
	}

	public var left:Null<Float>;

	public var right:Null<Float>;

	public var top:Null<Float>;

	public var bottom:Null<Float>;

	public var centerX:Null<Float>;

	public var centerY:Null<Float>;

	public var layout:ILayout;

	public function updateLayout() {
		layoutIDisplayObject(this);
	}

	public function onInit() {}

	public var dirt:Bool;

	public function get_stageWidth():Float {
		return Start.current.stageWidth;
	}

	public var stageWidth(get, never):Float;

	public function get_stageHeight():Float {
		return Start.current.stageHeight;
	}

	public var stageHeight(get, never):Float;

	public var ids:Map<String, Object>;

	public function get<T:Object>(id:String, c:Class<T>):T {
		throw new haxe.exceptions.NotImplementedException();
	}

	public var contentWidth(get, null):Float;

	public function get_contentWidth():Float {
		return getWidth(this);
	}

	public var contentHeight(get, null):Float;

	public function get_contentHeight():Float {
		return getHeight(this);
	}

	override function draw(ctx:RenderContext) {
		if (dirt) {
			if (width != null) {
				this.inputWidth = Std.int(width);
			}
			dirt = false;
		}
		this._select.visible = this.selectionRange != null;
		if (_select.visible) {
			_select.height = this.calcHeight;
			if (this.selectionSize != 0) {
				_select.x = this.selectionPos - this.scrollX;
				_select.width = this.selectionSize;
			}
		} else {
			_select.width = 0;
		}
		super.draw(ctx);
	}

	public var percentageWidth(default, set):Null<Float>;

	public function set_percentageWidth(value:Null<Float>):Null<Float> {
		this.percentageWidth = value;
		return value;
	}

	public var percentageHeight(default, set):Null<Float>;

	public function set_percentageHeight(value:Null<Float>):Null<Float> {
		this.percentageHeight = value;
		return value;
	}
}
