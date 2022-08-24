package zygame.display.base;

import zygame.layout.ILayout;

interface IObject {
	/**
	 * The x position (in pixels) of the object relative to its parent.
	 */
	public var x(default, set):Float;

	/**
	 * The y position (in pixels) of the object relative to its parent.
	 */
	public var y(default, set):Float;

	/**
	 * 宽度
	 */
	public var width(default, set):Null<Float>;

	/**
	 * 高度
	 */
	public var height(default, set):Null<Float>;

	/**
		The amount of horizontal scaling of this object.
	**/
	public var scaleX(default, set):Float;

	/**
		The amount of vertical scaling of this object.
	**/
	public var scaleY(default, set):Float;

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
	 * 布局对象
	 */
	public var layout:ILayout;

	/**
	 * 布局自身
	 */
	public function updateLayout():Void;

	/**
	 * 初始化入口
	 */
	public function onInit():Void;

	public var dirt:Bool;

	public var stageWidth(get, never):Float;

	public var stageHeight(get, never):Float;
}
