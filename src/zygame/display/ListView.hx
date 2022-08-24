package zygame.display;

import zygame.display.data.ArrayCollection;
import zygame.display.data.ObjectRecycler;

/**
 * ListView组件
 */
class ListView extends ScrollView {
	/**
	 * 自定义渲染器
	 */
	public var itemRendererRecycler:ObjectRecycler<Dynamic>;

	/**
	 * 列表数据
	 */
	public var dataProvider:ArrayCollection<Dynamic>;

	override function onInit() {
		super.onInit();
	}
}
