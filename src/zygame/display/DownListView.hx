package zygame.display;

import zygame.display.data.ButtonSkin;
import h2d.Object;

/**
 * 下拉框的列表渲染
 */
class DownListView extends Box {
	private var __button:Button;

	public var text(default, set):String;

	public function setSize(size:Int):Void {
		__button.label.setSize(size);
	}

	private function set_text(v:String):String {
		this.__button.text = v;
		return v;
	}

	public function new(skin:ButtonSkin, ?parent:Object) {
		super(parent);
		__button = new Button(skin, this);
		__button.onClick = (b, e) -> {
			// 打开下拉选项
		}
	}

	override function set_width(width:Null<Float>):Null<Float> {
		__button.width = width;
		return super.set_width(width);
	}

	override function set_height(height:Null<Float>):Null<Float> {
		__button.height = height;
		return super.set_height(height);
	}
}
