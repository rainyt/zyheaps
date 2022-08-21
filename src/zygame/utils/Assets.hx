package zygame.utils;

import h3d.mat.Texture;
import haxe.Json;
import zygame.display.Spine;
#if spine_hx
import zygame.res.SpineTextureAtlas;
#end
import hxd.res.Atlas;
import haxe.Exception;
import hxd.res.Sound;
import zygame.res.XMLAtlas;
import zygame.loader.parser.AtlasParser;
import haxe.io.Bytes;
import hxd.res.Image;
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
	/**
	 * 加载最大线程
	 */
	public var maxLoadCounts:Int = #if hl 30 #else 10 #end;

	/**
	 * 当前已载入的线程
	 */
	private var _currentLoadCounts:Int = 0;

	private var _loadlist:Array<BaseParser> = [];

	private var _loadedData:Map<AssetsType, Map<String, Dynamic>> = [];

	/**
	 * 当前载入进度
	 */
	private var _currentLoadIndex = 0;

	/**
	 * 已载入完成的数量
	 */
	private var _loadedCounts:Int = 0;

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
		加载精灵图
	**/
	public function loadAtlas(png:String, xml:String):Void {
		_loadlist.push(new AtlasParser({
			png: png,
			xml: xml
		}));
	}

	/**
	 * 加载Spine精灵图
	 * @param pngs 
	 * @param atlas 
	 */
	public function loadSpineAtlas(pngs:Array<String>, atlas:String):Void {
		#if spine_hx
		_loadlist.push(new zygame.loader.parser.SpineAtlasParser({
			pngs: pngs,
			atlas: atlas
		}));
		#end
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
		_currentLoadCounts = 0;
		_loadedCounts = 0;
		loadNext();
	}

	/**
	 * 开始加载下一个
	 */
	private function loadNext():Void {
		if (_currentLoadCounts >= maxLoadCounts)
			return;
		if (_loadedCounts >= _loadlist.length) {
			// 加载完成
			_onProgress(1);
			return;
		} else {
			_onProgress((_loadedCounts) / _loadlist.length);
		}
		_currentLoadCounts++;
		_currentLoadIndex++;
		var parser = _loadlist[_currentLoadIndex - 1];
		if (parser == null)
			return;
		parser.out = onAssetsOut;
		parser.error = onError;
		parser.load(this);
		// 发起多个加载
		if (_currentLoadCounts < maxLoadCounts)
			loadNext();
	}

	public function onError(msg:String):Void {
		trace("load fail:", msg);
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
			_loadedCounts++;
			_currentLoadCounts--;
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
	 * 获取纹理对象，请注意，ImageBitmap使用的是`Tile`数据，可直接通过`getBitmapDataTile`获取。
	 * @param id 
	 * @return BitmapData
	 */
	public function getBitmapData(id:String):BitmapData {
		if (hasTypeAssets(BITMAP_DATA, id))
			return getTypeAssets(BITMAP_DATA, id);
		if (hasTypeAssets(BITMAP, id)) {
			var bitmap:Image = getTypeAssets(BITMAP, id);
			var bmd = bitmap.toBitmap();
			setTypeAssets(BITMAP_DATA, id, bmd);
			return bmd;
		}
		return null;
	}

	/**
	 * 通过id获取3D纹理
	 * @param id 
	 * @return Texture
	 */
	public function getTexture3D(id:String):Texture {
		if (hasTypeAssets(TEXTURE_3D, id))
			return getTypeAssets(TEXTURE_3D, id);
		if (hasTypeAssets(BITMAP, id)) {
			var bitmap:Image = getTypeAssets(BITMAP, id);
			var bmd = bitmap.toBitmap();
			var t3d = Texture.fromBitmap(bmd);
			setTypeAssets(TEXTURE_3D, id, t3d);
			return t3d;
		}
		return null;
	}

	/**
	 * 获取位图瓦片对象
	 * @return Tile
	 */
	public function getBitmapDataTile(id:String):Tile {
		try {
			if (id.indexOf(":") != -1) {
				// 精灵图格式
				var arr = id.split(":");
				return getBitmapDataAtlasTile(arr[0], arr[1]);
			}
			if (!hasTypeAssets(BITMAP_TILE, id)) {
				var bitmap:Image = getTypeAssets(BITMAP, id);
				setTypeAssets(BITMAP_TILE, id, bitmap.toTile());
			}
		} catch (e:Exception) {
			trace("getBitmapDataTile error:", e.message);
		}
		return getTypeAssets(BITMAP_TILE, id);
	}

	/**
	 * 获取精灵图对象
	 * @param id 精灵图名称
	 * @param sprid 精灵名称
	 * @return Tile
	 */
	public function getBitmapDataAtlasTile(id:String, sprid:String):Tile {
		var atlas:XMLAtlas = getTypeAssets(ATLAS, id);
		return atlas.get(sprid);
	}

	/**
	 * 获取JSON对象
	 * @param id 
	 * @return Dynamic
	 */
	public function getJson(id:String):Dynamic {
		return getTypeAssets(JSON, id);
	}

	/**
	 * 获取XML对象
	 * @param id 
	 * @return Xml
	 */
	public function getXml(id:String):Xml {
		return getTypeAssets(XML, id);
	}

	/**
	 * 获取二进制对象
	 * @param id 
	 * @return Bytes
	 */
	public function getBytes(id:String):Bytes {
		return getTypeAssets(BYTES, id);
	}

	/**
	 * 获取音频对象
	 * @param id 
	 * @return Sound
	 */
	public function getSound(id:String):Sound {
		return getTypeAssets(SOUND, id);
	}

	/**
	 * 获取精灵图
	 * @param id 
	 * @return Atlas
	 */
	public function getAtlas(id:String):Atlas {
		return getTypeAssets(ATLAS, id);
	}

	/**
	 * 获取Spine的精灵图
	 * @param id 
	 * @return SpineTextureAtlas
	 */
	public function getSpineAtlas(id:String):#if spine_hx SpineTextureAtlas #else Dynamic #end {
		return getTypeAssets(SPINE_ATLAS, id);
	}

	/**
	 * 创建Spine对象
	 * @param atlasName 
	 * @param jsonName 
	 * @return Spine
	 */
	public function createSpine(atlasName:String, jsonName:String):#if spine_hx Spine #else Dynamic #end {
		return this.getSpineAtlas(atlasName).buildSpriteSkeleton(atlasName, this.getJson(jsonName));
	}

	/**
	 * 卸载所有资源
	 */
	public function unloadAll():Void {
		unloadTypeAssets(AssetsType.ATLAS);
		unloadTypeAssets(AssetsType.BITMAP);
		unloadTypeAssets(AssetsType.BITMAP_TILE);
		unloadTypeAssets(AssetsType.BYTES);
		unloadTypeAssets(AssetsType.JSON);
		unloadTypeAssets(AssetsType.SOUND);
		unloadTypeAssets(AssetsType.SPINE_ATLAS);
		unloadTypeAssets(AssetsType.XML);
	}

	/**
	 * 卸载对应类型的资源
	 * @param type 
	 */
	public function unloadTypeAssets(type:AssetsType):Void {
		if (_loadedData.exists(type)) {
			var m = _loadedData.get(type);
			for (key => value in m) {
				if (value is Tile) {
					cast(value, Tile).dispose();
				}
			}
			_loadedData.remove(type);
		}
	}
}
