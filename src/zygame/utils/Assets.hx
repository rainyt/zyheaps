package zygame.utils;

import hxd.res.Image;
import h3d.mat.Texture;
import hxd.fs.LoadedBitmap;
import hxd.BitmapData;
import zygame.loader.parser.AssetsType;
import zygame.loader.LoaderAssets;
import zygame.loader.parser.BaseParser;
import h2d.Tile;

using Reflect;

/**
 * 资源管理器
 */
class Assets {
	private var _loadlist:Array<BaseParser> = [];

	private var _loadedData:Map<AssetsType, Map<String, Dynamic>> = [];

	/**
	 * 当前载入进度
	 */
	private var _currentLoadIndex = 0;

	/**
	 * 加载回调
	 */
	private var _onProgress:Float->Void;

	public function new() {}

	/**
	 * 加载单个文件
	 * @param file 
	 */
	public function loadFile(file:String):Void {
		var ext = StringUtils.getExtType(file);
		for (parser in LoaderAssets.fileparser) {
			var bool = parser.callMethod(parser.getProperty("support"), [ext]);
			if (bool) {
				_loadlist.push(Type.createInstance(parser, [file]));
				break;
			}
		}
	}

	/**
	 * 用于重写解析路径名称
	 * @param path
	 * @return String
	 */
	dynamic public function onPasingPathName(path:String):String {
		return StringUtils.getName(path);
	}

	/**
	 * 开始加载
	 * @param cb 
	 */
	public function start(cb:Float->Void):Void {
		_onProgress = cb;
		_currentLoadIndex = 0;
		loadNext();
	}

	/**
	 * 开始加载下一个
	 */
	private function loadNext():Void {
		if (_currentLoadIndex >= _loadlist.length) {
			// 加载完成
			_onProgress(1);
			return;
		} else {
			_onProgress(_currentLoadIndex / _loadlist.length);
		}
		var parser = _loadlist[_currentLoadIndex];
		parser.out = onAssetsOut;
		parser.load(this);
	}

	/**
	 * 加载完成资源输出
	 * @param parser 
	 * @param type 
	 * @param assetsData 
	 * @param pro 
	 */
	private function onAssetsOut(parser:BaseParser, type:AssetsType, assetsData:Dynamic, pro:Float):Void {
		if (assetsData != null) {
			setTypeAssets(type, parser.getName(), assetsData);
		}
		if (pro == 1) {
			// 下一个
			_currentLoadIndex++;
			this.loadNext();
		}
	}

	/**
	 * 判断此类型的资源是否存在
	 * @param type 
	 * @param name 
	 * @return Bool
	 */
	public function hasTypeAssets(type:AssetsType, name:String):Bool {
		if (_loadedData.exists(type)) {
			return _loadedData.get(type).exists(name);
		}
		return false;
	}

	/**
	 * 获取此类型的资源
	 * @param type 
	 * @param name 
	 * @return Dynamic
	 */
	public function getTypeAssets(type:AssetsType, name:String):Any {
		if (_loadedData.exists(type)) {
			return _loadedData.get(type).get(name);
		}
		return null;
	}

	/**
	 * 设置此类型的资源
	 * @param type 
	 * @param name 
	 * @param data 
	 */
	public function setTypeAssets(type:AssetsType, name:String, data:Any):Void {
		if (!_loadedData.exists(type)) {
			_loadedData.set(type, []);
		}
		_loadedData.get(type).set(name, data);
	}

	/**
	 * 获取纹理数据，请注意，ImageBitmap使用的是`Tile`数据，可直接通过`getBitmapDataTile`获取。
	 * @param id 
	 * @return BitmapData
	 */
	public function getBitmapData(id:String):BitmapData {
		if (hasTypeAssets(BITMAP, id)) {
			var bitmap:LoadedBitmap = getTypeAssets(BITMAP, id);
			return bitmap.toBitmap();
		}
		return null;
	}

	/**
	 * 获取位图瓦片数据
	 * @return Tile
	 */
	public function getBitmapDataTile(id:String):Tile {
		if (!hasTypeAssets(BITMAP_TILE, id)) {
			var bitmap:Image = getTypeAssets(BITMAP, id);
			setTypeAssets(BITMAP_TILE, id, Tile.fromTexture(bitmap.toTexture()));
		}
		return getTypeAssets(BITMAP_TILE, id);
	}

	/** 获取JSON **/
	public function getJson(id:String):Dynamic {
		return getTypeAssets(JSON, id);
	}
}
