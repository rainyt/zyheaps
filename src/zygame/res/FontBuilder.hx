package zygame.res;

import h2d.Font;
#if hl
import haxe.io.Bytes;
import zygame.utils.hl.AssetsTools;
import zygame.display.text.glyphme.TrueTypeFont;
import zygame.display.text.glyphme.GlyphMe;
#end
import hxd.res.DefaultFont;
import haxe.Exception;

using StringTools;

/**
 * 字体建造，兼容小游戏
 */
@:access(h2d.Font)
@:access(h2d.Tile)
class FontBuilder extends hxd.res.FontBuilder {
	#if hl
	/**
		hlttf字体
	**/
	private static var hlfontBytes:Map<String, Bytes> = [];
	#end

	public static function getFont(name:String, size:Int, ?options:hxd.res.FontBuilder.FontBuildOptions):h2d.Font {
		try {
			#if hl
			// 中文支持，IOS未验证
			if (name.endsWith("ttf")) {
				if (!hlfontBytes.exists(name)) {
					final bytes = AssetsTools.getBytes(name);
					hlfontBytes.set(name, bytes);
				}
				var font = GlyphMe.loadTrueTypeFontFile(name, hlfontBytes.get(name)).toTrueTypeFont(size);
				// 创建纹理
				font.generateAtlas({
					atlasSize: 512,
					fontHeightInPixels: size
				}, [options.chars]);
				return font;
			}
			#else
			var key = name + "#" + size;
			var f = hxd.res.FontBuilder.FONTS.get(key);
			if (f != null && f.tile.innerTex != null)
				return f;
			f = new FontBuilder(name, size, options).build();
			hxd.res.FontBuilder.FONTS.set(key, f);
			return f;
			#end
		} catch (e:Exception) {
			trace("getFont fail:" + e.message);
		}
		return DefaultFont.get();
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
