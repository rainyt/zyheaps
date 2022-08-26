import zygame.events.Event;
import h2d.Font;
import zygame.display.Label;
import zygame.res.FontBuilder;
import zygame.display.Button;
import zygame.display.data.ObjectRecycler;
import zygame.display.ItemRenderer;
import zygame.display.data.ArrayCollection;
import zygame.display.ListView;
import hxd.fmt.hmd.Data.Material;
import zygame.utils.Lib;
import zygame.utils.Assets;
import zygame.display.Quad;
import zygame.core.Start;
import zygame.res.AssetsBuilder;
import zygame.display.Scene;
import zygame.display.ScrollView;

class Object3DScene extends Scene {
	override function onInit() {
		super.onInit();
		// 创建模型
		var obj = AssetsBuilder.create3DModel("tree");
		Start.current.s3d.addChild(obj);
		obj.scale(0.25);

		Start.current.engine.backgroundColor = 0x061626;

		var scroll:ScrollView = new ScrollView();
		this.addChild(scroll);
		scroll.height = 500;

		var quad = new Quad(600, 400, 0xff0000, scroll);
		var quad2 = new Quad(300, 700, 0x00ff00, scroll);

		var assets = new Assets();
		assets.loadFile("assets/monkey.fbx");
		assets.start((f) -> {
			if (f == 1) {
				var obj = assets.create3DModel("monkey");
				Start.current.s3d.addChild(obj);
				obj.scale(0.25);
				// 快捷创建一个帧事件
				zygame.utils.FrameEngine.create((f) -> {
					obj.rotate(Lib.angleToRadian(1), Lib.angleToRadian(1), Lib.angleToRadian(1));
				});
				Lib.setTimeout(function() {
					trace("1秒后执行");
				}, 1000);
				Lib.setInterval(function() {
					// trace("每2秒执行一次");
				}, 2000);
				Lib.nextFrameCall(() -> {
					trace("下一帧调用");
				});
			}
		});

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
