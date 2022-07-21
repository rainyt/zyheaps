package zygame.display;

import zygame.display.base.BaseGraphics;

/**
 * 图形绘制
 */
class Graphics extends BaseGraphics {
	/**
	 * 绘制三角形
	 * @param vertices 顶点坐标
	 * @param indices 顶点顺序
	 * @param uvtData UV数据
	 */
	public function drawTriangles(vertices:Array<Float>, indices:Array<Int> = null, uvtData:Array<Float> = null, alphas:Array<Float> = null):Void {
		var counts:Int = indices.length;
		trace(color.r, color.g, color.b);
		for (i in 0...counts) {
			var pos = indices[i];
			var index = pos * 2;
			this.addVertex(vertices[index], vertices[index + 1], curR, curG, curB, alphas == null ? 1 : alphas[pos], uvtData == null ? 0 : uvtData[index],
				uvtData == null ? 0 : uvtData[index + 1]);
		}
	}
}
