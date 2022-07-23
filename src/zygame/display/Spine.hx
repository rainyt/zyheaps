package zygame.display;

import zygame.utils.FpsUtils;
import haxe.Timer;
import spine.AnimationStateData;
import spine.BlendMode;
import h2d.Tile;
import spine.attachments.MeshAttachment;
import spine.attachments.RegionAttachment;
import spine.attachments.ClippingAttachment;
import spine.support.graphics.TextureAtlas;
import spine.Slot;
import spine.utils.SkeletonClipping;
import spine.Skeleton;
import h2d.RenderContext;
import spine.AnimationState;
import spine.SkeletonData;
import h2d.Object;

/**
 * Spine渲染器
 */
class Spine extends Box {
	/**
	 * 切割器
	 */
	private static var clipper:SkeletonClipping = new SkeletonClipping();

	private static var defalutTriangles:Array<Int> = [0, 1, 2, 2, 3, 0];

	/**
	 * 骨架数据
	 */
	public var skeleton:Skeleton;

	/**
	 * 动画状态
	 */
	public var animationState:AnimationState;

	/**
	 * 时间轴缩放
	 */
	public var timeScale:Float = 1;

	/**
	 * 是否正在播放
	 */
	public var isPlay(get, null):Bool;

	private function get_isPlay():Bool {
		return _isPlay;
	}

	/**
	 * 是否正在播放
	 */
	private var _isPlay:Bool = false;

	/**
	 * 当前播放的动画名称
	 */
	public var actionName(get, null):String;

	private function get_actionName():String {
		return _actionName;
	}

	private var _actionName:String;

	public function new(skeletonData:SkeletonData, stateData:AnimationState = null, ?parent:Object) {
		super();
		this.skeleton = new Skeleton(skeletonData);
		#if (spine_hx <= "3.6.0")
		skeleton.setFlipY(true);
		#else
		skeleton.setScaleY(-1);
		#end
		this.animationState = stateData != null ? stateData : new AnimationState(new AnimationStateData(skeletonData));
		_sprite = new Graphics(this);
	}

	/**
	 * 播放
	 */
	public function play(action:String = null, loop:Bool = true):Void {
		_isPlay = true;
		if (action != _actionName) {
			if (action != null && action != "") {
				this.animationState.setAnimationByName(0, action, loop);
			}
			if (action != null)
				_actionName = action;
			this.advanceTime(0);
		}
	}

	/**
	 * 在updateWorldTransform调用之前发生
	 */
	dynamic public function onUpdateWorldTransformBefore():Void {}

	public function advanceTime(dt:Float) {
		animationState.update(dt / timeScale);
		animationState.apply(skeleton);
		this.onUpdateWorldTransformBefore();
		skeleton.updateWorldTransform();
		this.render();
	}

	/**
	 * 坐标数组
	 */
	private var _tempVerticesArray:Array<Float>;

	/**
	 * 矩形三角形
	 */
	private var _quadTriangles:Array<Int>;

	private var _sprite:Graphics;

	/**
	 * 渲染主逻辑
	 */
	private function render():Void {
		if (this.alpha == 0 || !this.visible)
			return;

		_sprite.clear();
		_sprite.beginFill(0xff0000);

		var clipper:SkeletonClipping = Spine.clipper;
		// 清理遮罩数据
		clipper.clipEnd();

		// 基础变量
		var triangles:Array<Int> = null;
		var uvs:Array<Float> = null;
		var verticesLength:Int = 0;
		var atlasRegion:AtlasRegion;
		var slot:Slot;

		var writeVertices:Array<Float> = null;
		var writeTriangles:Array<Int> = null;

		var bitmapData:Tile = null;

		// 是否开始填充
		var isFill = false;
		var isBitmapBlendMode = false;

		// 骨骼动画
		var drawOrder:Array<Slot> = skeleton.drawOrder;
		for (i in 0...drawOrder.length) {
			// 获取骨骼
			slot = drawOrder[i];
			// 初始化参数
			triangles = null;
			uvs = null;
			atlasRegion = null;
			_tempVerticesArray = [];
			// 如果骨骼的渲染物件存在
			if (slot.attachment != null) {
				// 如果不可见的情况下，则隐藏
				if (slot.color.a == 0)
					continue;
				if (Std.isOfType(slot.attachment, ClippingAttachment)) {
					// 如果是剪切
					var region:ClippingAttachment = cast slot.attachment;
					clipper.clipStart(slot, region);
					continue;
				} else if (Std.isOfType(slot.attachment, RegionAttachment)) {
					// 如果是矩形
					var region:RegionAttachment = cast slot.attachment;
					verticesLength = 8;
					region.computeWorldVertices(slot.bone, _tempVerticesArray, 0, 2);
					uvs = region.getUVs();
					triangles = _quadTriangles;
					atlasRegion = cast region.getRegion();
				} else if (Std.isOfType(slot.attachment, MeshAttachment)) {
					// 如果是网格
					var region:MeshAttachment = cast slot.attachment;
					verticesLength = 8;
					region.computeWorldVertices(slot, 0, region.getWorldVerticesLength(), _tempVerticesArray, 0, 2);
					uvs = region.getUVs();
					triangles = region.getTriangles();
					atlasRegion = cast region.getRegion();
				}
				// 裁剪实现
				if (clipper.isClipping()) {
					clipper.clipTriangles(_tempVerticesArray, _tempVerticesArray.length, triangles, triangles.length, uvs, 1, 1, true);
					if (clipper.getClippedTriangles().length == 0) {
						clipper.clipEndWithSlot(slot);
						continue;
					} else {
						var clippedVertices = clipper.getClippedVertices();
						writeVertices = [];
						uvs = [];
						var i = 0;
						while (true) {
							writeVertices.push(clippedVertices[i]);
							writeVertices.push(clippedVertices[i + 1]);
							uvs.push(clippedVertices[i + 4]);
							uvs.push(clippedVertices[i + 5]);
							i += 6;
							if (i >= clippedVertices.length)
								break;
						}
						writeTriangles = clipper.getClippedTriangles();
					}
				} else {
					writeVertices = _tempVerticesArray;
					writeTriangles = triangles;
				}

				if (bitmapData != atlasRegion.page.rendererObject) {
					bitmapData = atlasRegion.page.rendererObject;
					_sprite.beginTileFill(bitmapData);
				}
				_sprite.drawTriangles(_tempVerticesArray, triangles == null ? defalutTriangles : triangles, uvs);
				// drawGraphics(slot, bitmapData, false);
				clipper.clipEndWithSlot(slot);
			} else if (slot != null && clipper.isClipping()) {
				clipper.clipEndWithSlot(slot);
			}
		}

		_sprite.endFill();
	}

	private function drawGraphics(slot:Slot, bitmapData:Tile, isBlendMode:Bool = false):Void {}

	/**
	 * FPS，默认为60
	 */
	public var fps(get, set):Int;

	private function set_fps(v:Float):Float {
		_fps.fps = v;
		return v;
	}

	private function get_fps():Float {
		return _fps.fps;
	}

	private var _fps:FpsUtils = new FpsUtils(60);
	private var _time:Float = Timer.stamp();

	override function draw(ctx:RenderContext) {
		if (_fps.update()) {
			var now = Timer.stamp();
			advanceTime(now - _time);
			_time = now;
		}
		super.draw(ctx);
	}
}
