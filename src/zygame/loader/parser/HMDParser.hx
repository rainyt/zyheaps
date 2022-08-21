package zygame.loader.parser;

import hxd.res.Model;
import hxd.fs.BytesFileSystem;
import zygame.utils.AssetsUtils;

/**
 * 加载HMD格式的3D数据，如果提供的路径是fbx后缀，也可以加载
 */
class HMDParser extends BaseParser {
	public static function support(type:String):Bool {
		var ext = type.toLowerCase();
		return ext == "fbx" || ext == "hmd";
	}

	override function process() {
		var path:String = getData();
		path = path.toLowerCase();
		if (StringTools.endsWith(path, ".fbx"))
			path = StringTools.replace(path, ".fbx", ".hmd");
		AssetsUtils.loadBytes(path, function(data) {
			var fs = new BytesFileEntry(path, data);
			var m = new Model(fs);
			var hmd = m.toHmd();
			this.out(this, HMD, hmd, 1);
		}, error);
	}
}
