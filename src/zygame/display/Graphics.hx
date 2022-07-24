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
	public function drawTriangles(vertices:Array<Float>, indices:Array<Int> = null, uvtData:Array<Float> = null, r:Null<Float> = null, g:Null<Float> = null,
			b:Null<Float> = null, a:Null<Float> = 1):Void {
		this.flush();
		var counts:Int = indices.length;
		var v = 0;
		r = r == null ? curR : r;
		g = g == null ? curG : g;
		b = b == null ? curB : b;
		for (i in 0...counts) {
			var pos = indices[i];
			var index = pos * 2;
			this.addVertex(vertices[index], vertices[index + 1], r, g, b, a, uvtData == null ? 0 : uvtData[index], uvtData == null ? 0 : uvtData[index + 1]);
			v++;
			if (v == 3) {
				this.flush();
				v = 0;
			}
		}
	}
}
