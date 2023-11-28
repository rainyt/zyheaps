package zygame.loader.parser;

import haxe.io.BytesData;
import haxe.io.Bytes;
import zygame.loader.parser.AssetsType;
import zygame.utils.Assets;

// import zygame.utils.Lib;

/**
 * 基础解析器
 */
@:keep class BaseParser {
	private var _data:Dynamic;

	private var _assets:Assets;

	/**
	 * 当前解析器的进度
	 */
	public var progress:Float = 0;

	public function new(data:Dynamic) {
		_data = data;
	}

	/**
	 * 判断两个加载资源是否一致
	 * @param base 
	 * @return Bool
	 */
	public function equal(base:BaseParser):Bool {
		var isObj = !Std.isOfType(base._data, String);
		var isObj2 = !Std.isOfType(this._data, String);
		if (isObj && isObj2) {
			// 如果都是Obj的情况下，进行判断
			return base._data.path == this._data.path;
		} else if (!isObj2 && !isObj2) {
			// 如果都不是Obj的情况下，直接判断
			return base._data == this._data;
		}
		return false;
	}

	/**
	 * 获取当前资源管理器
	 * @return Dynamic
	 */
	public function getAssets():Assets {
		return _assets;
	}

	/**
	 * 获取待解析数据
	 * @return Dynamic
	 */
	public function getData():Dynamic {
		return _data;
	}

	/**
	 * 设置待解析数据
	 * @param data
	 */
	public function setData(data:Dynamic) {
		_data = data;
	}

	/**
	 * 获取解析名
	 */
	public function getName():String {
		if (_data == null) {
			throw "[" + Type.getClassName(Type.getClass(this)) + "]_data is null";
		}
		if (Std.isOfType(_data, String)) {
			return getAssets() != null ? getAssets().onPasingPathName(_data) : _data;
		} else if (_data.path != null) {
			return getAssets() != null ? getAssets().onPasingPathName(_data.path) : _data.path;
		}
		return null;
	}

	/**
	 * 开始载入该解析
	 * @param call 加载进度成功事件
	 * @param onError 解析/加载发生异常时
	 */
	public function load(assets:Assets):Void {
		_assets = assets;
		this.process();
	}

	/**
	 * 发生错误时汇报
	 * @param msg
	 */
	public function sendError(msg:String):Void {
		error(msg);
	}

	dynamic public function error(msg:String):Void {}

	/**
	 * 已解析完毕，一般由ZAssets调用，不主动调用
	 */
	dynamic public function done():Void {}

	/**
	 * 输出资源
	 * @param type
	 * @param assetsData
	 * @param pro
	 */
	dynamic public function out(parser:BaseParser, type:AssetsType, assetsData:Dynamic, pro:Float):Void {}

	/**
	 * 解析处理，一般由ZAssets调用，不主动调用
	 */
	public function process():Void {}

	/**
	 * 下一个解析处理
	 */
	public function contiune():Void {
		// Lib.nextFrameCall(process, null, "LoaderAssets.ParserBase");
	}

	/**
	 * 将资产最终输出
	 * @param type
	 * @param assetsData
	 * @param pro 解析进度，如果当前解析已结束，请传递1，否则请传递少于1的值。
	 */
	public function finalAssets(type:AssetsType, assetsData:Dynamic, pro:Float = 0):Void {
		#if debug
		trace("finalAssets:", type, pro);
		#end
		this.progress = pro;
		this.out(this, type, assetsData, pro);
		if (pro == 1) {
			this.done();
			this._assets = null;
			this._data = null;
		}
	}
}
