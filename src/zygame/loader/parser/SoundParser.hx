package zygame.loader.parser;

import hxd.fs.BytesFileSystem.BytesFileEntry;
import hxd.res.Sound;
import zygame.utils.AssetsUtils;

class SoundParser extends BaseParser {
	public static function support(type:String):Bool {
		return type == "mp3";
	}

	override function process() {
		super.process();
		AssetsUtils.loadBytes(getData(), function(data) {
			var sound = new Sound(new BytesFileEntry(getData(), data));
			this.out(this, SOUND, sound, 1);
		}, error);
	}

	override function getData():Dynamic {
		var path:String = super.getData();
		#if hl
		path = StringTools.replace(path, ".mp3", ".ogg");
		#end
		return path;
	}
}
