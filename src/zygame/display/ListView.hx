package zygame.display;

import hxd.Event;
import h2d.RenderContext;
import zygame.display.data.ArrayCollection;
import zygame.display.data.ObjectRecycler;
import zygame.layout.VerticalListLayout;

/**
 * ListView组件，通过`itemRendererRecycler`启动自定义渲染：
 * ```haxe
 * listview.itemRendererRecycler = ObjectRecycler.withClass(ItemRendererClass);
 * ```
 * 通过`dataProvider`提供渲染数据：
 * ```haxe
 * listview.dataProvider = new ArrayCollection([{id:1},{id:2},{id:3}]);
 * ```
 * 默认的布局为竖向列表布局，如果需要更换布局，请参考可选布局：
 * - `zygame.layout.HorizontalListLayout`
 * - `zygame.layout.VerticalListLayout`
 */
class ListView extends ScrollView {
	/**
	 * 移动的时候更新数据，默认为false
	 */
	private var __moveUpdateData:Bool = false;

	/**
	 * 自定义渲染器
	 * ```haxe
	 * listview.itemRendererRecycler = ObjectRecycler.withClass(ItemRendererClass);
	 * ```
	 */
	public var itemRendererRecycler:ObjectRecycler<Dynamic>;

	/**
	 * 列表数据
	 * ```haxe
	 * listview.dataProvider = new ArrayCollection([{id:1},{id:2},{id:3}]);
	 * ```
	 */
	public var dataProvider(default, set):ArrayCollection<Dynamic>;

	/**
	 * 当前选中的对象
	 */
	public var selectedItem(default, set):Dynamic;

	/**
	 * 当前选中的索引
	 */
	public var selectedIndex(get, set):Int;

	/**
	 * 所有选中的索引
	 */
	private var __selectedIndexs:Array<Int> = [];

	/**
	 * 是否已经选中
	 * @param index 
	 * @return Bool
	 */
	public function hasSelectedIndex(index:Int):Bool {
		return __selectedIndexs.indexOf(index) != -1;
	}

	/**
	 * 当前选中的列表
	 */
	public var selectedItems(get, set):Array<Dynamic>;

	private function get_selectedItems():Array<Dynamic> {
		var array = [];
		if (dataProvider == null)
			return array;
		for (i in __selectedIndexs) {
			array.push(dataProvider.source[i]);
		}
		return array;
	}

	private function set_selectedItems(data:Array<Dynamic>) {
		__selectedIndexs = [];
		if (dataProvider == null) {
			return null;
		}
		for (index => value in data) {
			__selectedIndexs.push(dataProvider.source.indexOf(value));
		}
		return data;
	}

	private function get_selectedIndex():Int {
		if (selectedItem == null || dataProvider == null) {
			return -1;
		}
		return dataProvider.source.indexOf(selectedItem);
	}

	private function set_selectedIndex(v:Int):Int {
		if (dataProvider == null) {
			return -1;
		}
		this.selectedItem = dataProvider.source[v];
		return v;
	}

	private function set_selectedItem(v:Dynamic):Dynamic {
		this.selectedItem = v;
		return v;
	}

	private function set_dataProvider(data:ArrayCollection<Dynamic>):ArrayCollection<Dynamic> {
		if (this.dataProvider != null) {
			this.dataProvider.onChange = null;
		}
		this.dataProvider = data;
		this.dataProvider.onChange = __onChange;
		this.dirt = true;
		return data;
	}

	override function onInit() {
		super.onInit();
		this.layout = new VerticalListLayout();
		this.addEventListener(zygame.events.Event.CLICK, onItemRendererClick);
	}

	private function onItemRendererClick(e:zygame.events.Event):Void {
		var value = (e.target is ItemRenderer) ? cast(e.target, ItemRenderer).data : null;
		if (this.selectedItem != value) {
			this.selectedItem = value;
			// 单选支持
			__selectedIndexs = [this.selectedIndex];
			// 更新数据
			this.updateData();
			// 发生变化时触发
			this.dispatchEvent(new zygame.events.Event(zygame.events.Event.CHANGE));
		}
	}

	private function __onChange():Void {
		this.dirt = true;
	}

	/**
	 * 刷新所有数据
	 */
	public function updateData():Void {
		this.layout.updateLayout(this, @:private this._box.children);
	}

	override function draw(ctx:RenderContext) {
		if (dirt) {
			this.updateData();
		}
		super.draw(ctx);
	}

	override function __scrollTo(x:Float, y:Float) {
		super.__scrollTo(x, y);
		if (__moveUpdateData) {
			this.updateData();
		}
	}
}
