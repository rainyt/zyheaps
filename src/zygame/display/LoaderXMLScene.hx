package zygame.display;

import zygame.res.AssetsBuilder;
import zygame.utils.StringUtils;
import zygame.res.XMLBuilder;
import zygame.utils.AssetsUtils;
import h2d.Object;
import zygame.utils.Assets;

/**
 * 包含载入器支持的场景
 */
class LoaderXMLScene extends Scene {
	/**
	 * 资源管理器
	 */
	public var assets:Assets;

	/**
	 * 加载的场景配置
	 */
	public var loadPath:String;

	/**
	 * 载入XML配置
	 * @param path 
	 * @param parent 
	 */
	public function new(path:String, ?parent:Object) {
		super(parent);
		loadPath = path;
		assets = new Assets();
		AssetsBuilder.bindAssets(assets);
		_onLoad();
		onLoad();
		loadXml(function(data) {
			assets.start(function(f) {
				if (f == 1) {
					// 开始构造
					XMLBuilder.parserFromId(StringUtils.getName(loadPath), this);
					this.onBuilded();
				}
				onProgress(f);
			});
		});
	}

	/**
	 * 加载XML布局配置文件
	 * @param cb 
	 */
	private function loadXml(cb:Xml->Void):Void {
		var xml = AssetsBuilder.getXml(StringUtils.getName(loadPath));
		if (xml != null) {
			cb(xml);
		} else {
			AssetsUtils.loadBytes(loadPath, function(data) {
				var xml = Xml.parse(data.toString());
				assets.setTypeAssets(XML, StringUtils.getName(loadPath), xml);
				cb(xml);
			}, onError);
		}
	}

	@:noCompletion private function _onLoad():Void {}

	/**
	 * 构造完成
	 */
	public function onBuilded():Void {}

	/**
	 * 触发加载流程时
	 */
	public function onLoad():Void {}

	/**
	 * 载入进度
	 * @param f 
	 */
	public function onProgress(f:Float):Void {}

	/**
	 * 触发加载失败时
	 * @param msg 
	 */
	public function onError(msg):Void {}

	override function onRelease() {
		super.onRelease();
		AssetsBuilder.unbindAssets(assets);
	}
}
