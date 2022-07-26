package zygame.display;

import zygame.display.batch.BImage;
import zygame.display.batch.BObject;
import h2d.RenderContext;
import h2d.SpriteBatch;
import zygame.res.AssetsBuilder;
import h2d.Object;
import zygame.res.XMLAtlas;

/**
 * 批渲染对象
 */
class SceneBatch extends Scene {
	/**
	 * 容器
	 */
	public var group:BObject;

	/**
	 * 批处理对象
	 */
	private var _batch:SpriteBatch;

	/**
	 * 创建一个XML精灵图的批处理对象
	 * @param xmlAtlas 
	 * @param parent 
	 */
	public function new(xmlAtlas:Dynamic, ?parent:Object) {
		var atlas:XMLAtlas = null;
		if (xmlAtlas is String) {
			atlas = cast AssetsBuilder.getAtlas(xmlAtlas);
		} else {
			atlas = xmlAtlas;
		}
		super(parent);
		group = new BObject();
		_batch = new SpriteBatch(atlas.rootTile, this);
		// 默认可旋转和缩放
		_batch.hasRotationScale = true;
		this.width = stageWidth;
		this.height = stageHeight;
	}

	private function renderImage(img:BImage):Void {
		var basic = @:privateAccess img._basic;
		if (basic.t != null) {
			var m = @:privateAccess img.__worldTransform;
			var radians = Math.atan2(m.d, m.c);
			var scale = m.getScale();
			var __rotation = radians;
			basic.x = m.x;
			basic.y = m.y;
			basic.rotation = __rotation;
			basic.scaleX = scale.x;
			basic.scaleY = scale.y;
			_batch.add(basic);
		}
	}

	private function renderObject(object:BObject):Void {
		@:privateAccess object.__update();
		if (object is BImage) {
			renderImage(cast object);
		}
		for (child in object.children) {
			renderObject(child);
		}
	}

	override function draw(ctx:RenderContext) {
		// 渲染_batch
		_batch.clear();
		renderObject(group);
		super.draw(ctx);
	}
}
