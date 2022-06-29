package platform;

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
		hxml.js = project.app.path + "/html5/" + project.app.file + ".js";
		return hxml;
	}
}
