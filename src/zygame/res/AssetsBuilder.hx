package zygame.res;

import haxe.io.Bytes;
import hxd.res.Atlas;
import zygame.utils.Assets;
import h2d.Tile;

/**
 * 资源管理器，通过`AssetsBuilder.bindAssets`绑定的资源，可以通过`AssetsBuilder`进行全局获取，例如`AssetsBuilder.getBitmapDataTile("id")`
 */
class AssetsBuilder {
	/**
	 * UI构造器
	 */
	public static var builder:Builder<Dynamic> = new XMLBuilder();

	/**
	 * 资源列表
	 */
	private static var assetsList:Array<Assets> = [];

	/**
	 * 绑定资源
	 * @param assets 
	 */
	public static function bindAssets(assets:Assets):Void {
		assetsList.push(assets);
	}

	/**
	 * 解除绑定资源
	 * @param assets 
	 */
	public static function unbindAssets(assets:Assets):Void {
		assetsList.remove(assets);
	}

	/**
	 * 获取Tile纹理数据
	 * @param id 
	 * @return Tile
	 */
	public static function getBitmapDataTile(id:String):Tile {
		for (assets in assetsList) {
			var tile = assets.getBitmapDataTile(id);
			if (tile != null)
				return tile;
		}
		return null;
	}

	/**
	 * 获取Bytes二进制数据
	 * @param id 
	 * @return Bytes
	 */
	public static function getBytes(id:String):Bytes{
		for (assets in assetsList) {
			var b = assets.getBytes(id);
			if (b != null)
				return b;
		}
		return null;
	}

	/**
	 * 获取精灵图
	 * @param id 
	 * @return Atlas
	 */
	public static function getAtlas(id:String):Atlas {
		for (assets in assetsList) {
			var atlas = assets.getAtlas(id);
			if (atlas != null)
				return atlas;
		}
		return null;
	}

	/**
	 * 获取XML数据
	 * @param id 
	 * @return Xml
	 */
	public static function getXml(id:String):Xml {
		for (assets in assetsList) {
			if (assets.hasTypeAssets(XML, id)) {
				return assets.getXml(id);
			}
		}
		return null;
	}
}
