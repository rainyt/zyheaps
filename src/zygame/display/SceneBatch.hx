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

	private function renderObject(object:BObject):Void {
		@:privateAccess object.__update();
		var isTransform = object.interactive != null || object is BImage;
		if (isTransform) {
			var m = @:privateAccess object.__worldTransform;
			var radians = Math.atan2(m.d, m.c);
			var scale = m.getScale();
			var __rotation = radians - 3.14 * 0.5;

			if (object.interactive != null) {
				// 渲染交互器
				this.addChild(object.interactive);
				object.interactive.x = m.x;
				object.interactive.y = m.y;
				object.interactive.rotation = __rotation;
				object.interactive.scaleX = scale.x;
				object.interactive.scaleY = scale.y * (scale.x < 0 ? -1 : 1);
				object.interactive.width = object.width;
				object.interactive.height = object.height;

				// var q = new Quad(100, 100, 0xff0000, this);
				// q.x = m.x;
				// q.y = m.y;
			}

			if (object is BImage) {
				var img:BImage = cast object;
				var basic = @:privateAccess img._basic;
				if (basic.t != null) {
					basic.x = m.x;
					basic.y = m.y;
					basic.rotation = __rotation;
					basic.scaleX = scale.x;
					basic.scaleY = scale.y * (scale.x < 0 ? -1 : 1);
					_batch.add(basic);
				}
			}
		}
		for (child in object.children) {
			renderObject(child);
		}
	}

	override function draw(ctx:RenderContext) {
		// 渲染_batch
		if (true) {
			// this.removeChildren();
			this.addChild(_batch);
			_batch.clear();
			renderObject(group);
		}
		super.draw(ctx);
	}
}
