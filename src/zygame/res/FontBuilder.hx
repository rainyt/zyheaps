package zygame.res;

import h2d.Font;

/**
 * 字体建造，兼容小游戏
 */
@:access(h2d.Font)
@:access(h2d.Tile)
class FontBuilder extends hxd.res.FontBuilder {
	public static function getFont(name:String, size:Int, ?options:hxd.res.FontBuilder.FontBuildOptions) {
		var key = name + "#" + size;
		var f = hxd.res.FontBuilder.FONTS.get(key);
		if (f != null && f.tile.innerTex != null)
			return f;
		f = new FontBuilder(name, size, options).build();
		hxd.res.FontBuilder.FONTS.set(key, f);
		return f;
	}

	#if js
	/**
	 * 兼容小游戏
	 * @param font 
	 * @param chars 
	 * @return Int
	 */
	override function getFontHeight(font:Font, chars:String):Int {
		#if wechat
		return font.size + 4;
		#else
		return super.getFontHeight(font, chars);
		#end
	}
	#end
}
