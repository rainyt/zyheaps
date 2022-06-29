package zygame.core;

import h2d.Scene.ScaleMode;
import zygame.utils.ScaleUtils;
import hxd.App;

/**
 * 启动类
 */
class Start extends App {
	public static var current:Start;

	/**
	 * 初始化入口
	 * @param c 
	 */
	public static function initApp(c:Class<Dynamic>, hdwidth:Float, hdheight:Float, debug:Bool = false):Void {
		#if android
		// 先不要那么着急初始化
		#elseif wechat
		untyped window.start = function() {
			current = Type.createInstance(c, [hdwidth, hdheight, debug]);
		}
		#else
		current = Type.createInstance(c, [hdwidth, hdheight, debug]);
		#end
	}

	private var _hdsize = {
		width: 0,
		height: 0
	}

	/**
	 * 构造一个启动类
	 * @param width 适配宽度
	 * @param height 适配高度
	 * @param debug 是否开启调试信息
	 */
	public function new(width:Int = 1920, height:Int = 1080, debug:Bool = false) {
		super();
		_hdsize.width = width;
		_hdsize.height = height;
	}

	override function init() {
		super.init();
		this.onResize();
	}

	override function onResize() {
		super.onResize();
		trace("stage size:", this.s2d.width, this.s2d.height);
		__currentScale = ScaleUtils.mathScale(this.s2d.width, this.s2d.height, _hdsize.width, _hdsize.height);
		this.s2d.setScale(__currentScale);
		this.__stateSize.width = Math.round(s2d.width / __currentScale);
		this.__stateSize.height = Math.round(s2d.height / __currentScale);
		trace("changed scale:", __currentScale, "size:", this.stageWidth, this.stageHeight);
	}

	/**
	 * 当前缩放比例
	 */
	public var currentScale(get, never):Float;

	private var __currentScale:Float = 0;

	private var __stateSize = {
		width: 0.,
		height: 0.
	}

	function get_currentScale() {
		return __currentScale;
	}

	/**
	 * 获取舞台宽度
	 */
	public var stageWidth(get, never):Float;

	function get_stageWidth():Float {
		return __stateSize.width;
	}

	/**
	 * 获取舞台高度
	 */
	public var stageHeight(get, never):Float;

	function get_stageHeight():Float {
		return __stateSize.height;
	}
}
