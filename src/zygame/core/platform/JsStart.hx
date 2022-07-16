package zygame.core.platform;

import js.html.Event;
import js.html.Window;
import hxd.App;

class JsStart extends App {
	private var currentWindow:Window;

	public function new() {
		super();
		this.currentWindow = untyped window;
		var canvas = this.currentWindow.document.getElementById("webgl");
		canvas.style.setProperty("width", "100%");
		canvas.style.setProperty("height", "100%");
	}

	private function onWindowResize(e:Event):Void {}
}
