package zygame.loader.parser;

import zygame.res.AssetsBuilder;
import zygame.utils.StringUtils;
import zygame.utils.Assets;
import hxd.res.Model;
import hxd.fs.BytesFileSystem;
import zygame.utils.AssetsUtils;

/**
 * 加载HMD格式的3D数据，如果提供的路径是fbx后缀，也可以加载
 */
class HMDParser extends BaseParser {
	private var _setName:String = null;

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
			// 解析这里的所有图片
			var rootName = getName();
			var rootPath = path.substr(0, path.lastIndexOf("/") + 1);
			var assets:Assets = new Assets();
			for (material in hmd.header.materials) {
				if (material.diffuseTexture != null && !checkExist(rootName, material.diffuseTexture)) {
					assets.loadFile(rootPath + material.diffuseTexture);
				}
				if (material.specularTexture != null && !checkExist(rootName, material.specularTexture)) {
					assets.loadFile(rootPath + material.specularTexture);
				}
				if (material.normalMap != null && !checkExist(rootName, material.normalMap)) {
					assets.loadFile(rootPath + material.normalMap);
				}
			}
			assets.start((f) -> {
				if (f == 1) {
					// 使用HMDid返回
					var map = @:privateAccess assets._loadedData.get(BITMAP);
					if (map != null) {
						for (key => value in map) {
							_setName = rootName + ":" + key;
							this.out(this, BITMAP, value, 0);
						};
						_setName = null;
						this.out(this, HMD, hmd, 1);
					}
				}
			});
		}, error);
	}

	/**
	 * 检测是否已经存在一样的资源
	 * @param id 
	 * @param path 
	 * @return Bool
	 */
	function checkExist(id:String, path:String):Bool {
		id += StringUtils.getName(path);
		return AssetsBuilder.getTexture3D(id) != null;
	}

	override function getName():String {
		return _setName != null ? _setName : super.getName();
	}
}
