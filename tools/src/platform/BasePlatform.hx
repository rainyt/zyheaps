package platform;

import lime.tools.ProjectHelper;
import lime.tools.AssetHelper;
import hxp.Log;
import lime.tools.ProjectXMLParser;
import hxp.HXML;

class BasePlatform {
	public var project:ProjectXMLParser;

	public var platform:String;

	public function new(platform:String) {
		this.platform = platform;
		Log.info("parser xml " + Tools.projectDirPath + "zyheaps.xml");
		project = new ProjectXMLParser(Tools.projectDirPath + "zyheaps.xml");
	}

	/**
		拷贝资源
	**/
	public function onCopyAssets():Void {
		for (asset in project.assets) {
			AssetHelper.copyAsset(asset, project.app.path + "/" + platform + "/" + asset.targetPath);
		}
	}

	/** 开始构造 **/
	public function onBuild():Void {
		ProjectHelper.recursiveSmartCopyTemplate(project, platform, project.app.path + "/" + platform, project.templateContext);
		this.onCopyAssets();
	}

	/** 初始化HXML **/
	public function initHxml():HXML {
		var hxml = new HXML();
		hxml.main = project.app.main;
		for (s in project.sources) {
			hxml.cp(s);
		}
		for (haxelib in project.haxelibs) {
			hxml.lib(haxelib.name, (haxelib.version != null && haxelib.version != "") ? haxelib.version : null);
		}
		if (Sys.args().indexOf("-final") == -1)
			hxml.debug = true;
		hxml.define(platform);
		// for (key => value in project.defines) {
		// 	hxml.define(key, value);
		// }
		Log.info(hxml);
		return hxml;
	}

	/** 构造结束 **/
	public function onBuilded():Void {}

	/** 启动测试 **/
	public function onTest():Void {
		Log.warn("This platform test is unavailable.");
	}
}
