package zygame.utils.hl.mac;

import haxe.io.Bytes;

/**
 * 文件管理器
 */
@:noCompletion class FileDialog {
	/**
	 * 打开单个可选目录文件
	 * @param dir 
	 * @param cb 
	 */
	public static function openSelectOneFile(dir:String, cb:FileDialogFile->Void):Void {
		IOSTools.open_select_dir(function(data) {
			var bytes:hl.Bytes = data.path;
			var path = @:privateAccess String.fromUTF8(bytes);
			cb({
				path: path
			});
		});
	}
}

typedef FileDialogFile = {
	path:String
}
