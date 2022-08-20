package zygame.display;

import zygame.display.base.IDisplayObject;
import h2d.Tile;
import hxd.Event;
import h2d.RenderContext;
import zygame.display.data.ButtonSkin;
import h2d.Object;

/**
 * 	简易按钮，一般无需通过interactive重写onClick，可直接使用`onClick`访问点击事件。当只有up纹理时，按钮则启动缩放计算，存在up/down两种纹理时，则会切换呈现。
 */
class Button extends Box {
	/**
	 * 快捷创建一个按钮
	 * @param up 
	 * @param down 
	 * @param parent 
	 * @return Button
	 */
	public static function create(up:Dynamic, ?down:Dynamic, ?parent:Object):Button {
		return new Button(new ButtonSkin(up, down), parent);
	}

	/**
	 * 按钮皮肤
	 */
	public var skin:ButtonSkin;

	/**
	 * 按钮的皮肤显示对象
	 */
	private var display:IDisplayObject;

	/**
	 * 按钮的文本显示对象
	 */
	public var label:Label;

	/**
	 * 设置按钮的文本显示内容
	 */
	public var text(get, set):String;

	/**
	 * 设置文本的偏移值
	 */
	public var labelOffest = {
		x: 0.,
		y: -6.
	}

	function get_text():String {
		return label.text;
	}

	function set_text(text:String):String {
		label.text = text;
		return text;
	}

	private function setSkinDisplay(skin:Dynamic):Void {
		if (display != null) {
			cast(display, Object).remove();
		}
		display = convertIDisplayObject(skin);
		if (display == null)
			return;
		display.width = this.width;
		display.height = this.height;
		this.addChildAt(cast display, 0);
	}

	public function new(skin:ButtonSkin, ?parent:Object) {
		super(parent);
		this.dirt = true;
		this.skin = skin;
		this.setSkinDisplay(this.skin.up);
		this.enableInteractive = true;
		this.interactive.onPush = function(e) {
			e.propagate = false;
			if (display == null)
				return;
			cast(display, Object).scale(1);
			dirt = true;
			if (skin.down != null) {
				setSkinDisplay(skin.down);
			} else {
				// 缩放计算
				var rect = display.getSize();
				display.x = rect.width * 0.03;
				display.y = rect.height * 0.03;
				display.scaleX = 0.94;
				display.scaleY = 0.94;
			}
		}
		this.interactive.onRelease = function(e) {
			e.propagate = false;
			if (display == null)
				return;
			setSkinDisplay(skin.up);
			display.scaleX = 1;
			display.scaleY = 1;
			display.x = display.y = 0;
			dirt = true;
		}
		this.interactive.onClick = function(e) {
			e.propagate = false;
			this.onClick(this, e);
		}
		label = new Label(null, this);
		label.textAlign = Center;
		var rect = display.getSize();
		label.maxWidth = rect.width;
		this.width = rect.width;
		this.height = rect.height;
	}

	private function updateLabelContext():Void {
		if (display == null)
			return;
		var size = label.getSize();
		label.x = labelOffest.x;
		label.y = display.height / 2 - size.height / 2 + labelOffest.y;
		label.maxWidth = display.width / label.scaleX;
		cast(display, Object).addChild(label);
	}

	override function draw(ctx:RenderContext) {
		if (display == null)
			return;
		if (dirt || label.dirt || display.dirt) {
			this.updateLabelContext();
		}
		super.draw(ctx);
	}

	/**
	 * 按钮的点击事件，请勿直接访问`interactive.onClick`
	 * @param e 
	 */
	dynamic public function onClick(btn:Button, e:Event):Void {}

	override function set_width(width:Null<Float>):Null<Float> {
		this.display.width = width;
		label.maxWidth = display.width;
		return super.set_width(width);
	}

	override function set_height(height:Null<Float>):Null<Float> {
		this.display.height = height;
		return super.set_height(height);
	}
}
