package zygame.utils;

import haxe.io.Bytes;
import haxe.crypto.Base64;
import haxe.macro.Compiler;
import zygame.core.Start;
#if html5
import js.Browser;
#end
import haxe.crypto.Md5;
import zygame.utils.TimeRuntime;

/**
 * 实用库
 */
@:keep
class Lib {
	private static var _timeRuntimes:Map<String, TimeRuntime> = new Map();

	/**
	 * 每帧发生处理，由Start执行
	 */
	public static function onFrame():Void {
		for (runtime in _timeRuntimes) {
			runtime.onFrame();
		}
	}

	/**
	 * 当活动恢复时触发
	 */
	public static function onResume():Void {
		for (runtime in _timeRuntimes) {
			runtime.onResume();
		}
	}

	/**
	 * 是否存在渲染事件
	 * @return Bool
	 */
	public static function hasRenderEvent():Bool {
		for (runtime in _timeRuntimes) {
			if (runtime.hasRenderEvent())
				return true;
		}
		return false;
	}

	/**
	 * 当渲染时触发
	 */
	public static function onRender():Void {
		for (runtime in _timeRuntimes) {
			runtime.onRender();
		}
	}

	/**
	 * 获取时间运行器
	 * @param tag
	 * @return TimeRuntime
	 */
	public static function getTimeRuntime(tag:String = "defalut"):TimeRuntime {
		var runtime = _timeRuntimes[tag];
		if (runtime == null) {
			runtime = new TimeRuntime();
			_timeRuntimes.set(tag, runtime);
		}
		return runtime;
	}

	/**
	 * 清空所有计时器运行器
	 */
	public static function clearAllTimeRuntime():Void {
		for (runtime in _timeRuntimes) {
			runtime.clear();
		}
	}

	/**
	 * 清理某个指定的计时器
	 * @param tag
	 */
	public static function clearTimeRuntime(tag:String = "defalut"):Void {
		getTimeRuntime(tag).clear();
	}

	/**
	 * 下一帧调用
	 * @param closure
	 * @param delay
	 * @param args
	 * @return Int
	 */
	public static function nextFrameCall(closure:Dynamic, args:Array<Dynamic> = null, runtimeTag:String = "defalut"):Int {
		return getTimeRuntime(runtimeTag).setTimeout(closure, 0, args);
	}

	/**
	 * 处理了自动释放处理
	 * @param closure
	 * @param delay
	 * @param args
	 * @return Int
	 */
	public static function setTimeout(closure:Dynamic, delay:Int, args:Array<Dynamic> = null, runtimeTag:String = "defalut"):Int {
		return getTimeRuntime(runtimeTag).setTimeout(closure, delay, args);
	}

	/**
	 * 清理计时器
	 * @param id
	 */
	public static function clearTimeout(id:Int, runtimeTag:String = "defalut"):Void {
		getTimeRuntime(runtimeTag).clearTimeout(id);
	}

	/**
	 * 设置循环事件
	 * @param closure
	 * @param delay
	 * @param args
	 * @return Int
	 */
	public static function setInterval(closure:Dynamic, delay:Int = 0, args:Array<Dynamic> = null, runtimeTag:String = "defalut"):Int {
		return getTimeRuntime(runtimeTag).setInterval(closure, delay, args);
	}

	/**
	 * 重置计时器，重新计算
	 * @param id
	 */
	public static function resetInterval(id:Int, runtimeTag:String = "defalut"):Void {
		getTimeRuntime(runtimeTag).resetInterval(id);
	}

	/**
	 * 清理计时器
	 * @param id
	 */
	public static function clearInterval(id:Int, runtimeTag:String = "defalut"):Void {
		getTimeRuntime(runtimeTag).clearInterval(id);
	}

	/**
	 * 当活动恢复时，进行调用
	 * 请注意，从2021年9月29日开始，该接口需要恢复触发才会进行刷新。如果需要安全线程的恢复接口，请使用renderCall。
	 * @param closure
	 * @param delay
	 * @param args
	 * @return Int
	 */
	public static function resumeCall(closure:Dynamic, args:Array<Dynamic> = null, runtimeTag:String = "defalut"):Int {
		return getTimeRuntime(runtimeTag).resumeCall(closure, args);
	}

	/**
	 * 当渲染时进行调用
	 * @param closure
	 * @param args
	 * @param runtimeTag
	 * @return Int
	 */
	public static function renderCall(closure:Dynamic, args:Array<Dynamic> = null, runtimeTag:String = "defalut"):Int {
		return getTimeRuntime(runtimeTag).renderCall(closure, args);
	}

	/**
	 * 判断是否为base64
	 * @param str
	 * @return Bool
	 */
	public static function isBase64(str:String):Bool {
		var req = new EReg("^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$", "g");
		return req.match(str);
	}

	/**
	 * 获取渠道名
	 */
	public static function getChannel():String {
		#if g4399
		return "g4399";
		#elseif bili
		return "bilibili";
		#elseif ios
		return "appstore";
		#elseif huawei
		return "huawei";
		#elseif qihoo
		return "qihoo";
		#elseif meizu
		return "meizu";
		#elseif mgc
		return "mgc";
		#elseif (qq || qqquick)
		return "qq";
		#elseif baidu
		return "baidu";
		#elseif tt
		return "tt";
		#elseif weixin
		return "wechat";
		#elseif oppo
		return "oppo";
		#elseif vivo
		return "vivo";
		#elseif (android && kengsdk)
		return KengSDK.globalChannel();
		#else
		var channel = Compiler.getDefine("channel");
		if (channel == null)
			channel = "default";
		return channel;
		#end
	}

	/**
	 * 判断环境是否为电脑
	 * @return Bool
	 */
	public static function isPc():Bool {
		#if (android || ios)
		return false;
		#elseif html5
		var userAgent = Browser.navigator.userAgent;
		var Agents = [
			  "Android",        "iPhone",
			"SymbianOS", "Windows Phone",
			     "iPad",          "iPod"
		];
		for (tag in Agents) {
			if (userAgent.indexOf(tag) != -1)
				return false;
		}
		return true;
		#else
		return true;
		#end
	}

	/**
	 * 根据两点坐标获取弧度
	 * @param x1
	 * @param y1
	 * @param x2
	 * @param y2
	 * @return Float
	 */
	public static function getRadianByPos(x1:Float, y1:Float, x2:Float, y2:Float):Float {
		var radian:Float = Math.atan2((y2 - y1), (x2 - x1)); // 弧度
		return radian;
	}

	/**
	 * 获取角度
	 * @param x1 
	 * @param y1 
	 * @param x2 
	 * @param y2 
	 * @return Float
	 */
	public static function getAngleByPos(x1:Float, y1:Float, x2:Float, y2:Float):Float {
		return radianToAngle(getRadianByPos(x1, y1, x2, y2));
	}

	/**
	 * 角度转弧度
	 * @param angle
	 * @return Float
	 */
	public static function angleToRadian(angle:Float):Float {
		return angle * (Math.PI / 180);
	}

	/**
	 * 弧度转角度
	 * @param radian
	 * @return Float
	 */
	public static function radianToAngle(radian:Float):Float {
		return radian * (180 / Math.PI);
	}

	/**
	 * 可用于ZHaxe中解析浮点为整数
	 * @param num
	 * @return Int
	 */
	public static function int(num:Float):Int {
		return Std.int(num);
	}

	/**
	 * 获取运行平台名称，如IOS、Android等，如果无法识别，则会返回null
	 * @return String 
	 */
	public static function getPlatformName():String {
		#if wechat
		return untyped window.platform;
		#else
		return null;
		#end
	}
}
