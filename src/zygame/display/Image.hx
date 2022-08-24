package zygame.display;

import zygame.layout.ILayout;
import zygame.utils.SceneManager;
import zygame.res.AssetsBuilder;
import h2d.Object;
import hxd.clipper.Rect;
import h2d.ScaleGrid;
import h2d.RenderContext;
import h2d.Tile;
import zygame.core.Start;
import zygame.display.base.IDisplayObject;
import h2d.Bitmap;

/**
 * 图片显示对象
 */
class Image extends Bitmap implements IDisplayObject {
	/**
	 * 是否有变更，当存在变更时，draw接口会对该图形进行重绘
	 */
	public var dirt:Bool = false;

	private var __scaleGrid:ScaleGrid;

	private var __scale9Grid:Rect;

	private var __setWidth:Bool = false;

	private var __setHeight:Bool = false;

	/**
	 * 设置九宫格数据
	 */
	public var scale9Grid(get, set):Rect;

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

	public var layout:ILayout;

	/**
	 * 布局自身
	 */
	public function updateLayout():Void {
		layoutIDisplayObject(this);
	}

	override function addChildAt(s:Object, pos:Int) {
		@:privateAccess SceneManager.setDirt();
		super.addChildAt(s, pos);
	}

	/**
	 * 构造一个图片显示对象
	 * @param tile 
	 * @param parent 
	 */
	public function new(?tile:Dynamic, ?parent:Object) {
		if (tile is String) {
			tile = AssetsBuilder.getBitmapDataTile(tile);
		}
		super(tile, parent);
		if (tile is Tile) {
			this.width = tile.width;
			this.height = tile.height;
		}
		onInit();
	}

	public function onInit():Void {}

	function get_scale9Grid():Rect {
		return __scale9Grid;
	}

	function set_scale9Grid(scale9Grid:Rect):Rect {
		__scale9Grid = scale9Grid;
		dirt = true;
		return scale9Grid;
	}

	public function get_stageWidth():Float {
		return Start.current.stageWidth;
	}

	public var stageWidth(get, never):Float;

	public function get_stageHeight():Float {
		return Start.current.stageHeight;
	}

	public var stageHeight(get, never):Float;

	override function set_tile(t:Tile):Tile {
		this.dirt = true;
		return super.set_tile(t);
	}

	override function set_width(w:Null<Float>):Null<Float> {
		dirt = true;
		this.__setWidth = true;
		return super.set_width(w);
	}

	override function set_height(h:Null<Float>):Null<Float> {
		dirt = true;
		this.__setHeight = true;
		return super.set_height(h);
	}

	override function draw(ctx:RenderContext) {
		if (dirt) {
			if (tile != null) {
				// 九宫格兼容
				if (__scale9Grid != null) {
					if (this.__scaleGrid == null) {
						this.__scaleGrid = new ScaleGrid(tile, __scale9Grid.left, __scale9Grid.top, __scale9Grid.right, __scale9Grid.bottom);
						this.addChildAt(__scaleGrid, 0);
					}
					__scaleGrid.width = this.width;
					__scaleGrid.height = this.height;
				} else {
					if (this.__scaleGrid != null) {
						this.__scaleGrid.tile = null;
						this.__scaleGrid.remove();
					}
					if (!__setWidth)
						this.width = tile.width;
					if (!__setHeight)
						this.height = tile.height;
				}
			}
		}
		super.draw(ctx);
		this.dirt = false;
	}

	/**
	 * 当处于存在九宫格数据时，则不会将当前对象tile上传到渲染缓存数据中
	 * @param ctx 
	 * @param tile 
	 */
	override function emitTile(ctx:RenderContext, tile:Tile) {
		if (__scale9Grid == null)
			super.emitTile(ctx, tile);
	}

	public var ids:Map<String, Object>;

	public function get<T:Object>(id:String, c:Class<T>):T {
		if (ids != null)
			return cast ids.get(id);
		return null;
	}

	public var contentWidth(get, null):Float;

	public function get_contentWidth():Float {
		return getWidth(this);
	}

	public var contentHeight(get, null):Float;

	public function get_contentHeight():Float {
		return getHeight(this);
	}
}
