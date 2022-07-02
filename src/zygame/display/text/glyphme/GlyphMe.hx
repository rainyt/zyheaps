package zygame.display.text.glyphme;

import zygame.utils.hl.AssetsTools;
import hl.Bytes;

class GlyphMe {
	/** Allows you to load a font files' fontInfos without creating a specific TrueTypeFont instance.
	 * You could use these as fallbacks for a specific instance or for whatever you want. */
	public static function loadTrueTypeFontFile(path:String, bytes:haxe.io.Bytes) {
		final nameAndExtension = path.split(".");
		return new TrueTypeFontFile(nameAndExtension[0], TrueTypeFontFile.typeFromExtension(nameAndExtension[1]), bytes);
	}

	/** Allows you to load a font files' fontInfos without creating a specific TrueTypeFont instance.
	 * You could use these as fallbacks for a specific instance or for whatever you want. */
	public static function toTrueTypeFontFile(fontResource:hxd.res.Resource) {
		return new TrueTypeFontFile(fontResource.name, TrueTypeFontFile.typeFromExtension(fontResource.entry.extension), fontResource.entry.getBytes());
	}

	/** Directly creates a TrueTypeFont instance to be used for h2d.Text rendering etc. 
	 * If the font file contains multiple fonts, All fonts after the first one will be used as fallbacks 
	 * see heaps SDFfonts for an explanation of the other parameters */
	public static function toTrueTypeFont(fontResource:hxd.res.Resource, sizeInPixels:Int, alphaCutoff:Float = 0.5, smoothing:Float = -1):TrueTypeFont {
		return toTrueTypeFontFile(fontResource).toTrueTypeFont(sizeInPixels, alphaCutoff, smoothing);
	}
}

@:hlNative("glyphme")
class GlyphMeNative {
	public static function getKerning(fontInfo:Bytes, g1:Int, g2:Int):Int {
		return 0;
	}

	public static function getGlyph(codePoint:Int, fontInfo:Bytes, scale:hl.F32, padding:Int, onedgeValue:Int, pixelDistScale:hl.F32):Dynamic<GlyphInfo> {
		return null;
	}

	public static function getNumberOfFonts(fontFileBytes:Bytes):Int {
		return -1;
	}

	public static function getTrueTypeFontInfo(fontFileBytes:Bytes, index:Int):Dynamic<TrueTypeFontInfo> {
		return null;
	}
}

typedef GlyphInfo = {
	index:Int,
	codePoint:Int,
	rgba:Bytes,
	width:Int,
	height:Int,
	offsetX:Int,
	offsetY:Int,
	advanceX:Int,
}

/** one TrueTypeFontFile can contain multiple TrueTypeFontInfos */
typedef TrueTypeFontInfo = {
	stbttFontInfo:Bytes,
	ascent:Int,
	descent:Int,
	lineGap:Int,
}

enum TrueTypeFontFileType {
	TTF;
	TTC;
	OTF;
}
