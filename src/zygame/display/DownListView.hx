package zygame.display;

import h2d.RenderContext;
import zygame.events.Event;
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
	/**
	 * 默认文案，当没有选择任何项目时，则会显示该默认文案
	 */
	public var defaultText:String = "请选择";

	private var __button:Button;

	public var text(default, set):String;

	public function setSize(size:Int):Void {
		__button.label.setSize(size);
	}

	private function set_text(v:String):String {
		this.__button.text = v;
		return v;
	}

	public dynamic function itemToText(data:Dynamic):String {
		return Std.string(data);
	}

	public function new(skin:ButtonSkin, ?parent:Object) {
		super(parent);
		__button = new Button(skin, this);
		__button.onClick = (b, e) -> {
			// 打开下拉选项
			var pos = this.localToGlobal(new Point(this.x, this.y));
			var listview = new ListView(Start.current.topView);
			listview.itemToText = itemToText;
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
			listview.addEventListener(Event.CHANGE, function(e:Event) {
				this.selectedItem = listview.selectedItem;
				this.dispatchEvent(e, true);
				listview.dataProvider = null;
				listview.remove();
			});
		}
		this.height = 64;
		this.width = 200;
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
		this.selectedItem = value;
		this.updateData();
		return value;
	}

	public function get_selectedIndex():Int {
		if (dataProvider == null)
			return -1;
		return dataProvider.source.indexOf(this.selectedItem);
	}

	public var selectedIndex(get, set):Int;

	public function set_selectedIndex(value:Int):Int {
		if (dataProvider != null) {
			this.selectedItem = dataProvider.source[value];
		}
		updateData();
		return value;
	}

	private var __selectIndexs:Array<Int> = [];

	public function hasSelectedIndex(index:Int):Bool {
		return __selectIndexs.indexOf(index) != -1;
	}

	public function get_selectedItems():Array<Dynamic> {
		if (selectedItem == null)
			return [];
		return [selectedItem];
	}

	public var selectedItems(get, set):Array<Dynamic>;

	public function set_selectedItems(value:Array<Dynamic>):Array<Dynamic> {
		return value;
	}

	override function draw(ctx:RenderContext) {
		if (dirt)
			this.updateData();
		super.draw(ctx);
	}

	public function updateData() {
		if (this.selectedItem == null) {
			this.text = defaultText;
		} else {
			this.text = itemToText(selectedItem);
		}
	}
}
