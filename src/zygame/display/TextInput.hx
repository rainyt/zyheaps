package zygame.display;

import h2d.RenderContext;
import h2d.Object;

/**
 * 输入文本支持
 */
@:access(h2d.TextInput)
class TextInput extends Box {
	private var _bg:Quad = new Quad(1, 1, 0xf0f0f0);

	private var _select:Quad = new Quad(1, 1, 0x0);

	private var _textInput:BaseTextInput;

	public function new(?parent:Object) {
		super(parent);
		this.addChild(_bg);
		this.addChild(_select);
		_select.alpha = 0.5;
		_textInput = new BaseTextInput(this);
		_textInput.setColor(0x0);
	}

	override function set_width(width:Null<Float>):Null<Float> {
		_textInput.width = width;
		_bg.width = width;
		return super.set_width(width);
	}

	override function set_height(height:Null<Float>):Null<Float> {
		_bg.height = height;
		return super.set_height(height);
	}

	override function draw(ctx:RenderContext) {
		if (dirt) {
			this._textInput.y = (this.contentHeight - this._textInput.textHeight) / 2;
		}
		this._select.y = _textInput.y;
		this._select.visible = this._textInput.selectionRange != null;
		if (_select.visible) {
			_select.height = this._textInput.calcHeight;
			if (this._textInput.selectionSize != 0) {
				_select.x = this._textInput.selectionPos - this._textInput.scrollX;
				if (_select.x < 0) {
					_select.x = 0;
					_select.width = this._textInput.selectionSize;
					if (_select.width > contentWidth) {
						_select.width = contentWidth;
					}
				} else {
					_select.width = this._textInput.selectionSize;
				}
			}
		} else {
			_select.width = 0;
		}
		super.draw(ctx);
	}
}
