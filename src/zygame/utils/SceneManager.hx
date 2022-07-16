package zygame.utils;

import zygame.core.Start;
import zygame.display.Scene;

/**
 * 场景管理器
 */
class SceneManager {
	/**
	 * 已生成的场景列表
	 */
	private static var _scenes:Array<Scene> = [];

	/**
	 * 场景类型映射关系
	 */
	private static var _sceneMap:Map<String, Scene> = [];

	/**
	 * 当前显示的场景
	 */
	public static var currentScene:Scene;

	/**
	 * 创建一个场景
	 * @param cName 
	 * @return Scene
	 */
	private static function createScene<T:Scene>(cName:Class<T>):T {
		var name = Type.getClassName(cName);
		if (_sceneMap.exists(name)) {
			return cast _sceneMap.get(name);
		}
		var scene = Type.createInstance(cName, []);
		_sceneMap.set(name, scene);
		return scene;
	}

	/**
	 * 更换场景
	 * @param cName 
	 * @param isReleaseScene 
	 * @return Scene
	 */
	public static function replaceScene<T:Scene>(cName:Class<T>, isReleaseScene:Bool = false):T {
		if (currentScene != null) {
			if (isReleaseScene)
				releaseScene(currentScene);
			else
				currentScene.remove();
		}
		var scene = createScene(cName);
		currentScene = scene;
		Start.current.s2d.add(scene);
		if (currentScene.width != currentScene.stageWidth || currentScene.height != currentScene.stageHeight)
			currentScene.onResize();
		return scene;
	}

	/**
	 * 释放场景
	 * @param scene 
	 */
	public static function releaseScene(scene:Scene):Void {
		scene.remove();
		scene.onRelease();
		var c = Type.getClass(scene);
		var name = Type.getClassName(c);
		_sceneMap.remove(name);
		_scenes.remove(scene);
	}

	private static function onResize():Void {
		if (currentScene != null)
			currentScene.onResize();
	}

	private static function setDirt():Void {
		if (currentScene != null)
			currentScene.dirt = true;
	}
}
