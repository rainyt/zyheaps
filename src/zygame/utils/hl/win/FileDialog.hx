package zygame.utils.hl.win;

import zygame.core.Start;
import zygame.display.Quad;
import haxe.io.Bytes;

#if window
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
		NativeTools.open_select_dir(function(data) {
			quad.remove();
			quad = null;
			#if window
			var path:String = data.path;
			#else
			var bytes:hl.Bytes = data.path;
			var path = @:privateAccess String.fromUTF8(bytes);
			#end
			cb({
				path: path
			});
		});
	}
}

typedef FileDialogFile = {
	path:String
}
#end