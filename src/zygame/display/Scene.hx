package zygame.display;

import h2d.RenderContext;
import zygame.utils.SceneManager;
import h2d.Object;

/**
 * 场景
 */
class Scene extends Box {
	public function new(?parent:Object) {
		super(parent);
		this.width = stageWidth;
		this.height = stageHeight;
		this.dirt = true;
	}

	/**
	 * 更换场景
	 * @param cName 
	 * @param isReleaseScene 
	 * @return Scene
	 */
	public function replaceScene<T:Scene>(cName:Class<T>, isReleaseScene:Bool = false):Scene {
		return SceneManager.replaceScene(cName, isReleaseScene);
	}

	/**
	 * 当舞台发生了尺寸变化时，会触发此事件
	 */
	public function onResize():Void {
		this.dirt = true;
	}

	/**
	 * 当场景被释放时
	 */
	public function onRelease():Void {}

	/**
	 * 释放当前场景
	 */
	public function releaseScene():Void {
		SceneManager.releaseScene(this);
	}

	override function onAdd() {
		super.onAdd();
	}

	override function addChildAt(s:Object, pos:Int) {
		this.dirt = true;
		super.addChildAt(s, pos);
	}

	override function draw(ctx:RenderContext) {
		if (this.dirt) {
			this.layout();
		}
		super.draw(ctx);
	}

	override function layout() {
		this.width = stageWidth;
		this.height = stageHeight;
		super.layout();
	}
}
