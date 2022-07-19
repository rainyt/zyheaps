package zygame.net;

import haxe.io.Bytes;
#if hl
import zygame.utils.hl.Thread;
import sys.Http;
#elseif html5
import js.html.XMLHttpRequest;
#end

/**
 * 网络请求
 */
class HttpRequest {
	#if hl
	private var _t:Thread;
	#end

	private var _url:String;

	private var _post:Bool = false;

	public function new(url:String, post:Bool = false) {
		#if hl
		sys.ssl.Socket.DEFAULT_VERIFY_CERT = false;
		#end
		_url = url;
		_post = post;
	}

	public function load():Void {
		#if hl
		var main = Thread.current();
		_t = Thread.create(function() {
			var http = new Http(_url);
			var pstatus:Int = 0;
			http.onStatus = function(status) {
				pstatus = status;
			};
			http.onBytes = function(httpdata) {
				var data:ThreadMessage = {
					uid: _t.uid,
					data: {
						data: httpdata,
						status: pstatus
					},
					code: 0
				}
				main.sendMessage(data);
			}
			http.onError = function(msg:String) {
				var data:ThreadMessage = {
					uid: _t.uid,
					data: {
						data: msg,
						status: pstatus
					},
					code: 1
				}
				main.sendMessage(data);
			};
			http.request(_post);
		}, function(data) {
			switch (data.code) {
				case 0:
					// 处理数据
					onData(data.data.status, data.data.data);
				case 1:
					// 加载失败
					onError(data.data.status, data.data.data);
			}
		});
		#elseif html5
		var done = false;
		var xml:XMLHttpRequest = new XMLHttpRequest();
		xml.open(_post ? "POST" : "GET", _url);
		xml.onloadend = function(data) {
			if (done)
				return;
			done = true;
			this.onData(xml.status, data);
		}
		xml.onerror = function(msg) {
			if (done)
				return;
			done = true;
			this.onError(xml.status, "load '" + _url + "' fail");
		}
		xml.send();
		#else
		throw "this is not support platform";
		#end
	}

	/**
	 * 接收网络请求数据
	 * @param stateCode 
	 * @param bytes 
	 */
	dynamic public function onData(stateCode:Int, bytes:Bytes):Void {}

	/**
	 * 当加载失败时触发
	 * @param stateCode 
	 * @param msg 
	 */
	dynamic public function onError(stateCode:Int, msg:String):Void {}
}
