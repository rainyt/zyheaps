package platform;

import lime.tools.HTML5Helper;
import hxp.PlatformTools;
import hxp.System;

/** HTML5目标 **/
class Html5 extends BasePlatform {
	public function new() {
		super("html5");
	}

	override function onBuild() {
		super.onBuild();
		// 编译成HTML5目标
		var hxml = initHxml();
		hxml.build();
	}

	override function onBuilded() {
		super.onBuilded();
		if (Sys.args().indexOf("-final") != -1) {
			// 压缩JS
			HTML5Helper.minify(project, getJsSaveFilePath());
		}
	}

	public function getJsSaveFilePath():String {
		return project.app.path + "/" + platform + "/" + project.app.file + ".js";
	}

	override function initHxml() {
		var hxml = super.initHxml();
		hxml.js = getJsSaveFilePath();
		return hxml;
	}

	override function onTest() {
		PlatformTools.launchWebServer(project.app.path + "/html5", 8888);
	}
}
