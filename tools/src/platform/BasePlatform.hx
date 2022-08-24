package platform;

import utils.AssetHelperExt;
import sys.io.File;
import project.ProjectHXMLParser;
import lime.tools.HXProject;
import sys.FileSystem;
import lime.tools.ProjectHelper;
import lime.tools.AssetHelper;
import hxp.Log;
import lime.tools.ProjectXMLParser;
import hxp.HXML;

class BasePlatform {
	public var project:HXProject;

	public var platform:String;

	public var hxml:HXML;

	public function new(platform:String) {
		this.platform = platform;
		if (FileSystem.exists(Tools.projectDirPath + "zyheaps.xml")) {
			project = new ProjectXMLParser(Tools.projectDirPath + "zyheaps.xml");
		} else if (FileSystem.exists(Tools.projectDirPath + "zyheaps.hxml")) {
			// 将HXML配置解析为xml读取
			project = new ProjectHXMLParser(Tools.projectDirPath + "zyheaps.hxml");
		} else
			throw "You need file zyheaps.xml or zyheaps.hxml.";
	}

	/**
		拷贝资源
	**/
	public function onCopyAssets():Void {
		for (asset in project.assets) {
			AssetHelperExt.copyAsset(asset, project.app.path + "/" + platform + "/" + asset.targetPath);
		}
	}

	/** 开始构造 **/
	public function onBuild():Void {
		ProjectHelper.recursiveSmartCopyTemplate(project, platform, project.app.path + "/" + platform, project.templateContext);
		this.onCopyAssets();
		var args = Sys.args();
		Sys.setCwd(args[args.length - 1]);
	}

	/** 初始化HXML **/
	public function initHxml():HXML {
		if (hxml == null)
			hxml = new HXML();
		hxml.main = project.app.main;
		for (s in project.haxeflags) {
			// hxml.addMacro("keep(\"h2d.Object\")");
			// hxml.addMacro("\"keep('IntIterator')\"");
			// if (s.indexOf("--macro") != -1)
			hxml.addMacro("\"" + s.substr(s.indexOf(" ") + 1) + "\"");
		}
		for (s in project.sources) {
			hxml.cp(s);
		}
		for (haxelib in project.haxelibs) {
			hxml.lib(haxelib.name, (haxelib.version != null && haxelib.version != "") ? haxelib.version : null);
		}
		if (Sys.args().indexOf("-debug") != -1)
			hxml.debug = true;
		hxml.define(platform);
		for (key => value in project.defines) {
			if (key == "cpp" || key == "mac")
				continue;
			if (value != null && value.indexOf(" ") != -1) {
				hxml.define(key, '"${value}"');
			} else
				hxml.define(key, '${value}');
		}
		return hxml;
	}

	/** 构造结束 **/
	public function onBuilded():Void {
		trace("build hxml:" + hxml);
		trace("BUILD SUCCESS");
	}

	/** 启动测试 **/
	public function onTest():Void {
		Log.warn("This platform test is unavailable.");
	}
}
