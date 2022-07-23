package zygame.res;

import zygame.utils.StringUtils;
import spine.support.graphics.TextureLoader;
import spine.attachments.AtlasAttachmentLoader;
import spine.support.graphics.TextureAtlas;
import spine.SkeletonJson;
import spine.SkeletonData;
import zygame.display.Spine;
import hxd.res.Image;

class SpineTextureAtlas {
	private var _spriteSkeletonManager:SkeletonJson;

	// private var _spriteSkeletonManagerBytes:SkeletonBinary;
	private var _images:Map<String, Image>;

	private var _data:String;

	private var _skeletonData:Map<String, SkeletonData>;

	public var path:String = null;

	public var id:String = null;

	public function new(maps:Map<String, Image>, data:String):Void {
		_images = maps;
		_data = data;
		_skeletonData = new Map<String, SkeletonData>();
	}

	/**
	 * 获取Sprite骨骼管理器
	 * @return SkeletonJson
	 */
	public function getSpriteSkeletonManager(isBytes:Bool = false):SkeletonJson {
		if (_spriteSkeletonManager == null) {
			var loader:ImageTextureLoader = new ImageTextureLoader(_images);
			var atlas:TextureAtlas = new TextureAtlas(_data, loader);
			_spriteSkeletonManager = new SkeletonJson(new AtlasAttachmentLoader(atlas));
		}
		return _spriteSkeletonManager;
	}

	/**
	 * 生成龙骨数据
	 * @param json 
	 * @return SkeletonData
	 */
	public function buildSpriteSkeletonData(id:String, data:String):SkeletonData {
		if (_skeletonData.exists(id)) {
			return _skeletonData.get(id);
		}
		#if spine4
		var skeletonData:SkeletonData = getSpriteSkeletonManager().readSkeletonData(new JsonDynamic(haxe.Json.parse(data)));
		#else
		var skeletonData:SkeletonData = getSpriteSkeletonManager().readSkeletonData(new SkeletonDataFileHandle(null, data));
		#end
		_skeletonData.set(id, skeletonData);
		return skeletonData;
	}

	/**
	 * 获取
	 * @param data 
	 * @return Int
	 */
	public function getSkeletonDataID(data:SkeletonData):String {
		var datas:Iterator<String> = _skeletonData.keys();
		while (datas.hasNext()) {
			var key:String = datas.next();
			var skeletonData:SkeletonData = _skeletonData.get(key);
			if (skeletonData == data)
				return key;
		}
		return null;
	}

	/**
	 * 生成CPUSprite使用的骨骼动画
	 * @return spine.openfl.SkeletonAnimation
	 */
	public function buildSpriteSkeleton(id:String, data:String):Spine {
		var skeletonData:SkeletonData = buildSpriteSkeletonData(id, data);
		var skeleton:Spine = new Spine(skeletonData);
		return skeleton;
	}

	/**
	 * 卸载
	 */
	public function dispose():Void {
		// var keys:Iterator<String> = this._bitmapDatas.keys();
		// for (key in keys) {
		// 	this._images.get(key).dispose();
		// 	this._bitmapDatas.remove(key);
		// }
		// var datas:Iterator<String> = this._skeletonData.keys();
		// for (key in datas) {
		// 	this._skeletonData.remove(key);
		// }
		this._skeletonData = null;
		this._images = null;
	}
}

@:keep
class ImageTextureLoader implements TextureLoader {
	private var _images:Map<String, Image>;

	private var _regions:Map<String, AtlasRegion> = [];

	public function new(images:Map<String, Image>) {
		this._images = images;
	}

	public function loadPage(page:AtlasPage, path:String):Void {
		var bitmapData:Image = this._images.get(StringUtils.getName(path));
		if (bitmapData == null)
			throw("BitmapData not found with name: " + path);
		page.rendererObject = bitmapData.toTile();
		// page.width = bitmapData.width;
		// page.height = bitmapData.height;
	}

	public function getRegionByName(name:String):AtlasRegion {
		return _regions.get(name);
	}

	public function loadRegion(region:AtlasRegion):Void {
		_regions.set(region.name, region);
		#if !spine4
		if (region.offsetX == 0 && region.offsetY == 0)
			return;
		if (region.rotate) {
			var v1:Int = region.width;
			region.width = region.height;
			region.height = v1;

			v1 = region.originalHeight;
			region.originalHeight = region.originalWidth;
			region.originalWidth = v1;

			v1 = region.packedHeight;
			region.packedHeight = region.packedWidth;
			region.packedWidth = v1;
		}
		if (region.originalWidth == region.packedWidth
			&& region.originalHeight == region.packedHeight
			|| (region.width < region.packedWidth && region.height < region.packedHeight)) {
			if (region.width < region.originalWidth) {
				region.packedWidth = region.width;
			}
			if (region.height < region.originalHeight) {
				region.packedHeight = region.height;
			}
		} else {
			if (region.height < region.originalWidth) {
				region.packedWidth = region.height;
			}
			if (region.width < region.originalHeight) {
				region.packedHeight = region.width;
			}
		}
		#end
	}

	public function unloadPage(page:AtlasPage):Void {
		page.rendererObject.dispose();
	}
}

class SkeletonDataFileHandle implements spine.support.files.FileHandle {
	public var path:String = "";

	private var _data:String;

	public function new(path:String, data:String = null) {
		this.path = path;
		if (this.path == null)
			this.path = "";
		_data = data;
		if (_data == null)
			throw "Error data:" + path;
	}

	public function getContent():String {
		return _data;
	}
}
