package platform;

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

	override function initHxml() {
		var hxml = super.initHxml();
		hxml.js = project.app.path + "/" + platform + "/" + project.app.file + ".js";
		return hxml;
	}

	override function onTest() {
		PlatformTools.launchWebServer(project.app.path + "/html5", 8888);
	}
}