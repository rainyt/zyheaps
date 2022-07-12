package zygame.display;

import h2d.Tile;
import hxd.Event;
import h2d.RenderContext;
import zygame.display.data.ButtonSkin;
import h2d.Object;

/**
	简易按钮，一般无需通过interactive重写onClick，可直接使用`onClick`访问点击事件。当只有up纹理时，按钮则启动缩放计算，存在up/down两种纹理时，则会切换呈现。
**/
class Button extends Flow {
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
	public var img:ImageBitmap;

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

	public function new(skin:ButtonSkin, ?parent:Object) {
		super(parent);
		this.dirt = true;
		this.skin = skin;
		img = new ImageBitmap(this.skin.up, this);
		this.enableInteractive = true;
		this.interactive.onPush = function(e) {
			img.scale(1);
			dirt = true;
			if (skin.down != null) {
				img.tile = skin.down;
			} else {
				// 缩放计算
				var rect = img.getSize();
				img.x = rect.width * 0.03;
				img.y = rect.height * 0.03;
				img.scaleX = 0.94;
				img.scaleY = 0.94;
			}
		}
		this.interactive.onRelease = function(e) {
			img.tile = skin.up;
			img.scaleX = 1;
			img.scaleY = 1;
			img.x = img.y = 0;
			dirt = true;
		}
		this.interactive.onClick = function(e) {
			this.onClick(this, e);
		}
		label = new Label(null, img);
		label.textAlign = Center;
	}

	private function updateLabelContext():Void {
		label.x = img.width / 2 + labelOffest.x;
		label.y = img.height / 2 - label.textHeight / 2 + labelOffest.y;
	}

	override function draw(ctx:RenderContext) {
		if (dirt || label.dirt || img.dirt) {
			this.updateLabelContext();
			dirt = false;
		}
		super.draw(ctx);
	}

	/**
	 * 按钮的点击事件，请勿直接访问`interactive.onClick`
	 * @param e 
	 */
	dynamic public function onClick(btn:Button, e:Event):Void {}

	override function set_width(width:Float):Float {
		this.img.width = width;
		return super.set_width(width);
	}

	override function set_height(height:Float):Float {
		this.img.height = height;
		return super.set_height(height);
	}
}
