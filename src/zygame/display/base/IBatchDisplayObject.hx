package zygame.display.base;

import zygame.display.batch.BObject;

interface IBatchDisplayObject {
	public var dirt:Bool;

	public var stageWidth(get, never):Float;

	public var stageHeight(get, never):Float;

	/**
	 * The parent object in the scene tree.
	 */
	public var parent(default, null):BObject;

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
	 * 角度
	 */
	public var rotation(default, set):Null<Float>;

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
	 * 布局自身
	 */
	public function layout():Void;

	/**
	 * 初始化入口
	 */
	public function onInit():Void;

	// /**
	//  * 映射ID
	//  */
	// public var ids:Map<String, Object>;
	// /**
	//  * 获取对应ID的组件
	//  * @param id
	//  * @param T
	//  * @return T
	//  */
	// public function get<T:Object>(id:String, c:Class<T>):T;
}
