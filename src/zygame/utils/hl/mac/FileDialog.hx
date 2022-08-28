package zygame.utils.hl.mac;

import zygame.core.Start;
import zygame.display.Quad;
import haxe.io.Bytes;

#if (mac)
/**
 * 文件管理器
 */
@:noCompletion class FileDialog {
	public static var quad:Quad;

	/**
	 * 打开单个可选目录文件
	 * @param dir 
	 * @param cb 
	 */
	public static function openSelectOneFile(dir:String, cb:FileDialogFile->Void):Void {
		quad = new Quad(Start.current.stageWidth, Start.current.stageHeight, 0x0);
		quad.alpha = 0.8;
		SceneManager.currentScene.addChild(quad);
		NativeTools.open_select_dir();
		FrameEngine.create((f) -> {
			// 轮查
			var obj = NativeTools.read_open_select_dir_state();
			if (obj.state == 0) {
				var bytes:hl.Bytes = obj.path;
				obj.nativePath = @:privateAccess String.fromUTF8(bytes);
				f.stop();
				quad.remove();
				quad = null;
				cb({
					path: obj.nativePath
				});
			} else if (obj.state == 1) {
				cb({
					path: ""
				});
				f.stop();
				quad.remove();
				quad = null;
			}
		});
	}
}

typedef FileDialogFile = {
	path:String
}
#end
