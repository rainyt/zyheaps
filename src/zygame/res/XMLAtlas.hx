package zygame.res;

import h2d.Tile;
import hxd.res.Atlas;

/**
 * 使用XML格式的精灵图集支持
 */
class XMLAtlas extends Atlas {
	public var rootTile:Tile;

	public var xml:Xml;

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
