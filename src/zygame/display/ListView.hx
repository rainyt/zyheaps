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

	override function updateLayout() {}

	override function __scrollTo(x:Float, y:Float) {
		super.__scrollTo(x, y);
		if (__moveUpdateData) {
			this.updateData();
		}
	}
}
