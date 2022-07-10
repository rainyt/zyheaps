package zygame.utils.hl;

import haxe.io.Bytes;

interface ILoader {
	/**
	 * 载入完成后
	 * @param bytes 
	 */
	dynamic public function onSuccess(bytes:Bytes):Void;

	/**
	 * 载入失败
	 * @param msg 
	 */
	dynamic public function onError(msg:String):Void;
}
