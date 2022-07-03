package zygame.loader.parser;

import zygame.utils.StringUtils;
import hxd.res.Image;
import zygame.res.XMLAtlas;

/**
 * 精灵图解析器，该读取XML格式的精灵图
 */
class AtlasParser extends BaseParser {
	override function process() {
		super.process();
		var bitmapParser = new BitmapDataParser(getData().png);
		bitmapParser.error = error;
		bitmapParser.out = function(parser:BaseParser, type:AssetsType, assetsData:Image, pro:Float) {
			var xmlParser = new XMLDataParser(getData().xml);
			xmlParser.out = function(parser:BaseParser, type:AssetsType, xmlData:Xml, pro:Float) {
				var atlas = new XMLAtlas(assetsData.toTile(), xmlData);
				this.out(this, ATLAS, atlas, 1);
			}
			xmlParser.error = error;
			xmlParser.process();
		}
		bitmapParser.process();
	}

	override function getName():String {
		return StringUtils.getName(this.getData().png);
	}
}
