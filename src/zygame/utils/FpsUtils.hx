package zygame.utils;

import haxe.Timer;

class FpsUtils {
	public var fps(default, set):Int;

	private function set_fps(v:Int):Int {
		_fpsTime = 1 / v;
		this.fps = v;
		return v;
	}

	private var _fpsTime:Float = 0;

	private var _fpsMath:Float = 0;

	private var _fpsStamp:Float = Timer.stamp();

	private var _time:Float = Timer.stamp();

	public function new(fps:Int) {
		_fpsTime = 1 / fps;
	}

	public function update():Bool {
		var now = Timer.stamp();
		_fpsMath += now - _fpsStamp;
		_fpsStamp = now;
		if (_fpsMath > _fpsTime) {
			_fpsMath %= _fpsTime;
			// _fpsMath = 0;
			return true;
		}
		return false;
	}
}
