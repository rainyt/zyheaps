package zygame.res;

import zygame.utils.Assets;
import h2d.Tile;

/**
 * 资源管理器
 */
class AssetsBuilder {
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
			if (assets.hasTypeAssets(BITMAP, id)) {
				return assets.getBitmapDataTile(id);
			}
		}
		return null;
	}
}
