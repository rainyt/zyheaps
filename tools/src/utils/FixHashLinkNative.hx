package utils;

import sys.io.File;

/**
 * 一个通用的修复程序
 */
class FixHashLinkNative {
	public static function fix(path:String):Void {
		var nativeH = path + "hl/natives.h";
		var content = File.getContent(nativeH);
		content = StringTools.replace(content, "HL_API vdynamic* hl_tls_get(hl_tls*);", "HL_API void* hl_tls_get(hl_tls*);");
		content = StringTools.replace(content, "HL_API void hl_tls_set(hl_tls*,vdynamic*);", "HL_API void hl_tls_set(hl_tls*,void*);");
		File.saveContent(nativeH, content);
	}
}
