package zygame.display.base;

interface IItemRenderer {
	public var data(default, set):Dynamic;

	public var selected(default, set):Bool;

	/**
	 * 关联的ListView容器
	 */
	public var listView:IListView;
}
