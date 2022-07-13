package zygame.display.base;

function layoutIDisplayObject(display:IDisplayObject):Void {}

interface IDisplayObject {
	public var dirt:Bool;

	public var stageWidth(get, never):Float;

	public var stageHeight(get, never):Float;

	/**
	 * 宽度
	 */
	public var width(default, set):Null<Float>;

	/**
	 * 高度
	 */
	public var height(default, set):Null<Float>;

	/**
	 * 距离左边
	 */
	public var left:Null<Float>;

	/**
	 * 距离右边
	 */
	public var right:Null<Float>;

	/**
	 * 距离顶部
	 */
	public var top:Null<Float>;

	/**
	 * 距离底部
	 */
	public var bottom:Null<Float>;

	/**
	 * 居中X
	 */
	public var centerX:Null<Float>;

	/**
	 * 居中Y
	 */
	public var centerY:Null<Float>;

	/**
	 * 布局自身
	 */
	public function layout():Void;
}
