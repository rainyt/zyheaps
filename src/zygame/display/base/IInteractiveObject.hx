package zygame.display.base;

import h2d.Interactive;

interface IInteractiveObject extends IDisplayObject {
	public var enableInteractive(default, set):Bool;

	/**
	 * 交互器
	 */
	public var interactive:Interactive;
}
