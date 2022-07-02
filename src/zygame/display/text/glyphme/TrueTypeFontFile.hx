package zygame.display.text.glyphme;

import zygame.display.text.glyphme.GlyphMe;
import hl.Bytes;

/** one TrueTypeFontFile can contain multiple TrueTypeFontInfos */
class TrueTypeFontFile {
	public static var loaded:Array<TrueTypeFontFile> = []; // needs to stay loaded so the gc doesn't collect it

	public var fontFileBytes:Bytes;
	public var name:String;
	public var type:TrueTypeFontFileType;
	public var fonts:haxe.ds.Vector<TrueTypeFontInfo>;

	var initialized = false;

	public static function typeFromExtension(extension:String) {
		return switch (extension) {
			case "ttf":
				TTF;
			case "ttc":
				TTC;
			case "otf":
				OTF;
			case _:
				throw new haxe.Exception("Unsupported text file format: " + extension);
		}
	}

	public function new(name:String, type:TrueTypeFontFileType, bytes:haxe.io.Bytes, initialize = true) {
		final fontFileBytes = Bytes.fromBytes(bytes);
		final numberOfFonts = GlyphMeNative.getNumberOfFonts(fontFileBytes);

		this.fontFileBytes = fontFileBytes;
		this.name = name;
		this.type = type;
		this.fonts = new haxe.ds.Vector<TrueTypeFontInfo>(numberOfFonts);

		if (initialize)
			this.initialize();
	}

	public function initialize() {
		for (index in 0...fonts.length)
			fonts[index] = cast GlyphMeNative.getTrueTypeFontInfo(fontFileBytes, index);
		initialized = true;
		loaded.push(this);
	}

	public function getInfos() {
		return fonts.toArray();
	}

	public function toTrueTypeFont(sizeInPixels:Int, alphaCutoff:Float = 0.5, smoothing:Float = -1):TrueTypeFont {
		return new TrueTypeFont(getInfos(), sizeInPixels, alphaCutoff, smoothing);
	}
}
