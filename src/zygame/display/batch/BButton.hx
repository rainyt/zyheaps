package zygame.display.batch;

import hxd.Event;
import zygame.display.data.ButtonSkin;

/**
 * 批渲染按钮
 */
class BButton extends BObject {
	/**
	 * 按钮皮肤
	 */
	public var skin:ButtonSkin;

	/**
	 * 按钮的皮肤显示对象
	 */
	public var img:BImage;

	public function new(skin:ButtonSkin, ?parent:BObject) {
		this.skin = skin;
		super(parent);
	}

	override function onInit() {
		super.onInit();
		img = new BImage(skin.up, this);
		this.enableInteractive = true;
		this.interactive.onPush = function(e) {
			img.scaleX = img.scaleY = 1;
			dirt = true;
			if (skin.down != null) {
				img.tile = skin.down;
			} else {
				// 缩放计算
				img.x = img.width * 0.03;
				img.y = img.height * 0.03;
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
		// this.interactive.onClick = function(e) {
		// 	trace("点击事件？");
		// }
		this.width = img.width;
		this.height = img.height;
	}

	/**
	 * 按钮的点击事件，请勿直接访问`interactive.onClick`
	 * @param e 
	 */
	dynamic public function onClick(btn:BButton, e:Event):Void {}
}
