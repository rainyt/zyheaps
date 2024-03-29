package zygame.skins;

import hxd.clipper.Rect;
import zygame.utils.MaxRectsBinPack.FreeRectangleChoiceHeuristic;
import h2d.Tile;
import h3d.mat.Texture;
import zygame.res.XMLAtlas;

/**
 * 皮肤构造器，通过定义皮肤对象，使用`SkinsBuilder`将他们编译成一个`Tile`对象，并产生一个`XMLAtlas`精灵图对象提供渲染使用。
 */
class SkinsBuilder {
	/**
	 * 使用皮肤构造器生成出来的九宫格图，都可以使用这个进行设置
	 */
	// public static var defaultScale9Grid:Rect = new Rect(6, 6, 6, 6);
	private var _readyArray:Array<BaseSkin> = [];

	/**
	 * 通过提供的BaseSkin对象，进行构造精灵图集的支持
	 * @param array 
	 * @return XMLAtlas
	 */
	public function new(array:Array<BaseSkin>) {
		_readyArray = array;
	}

	/**
	 * 构造精灵图
	 * @return XMLAtlas
	 */
	public function build():XMLAtlas {
		var texture = new Texture(512, 512, [Target]);
		var doc = Xml.createDocument();
		var xml = Xml.createElement("TextureAtlas");
		doc.addChild(xml);
		var rect = new zygame.utils.MaxRectsBinPack(512, 512, false);
		for (index => value in _readyArray) {
			value.readyGraphics();
			var cw = value.contentWidth;
			var ch = value.contentHeight;
			var r = rect.insert(Std.int(cw), Std.int(ch), FreeRectangleChoiceHeuristic.BestShortSideFit);
			value.build(texture, r.x, r.y);
			var rect = value.readyScale9Grid();
			var item = Xml.createElement("TextureAtlas");
			item.set("name", value.name == null ? "default" : value.name);
			item.set("x", Std.string(value.x));
			item.set("y", Std.string(value.y));
			item.set("width", Std.string(cw));
			item.set("height", Std.string(ch));
			if (rect != null) {
				// 左上右下
				item.set("slice9", rect.left + " " + rect.top + " " + rect.right + " " + rect.bottom);
			}
			xml.addChild(item);
		}
		var tile = Tile.fromTexture(texture);
		trace("create ", doc);
		return new XMLAtlas(tile, doc);
	}
}
