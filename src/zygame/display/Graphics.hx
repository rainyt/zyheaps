package zygame.display;

import zygame.display.base.BaseGraphics;

/**
 * 图形绘制
 */
class Graphics extends BaseGraphics {
	// private var _index = 0;
	override function clear() {
		super.clear();
	}

	/**
	 * 绘制三角形
	 * @param vertices 顶点坐标
	 * @param indices 顶点顺序
	 * @param uvtData UV数据
	 */
	public function drawTriangles(vertices:Array<Float>, indices:Array<Int> = null, uvtData:Array<Float> = null, alphas:Array<Float> = null):Void {
		this.flush();
		var counts:Int = indices.length;
		var v = 0;
		for (i in 0...counts) {
			var pos = indices[i];
			var index = pos * 2;
			this.addVertex(vertices[index], vertices[index + 1], curR, curG, curB, alphas == null ? 1 : alphas[pos], uvtData == null ? 0 : uvtData[index],
				uvtData == null ? 0 : uvtData[index + 1]);
			v++;
			if (v == 3) {
				this.flush();
				v = 0;
			}
		}
	}
}
