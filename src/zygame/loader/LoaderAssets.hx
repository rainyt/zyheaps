package zygame.loader;

import zygame.loader.parser.BitmapDataParser;
import zygame.loader.parser.BaseParser;

/**
 * ZAssets核心载入器，可简易使用扩展
 */
 class LoaderAssets {
	/**
	 * 单独载入文件路径支持的格式载入解析器，可通过继承ParserBase来扩展自定义载入方式。supportType直接返回true的解析器请勿加入到此列表。
	 */
	public static var fileparser:Array<Class<BaseParser>> = [
		BitmapDataParser
		// SparticleParser,
		// MP3Parser,
		// TextParser,
		// #if castle
		// CDBParser,
		// #end
		// XMLParser,
		// JSONParser,
		// BitmapDataParser
		// #if (ldtk), LDTKParser
		// #end
	];
}
