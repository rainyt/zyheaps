import zygame.display.Button;
import zygame.display.Label;
import zygame.res.FontBuilder;
import h2d.Font;
import zygame.events.Event;
import zygame.display.data.ObjectRecycler;
import zygame.display.data.ArrayCollection;
import zygame.display.ItemRenderer;
import zygame.display.ListView;
import zygame.display.Scene;

class ListViewScene extends Scene {
	override function onInit() {
		super.onInit();
		// ListView
		var listview = new ListView(this);
		listview.x = 500;
		listview.width = 800;
		listview.top = 0;
		listview.bottom = 0;
		// 竖向布局
		// listview.layout = new zygame.layout.VerticalListLayout();
		// 横向布局
		// listview.layout = new zygame.layout.HorizontalListLayout();
		// 流布局
		// listview.layout = new zygame.layout.FlowListLayout();
		// 虚拟竖向布局
		// listview.layout = new zygame.layout.VirualVerticalListLayout();
		// 虚拟横向布局
		// listview.layout = new zygame.layout.VirualHorizontalListLayout();
		// 虚拟流布局
		listview.layout = new zygame.layout.VirualFlowListLayout();
		// 数据
		listview.dataProvider = new ArrayCollection([
			for (i in 0...50000) {
				i;
			}
		]);
		// 自定义渲染器
		listview.itemRendererRecycler = ObjectRecycler.withClass(CustomItemRenderer);
		// 禁止溢出滑动
		listview.enableOutEasing = true;
		listview.addEventListener(Event.CHANGE, function(e) {
			trace("我选中的内容是:", listview.selectedItem, "索引是", listview.selectedIndex);
		});
	}
}

class CustomItemRenderer extends ItemRenderer {
	private static var _font:Font;

	public static function getFont():Font {
		if (_font == null) {
			_font = FontBuilder.getFont(Label.defaultFont, 50, {
				chars: "1234567890"
			});
		}
		return _font;
	}

	public var button:Button;

	override function onInit() {
		super.onInit();
		button = Button.create("btn_LvSe", null, this);
		button.label.useFont = getFont();
		button.width = 260;
		button.height = 100;
	}

	override function set_data(value:Dynamic):Dynamic {
		button.text = Std.string(value);
		return super.set_data(value);
	}

	override function set_selected(value:Bool):Bool {
		button.label.alpha = value ? 1 : 0.5;
		return super.set_selected(value);
	}
}
