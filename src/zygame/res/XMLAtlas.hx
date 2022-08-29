package zygame.res;

import hxd.clipper.Rect;
import h2d.Tile;
import hxd.res.Atlas;

/**
 * 使用XML格式的精灵图集支持
 */
class XMLAtlas extends Atlas {
	public var rootTile:Tile;

	public var xml:Xml;

	/**
	 * 九宫格图映射
	 */
	private var _s9dmap:Map<String, Rect> = [];

	/**
	 * 根据Tile获取对应的九宫格数据
	 * @param tile 
	 * @return Rect
	 */
	public function getScale9GridById(id:String):Rect {
		return _s9dmap.get(id);
	}

	/**
	 * 根据Tile设置九宫格数据
	 * @param tile 
	 * @param rect 
	 */
	public function setScale9Grid(id:String, rect:Rect):Void {
		_s9dmap.set(id, rect);
	}

	/**
	 * 构造一个XML格式的精灵图数据
	 * @param png 
	 * @param xml 
	 */
	public function new(png:Tile, xml:Xml) {
		super(null);
		rootTile = png;
		this.xml = xml;
	}

	override function getContents():Map<String, Array<{t:Tile, width:Int, height:Int}>> {
		if (contents != null)
			return contents;
		contents = [];
		var frame:FrameData = {};
		for (item in xml.firstElement().elements()) {
			frame.x = Std.parseInt(item.get("x"));
			frame.y = Std.parseInt(item.get("y"));
			frame.width = Std.parseInt(item.get("width"));
			frame.height = Std.parseInt(item.get("height"));
			if (item.exists("frameX"))
				frame.frameX = -Std.parseInt(item.get("frameX"));
			if (item.exists("frameY"))
				frame.frameY = -Std.parseInt(item.get("frameY"));
			if (item.exists("frameWidth"))
				frame.frameWidth = Std.parseInt(item.get("frameWidth"));
			if (item.exists("frameHeight"))
				frame.frameHeight = Std.parseInt(item.get("frameHeight"));
			frame.name = (item.get("name"));
			// 暂不支持九宫格
			// if (item.exists("slice9")) {
			// this.bindScale9(item.get("name"), item.get("slice9"));
			// }
			if (frame.frameX == null)
				frame.frameX = frame.x;
			if (frame.frameY == null)
				frame.frameY = frame.y;
			if (frame.frameWidth == null)
				frame.frameWidth = frame.width;
			if (frame.frameHeight == null)
				frame.frameHeight = frame.height;
			var tile = rootTile.sub(frame.x, frame.y, frame.width, frame.height, frame.frameX, frame.frameY);
			contents.set(frame.name, [{t: tile, width: frame.frameWidth, height: frame.frameHeight}]);
			// 九图数据
			if (item.exists("slice9")) {
				// 存在九图数据时，应绑定
				var slice9 = item.get("slice9").split(" ");
				var rect = new Rect(Std.parseInt(slice9[0]), Std.parseInt(slice9[1]), Std.parseInt(slice9[2]), Std.parseInt(slice9[3]));
				this.setScale9Grid(frame.name, rect);
			}
		}
		return contents;
	}
}

typedef FrameData = {
	?name:String,
	?x:Float,
	?y:Float,
	?frameX:Float,
	?frameY:Float,
	?width:Int,
	?height:Int,
	?frameWidth:Int,
	?frameHeight:Int
}
