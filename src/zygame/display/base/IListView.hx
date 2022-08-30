package zygame.display.base;

import zygame.display.data.ArrayCollection;
import zygame.display.data.ObjectRecycler;

/**
 * ListView的基础API
 * - `DownListView`
 * - `ListView`
 */
interface IListView {
	/**
	 * 自定义渲染器
	 * ```haxe
	 * listview.itemRendererRecycler = ObjectRecycler.withClass(ItemRendererClass);
	 * ```
	 */
	public var itemRendererRecycler:ObjectRecycler<Dynamic>;

	dynamic function itemToText(data:Dynamic):String;

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
	 * 是否已经选中
	 * @param index 
	 * @return Bool
	 */
	public function hasSelectedIndex(index:Int):Bool;

	/**
	 * 当前选中的列表
	 */
	public var selectedItems(get, set):Array<Dynamic>;

	/**
	 * 刷新数据
	 */
	public function updateData():Void;
}
