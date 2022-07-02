package zygame.display;

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
class ImageBitmap extends Bitmap implements IDisplayObject {
	public var dirt:Bool = false;

	private var __scaleGrid:ScaleGrid;

	private var __scale9Grid:Rect;

	private var __setWidth:Bool = false;

	private var __setHeight:Bool = false;

	public var scale9Grid(get, set):Rect;

	public function new(?tile:Dynamic, ?parent:Object) {
		if (tile is String) {
			tile = AssetsBuilder.getBitmapDataTile(tile);
		}
		super(tile, parent);
		if (tile is Tile) {
			this.width = tile.width;
			this.height = tile.height;
		}
	}

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
						this.__scaleGrid = new ScaleGrid(tile, __scale9Grid.left, __scale9Grid.top, __scale9Grid.right, __scale9Grid.bottom, this);
					}
					__scaleGrid.width = this.width;
					__scaleGrid.height = this.height;
				} else {
					trace("移除九宫格");
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

	override function emitTile(ctx:RenderContext, tile:Tile) {
		if (__scale9Grid == null)
			super.emitTile(ctx, tile);
	}
}
