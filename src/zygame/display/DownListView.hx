package zygame.display;

import zygame.display.data.ObjectRecycler;
import zygame.display.data.ArrayCollection;
import zygame.display.base.IListView;
import h2d.col.Point;
import zygame.core.Start;
import zygame.display.data.ButtonSkin;
import h2d.Object;

/**
 * 下拉框的列表渲染，使用：
 * ```haxe
 * var down = new DownListView(new ButtonSkin("ui1","ui2"),this);
 * down.dataProvider = new ArrayCollection([1,2,3,4,5]);
 * data.selectedIndex = 0;
 * trace(data.selectedItem);
 * ```
 */
class DownListView extends Box implements IListView {
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
			var pos = this.localToGlobal(new Point(this.x, this.y));
			var listview = new ListView(Start.current.topView);
			listview.dataProvider = this.dataProvider;
			listview.x = pos.x;
			listview.y = pos.y + this.height + 1;
			listview.width = this.width;
			listview.height = 400;
			listview.interactive.onFocusLost = (e) -> {
				listview.dataProvider = null;
				listview.remove();
			}
			listview.interactive.focus();
			listview.backgroundColor = 0xfcfcfc;
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

	public var itemRendererRecycler:ObjectRecycler<Dynamic>;

	public var dataProvider(default, set):ArrayCollection<Dynamic>;

	public function set_dataProvider(value:ArrayCollection<Dynamic>):ArrayCollection<Dynamic> {
		this.dataProvider = value;
		return value;
	}

	public var selectedItem(default, set):Dynamic;

	public function set_selectedItem(value:Dynamic):Dynamic {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function get_selectedIndex():Int {
		throw new haxe.exceptions.NotImplementedException();
	}

	public var selectedIndex(get, set):Int;

	public function set_selectedIndex(value:Int):Int {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function hasSelectedIndex(index:Int):Bool {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function get_selectedItems():Array<Dynamic> {
		throw new haxe.exceptions.NotImplementedException();
	}

	public var selectedItems(get, set):Array<Dynamic>;

	public function set_selectedItems(value:Array<Dynamic>):Array<Dynamic> {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function updateData() {}
}
