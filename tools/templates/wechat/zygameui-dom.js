(function ($hx_exports, $global) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); },$hxEnums = $hxEnums || {},$_;
function $extend(from, fields) {
	var proto = Object.create(from);
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var EventElement = function() {
	this.events = new haxe_ds_StringMap();
	this.ontimeout = null;
	this.onprogress = null;
	this.onload = null;
	this.onerror = null;
};
EventElement.__name__ = true;
EventElement.prototype = {
	addEventListener: function(type,listener) {
		var arr = this.events.h[type];
		if(arr == null) {
			arr = [];
			this.events.h[type] = arr;
		}
		arr.push(listener);
	}
	,removeEventListener: function(type,listener) {
		var arr = this.events.h[type];
		if(arr != null) {
			HxOverrides.remove(arr,listener);
		}
	}
	,dispatchEvent: function(event) {
		if(event.type != null && event.type.indexOf("on") == 0) {
			event.type = HxOverrides.substr(event.type,2,null);
		}
		var arr = this.events.h[event.type];
		if(arr != null) {
			var _g = 0;
			while(_g < arr.length) {
				var e = arr[_g];
				++_g;
				e(event);
			}
		}
	}
	,triggerEvent: function(type,event) {
		if(event == null) {
			event = new window_events_Event(type);
		}
		event.target = event.target != null ? event.target : this;
		
        if (typeof this[`on${type}`] === 'function') {
            this[`on${type}`].call(this, event);
        }
		this.dispatchEvent(event);
	}
};
var Element = $hx_exports["Element"] = function() {
	this.height = 0;
	this.width = 0;
	EventElement.call(this);
	this.style = new Style();
};
Element.__name__ = true;
Element.__super__ = EventElement;
Element.prototype = $extend(EventElement.prototype,{
});
var HTMLElement = $hx_exports["HTMLElement"] = function(type) {
	Element.call(this);
	this.tagName = type;
};
HTMLElement.__name__ = true;
HTMLElement.__super__ = Element;
HTMLElement.prototype = $extend(Element.prototype,{
	getBoundingClientRect: function() {
		var rect = { x : 0, y : 0, top : 0, left : 0, width : Window._window.innerWidth, height : Window._window.innerHeight};
		rect.right = this.width;
		rect.bottom = this.height;
		return rect;
	}
	,appendChild: function(child) {
	}
});
var HTMLCanvasElement = $hx_exports["HTMLCanvasElement"] = function(type) {
	HTMLElement.call(this,type);
};
HTMLCanvasElement.__name__ = true;
HTMLCanvasElement.__super__ = HTMLElement;
HTMLCanvasElement.prototype = $extend(HTMLElement.prototype,{
	toDataURL: function() {
		return "data:,";
	}
});
var Canvas = $hx_exports["Canvas"] = function() {
	HTMLCanvasElement.call(this,"CANVAS");
	this._wxCanvas = wx.createCanvas();
	HTMLUtils.definePropertySetGet(this,"width",$bind(this,this.set_width),$bind(this,this.get_width));
	HTMLUtils.definePropertySetGet(this,"height",$bind(this,this.set_height),$bind(this,this.get_height));
	this.width = this._wxCanvas.width;
	this.height = this._wxCanvas.height;
};
Canvas.__name__ = true;
Canvas.__super__ = HTMLCanvasElement;
Canvas.prototype = $extend(HTMLCanvasElement.prototype,{
	cleanup: function() {
		this._wxCanvas = null;
		if(this._context2d != null) {
			this._context2d.cleanup();
			this._context2d = null;
		}
		this._gl = null;
	}
	,getAttribute: function(key) {
		return "";
	}
	,setAttribute: function(key,value) {
	}
	,set_width: function(f) {
		if(this._wxCanvas == null) {
			return 0;
		}
		this._wxCanvas.width = f;
		return f;
	}
	,get_width: function() {
		if(this._wxCanvas == null) {
			return 0;
		}
		return this._wxCanvas.width;
	}
	,set_height: function(f) {
		if(this._wxCanvas == null) {
			return 0;
		}
		this._wxCanvas.height = f;
		return f;
	}
	,get_height: function() {
		if(this._wxCanvas == null) {
			return 0;
		}
		return this._wxCanvas.height;
	}
	,toTempFilePath: function(data) {
		this._wxCanvas.toTempFilePath(data);
	}
	,toTempFilePathSync: function(data) {
		return this._wxCanvas.toTempFilePathSync(data);
	}
	,getContext: function(type) {
		if(type != "2d") {
			type = "webgl";
		}
		if(type == "2d") {
			if(this._context2d == null) {
				this._context2d = new Context2d(this._wxCanvas.getContext(type));
				this._context2d._canvas = this._wxCanvas;
			}
			return this._context2d;
		} else {
			if(this._gl == null) {
				this._gl = this._wxCanvas.getContext(type);
				this._gl.antialias = true;
				this.varWebGLRenderingContext2D(this._gl);
			}
			return this._gl;
		}
	}
	,putImageData: function() {
	}
	,varWebGLRenderingContext2D: function(gl) {
		if(gl == null) {
			return;
		}
		var texImage2D = gl.texImage2D;
		gl.texImage2D = function() {
			
            var imgContext = null;
            if(arguments.length == 6)
            {
                if(arguments[5] == null)
                {
                    console.log('无法渲染');
                    return;   
                }
                if(arguments[5]._wxCanvas != null)
                    arguments[5] = arguments[5]._wxCanvas;
                if(arguments[5]._contextImage != null){
                    imgContext = arguments[5];
                    arguments[5] = arguments[5]._contextImage;
                }
            }
            texImage2D.apply(this,arguments);
            // if(imgContext != null){
            //     console.log('dispose imgContext');
            //    imgContext._contextImage.onload = null;
            //    imgContext._contextImage.onerror = null
            //    imgContext._contextImage.src = '';
            //    imgContext._contextImage = null;
            // }
		};
	}
	,uniformFix: function(gl,funName) {
		var call = Reflect.getProperty(gl,funName);
		if(call != null) {
			Reflect.setProperty(gl,funName,function() {
				
                if(arguments[0] == null || arguments[0].__objID == null)
                    return;
                call.apply(this,arguments)
                ;
			});
		}
	}
});
var CanvasRenderingContext2D = $hx_exports["CanvasRenderingContext2D"] = function() {
};
CanvasRenderingContext2D.__name__ = true;
var Context2d = function(context) {
	var _gthis = this;
	Context2d.CONTEXT2D_COUNT++;
	window.contextCount = Context2d.CONTEXT2D_COUNT;
	this._context = context;
	HTMLUtils.definePropertySetGet(this,"globalAlpha",function(value) {
		_gthis._context.globalAlpha = value;
	},function() {
		return _gthis._context.globalAlpha;
	});
	HTMLUtils.definePropertySetGet(this,"canvas",function(value) {
		_gthis._canvas = value;
	},function() {
		return _gthis._canvas;
	});
	HTMLUtils.definePropertySetGet(this,"textAlign",function(value) {
		_gthis._context.textAlign = value;
	},function() {
		return "start";
	});
	HTMLUtils.definePropertySetGet(this,"font",function(value) {
		var arr = value.split(" ");
		var fontName = HxOverrides.substr(value,value.indexOf("'") + 1,null);
		fontName = HxOverrides.substr(fontName,0,fontName.lastIndexOf("'"));
		var _g = 0;
		while(_g < arr.length) {
			var a = arr[_g];
			++_g;
			if(a.indexOf("px") != -1) {
				_gthis.updateFontSize(a);
				if(a.indexOf("/") != -1) {
					a = HxOverrides.substr(a,a.indexOf("/") + 1,null);
				}
				fontName = StringTools.replace(fontName,"/","");
				fontName = StringTools.replace(fontName,".","");
				if(fontName.indexOf("px") != -1) {
					_gthis._context.font = fontName;
				} else {
					_gthis._context.font = a + " " + fontName;
				}
				break;
			}
		}
	},function() {
		return _gthis._context.font;
	});
	HTMLUtils.definePropertySetGet(this,"fillStyle",function(value) {
		_gthis._context.fillStyle = value;
	},function() {
		return _gthis._context.fillStyle;
	});
	HTMLUtils.definePropertySetGet(this,"textBaseline",function(value) {
		_gthis._context.textBaseline = value;
	},function() {
		return _gthis._context.textBaseline;
	});
	HTMLUtils.definePropertySetGet(this,"imageSmoothingEnabled",function(value) {
		_gthis._context.imageSmoothingEnabled = value;
	},function() {
		return _gthis._context.imageSmoothingEnabled;
	});
};
Context2d.__name__ = true;
Context2d.prototype = {
	get_canvas: function() {
		return this._canvas;
	}
	,cleanup: function() {
		if(this._context != null) {
			Context2d.CONTEXT2D_COUNT--;
			window.contextCount = Context2d.CONTEXT2D_COUNT;
		}
		this._context = null;
		this._canvas = null;
	}
	,createLinearGradient: function(a,b,c,d) {
		return this._context.createLinearGradient(a,b,c,d);
	}
	,updateFontSize: function(font) {
	}
	,translate: function(x,y) {
		this._context.translate(x,y);
	}
	,clearRect: function(x,y,width,height) {
		if(x == null || y == null || width == null || height == null) {
			this._context.clearRect(0,0,0,0);
		} else {
			this._context.clearRect(x,y,width,height);
		}
	}
	,set_strokeStyle: function(value) {
		this._context.strokeStyle = value;
		return this._context.strokeStyle;
	}
	,get_strokeStyle: function() {
		return this._context.strokeStyle;
	}
	,createImageData: function(width,height) {
		return this._context.createImageData(width,height);
	}
	,moveTo: function(x,y) {
		this._context.moveTo(x,y);
	}
	,lineTo: function(x,y) {
		this._context.lineTo(x,y);
	}
	,rect: function(x,y,w,h) {
		this._context.rect(x,y,w,h);
	}
	,fillRect: function(x,y,w,h) {
		this._context.fillRect(x,y,w,h);
	}
	,createPattern: function(texture,type) {
		var setTexture = null;
		if(texture._wxCanvas != null) {
			setTexture = texture._wxCanvas;
		} else if(texture._contextImage != null) {
			setTexture = texture._contextImage;
		}
		if(setTexture == null) {
			return null;
		} else {
			return this._context.createPattern(setTexture,type);
		}
	}
	,quadraticCurveTo: function(a,b,c,d) {
		this._context.quadraticCurveTo(a,b,c,d);
	}
	,getImageData: function(a,b,c,d) {
		return this._context.getImageData(a,b,c,d);
	}
	,putImageData: function(a,b,c) {
		this._context.putImageData(a,b,c);
	}
	,setImageData: function() {
	}
	,drawImage: function(image,sx,sy,sWidth,sHeight,dx,dy,dWidth,dHeight) {
		if(image._contextImage != null) {
			image = image._contextImage;
		} else if(image._wxCanvas != null) {
			image = image._wxCanvas;
		}
		this._context.drawImage(image,sx,sy,sWidth,sHeight,dx,dy,dWidth,dHeight);
	}
	,beginPath: function() {
		this._context.beginPath();
	}
	,closePath: function() {
		this._context.closePath();
	}
	,fill: function() {
		this._context.fill();
	}
	,stroke: function(path) {
		this._context.stroke(path);
	}
	,fillText: function(text,x,y) {
		this._context.fillText(text,x,y);
	}
	,measureText: function(text) {
		var data = this._context.measureText(text);
		if(data != null) {
			return data;
		} else {
			return { width : 0};
		}
	}
	,transform: function(t1,t2,t3,t4,dx,dy) {
		this._context.transform(t1,t2,t3,t4,dx,dy);
	}
	,save: function() {
		this._context.save();
	}
	,clip: function() {
		this._context.clip();
	}
	,restore: function() {
		this._context.restore();
	}
	,setTransform: function(a,b,c,d,e,f) {
		this._context.setTransform(a,b,c,d,e,f);
	}
	,isPointInStroke: function(a,b,c) {
		return this._context.isPointInStroke(a,b,c);
	}
	,isPointInPath: function(a,b,c,d) {
		if(typeof(a) == "number") {
			return false;
		}
		return this._context.isPointInPath(a,b,c,d);
	}
	,arc: function(x,y,radius,startAngle,endAngle,anticlockwise) {
		this._context.arc(x,y,radius,startAngle,endAngle,anticlockwise);
	}
	,arcTo: function(x1,y1,x2,y2,radius) {
		this._context.arcTo(x1,y1,x2,y2,radius);
	}
	,__properties__: {set_strokeStyle:"set_strokeStyle",get_strokeStyle:"get_strokeStyle",get_canvas:"get_canvas"}
};
var Style = function() {
};
Style.__name__ = true;
Style.prototype = {
	setProperty: function(a,b,c) {
	}
};
var HTMLAudioElement = $hx_exports["HTMLAudioElement"] = function(type) {
	HTMLElement.call(this,type);
};
HTMLAudioElement.__name__ = true;
HTMLAudioElement.__super__ = HTMLElement;
HTMLAudioElement.prototype = $extend(HTMLElement.prototype,{
});
var HTMLDocument = $hx_exports["HTMLDocument"] = function(type) {
	this.readyState = "complete";
	HTMLElement.call(this,type);
};
HTMLDocument.__name__ = true;
HTMLDocument.__super__ = HTMLElement;
HTMLDocument.prototype = $extend(HTMLElement.prototype,{
	exitFullscreen: function() {
	}
	,getElementById: function(id) {
		if(id == "GameCanvas" || id == "webgl") {
			return window.canvas;
		} else if(window.canvas != null && id == window.canvas.id) {
			return window.canvas;
		}
		return null;
	}
	,createElementNS: function(type) {
		return null;
	}
	,createTextNode: function(chars) {
		return null;
	}
	,createElement: function(type) {
		type = type.toLowerCase();
		if(type == "textcanvas") {
			if(this.textcanvas == null) {
				this.textcanvas = new Canvas();
			}
			this.textcanvas.getContext("2d").clearRect(0,0,this.textcanvas.width,this.textcanvas.height);
			return this.textcanvas;
		} else if(type == "canvas") {
			return new Canvas();
		} else {
			var tmp = type == "audio";
		}
		return new HTMLElement(type);
	}
});
var HTMLImageElement = $hx_exports["HTMLImageElement"] = function() {
	this._src = null;
	this.src = null;
	HTMLElement.call(this,"IMG");
	HTMLUtils.definePropertySetGet(this,"src",$bind(this,this.set_src),$bind(this,this.get_src));
	HTMLUtils.definePropertySetGet(this,"width",$bind(this,this.set_width),$bind(this,this.get_width));
	HTMLUtils.definePropertySetGet(this,"height",$bind(this,this.set_height),$bind(this,this.get_height));
};
HTMLImageElement.__name__ = true;
HTMLImageElement.__super__ = HTMLElement;
HTMLImageElement.prototype = $extend(HTMLElement.prototype,{
	createImage: function() {
		var _gthis = this;
		if(this._contextImage != null) {
			return;
		}
		HTMLImageElement.IMAGE_COUNT++;
		window.imageCount = HTMLImageElement.IMAGE_COUNT;
		this._contextImage = wx.createImage();
		this._contextImage.onload = function() {
			_gthis.width = _gthis._contextImage.width;
			_gthis.height = _gthis._contextImage.height;
			_gthis.triggerEvent("load");
		};
		this._contextImage.onerror = function(err) {
			_gthis.triggerEvent("error");
		};
	}
	,disposeImage: function() {
		if(this._contextImage != null) {
			HTMLImageElement.IMAGE_COUNT--;
			window.imageCount = HTMLImageElement.IMAGE_COUNT;
			this._contextImage.onload = null;
			this._contextImage.onerror = null;
			this._contextImage.src = "";
			this._contextImage = null;
		}
	}
	,set_width: function(f) {
		this._width = f;
		return f;
	}
	,get_width: function() {
		return this._width;
	}
	,set_height: function(f) {
		this._height = f;
		return f;
	}
	,get_height: function() {
		return this._height;
	}
	,set_src: function(path) {
		var _gthis = this;
		haxe_Log.trace("开始加载",{ fileName : "src/HTMLImageElement.hx", lineNumber : 93, className : "HTMLImageElement", methodName : "set_src"});
		HTMLUtils.ofPathNoSync(path,function(path) {
			if(path.indexOf("data:") == 0 || path.indexOf(HTMLUtils.START) != -1 || path.indexOf("photo://") != -1) {
				_gthis._src = path;
				if(path.indexOf("photo://") == -1) {
					_gthis._src = StringTools.replace(_gthis._src,HTMLUtils.START,"");
				} else {
					_gthis._src = StringTools.replace(_gthis._src,"photo://",HTMLUtils.START);
				}
				_gthis.createImage();
				_gthis._contextImage.src = _gthis._src;
			} else if(!HTMLUtils.cacheAssets(path,"binary",function(data) {
				_gthis.createImage();
				_gthis._src = data;
				_gthis._contextImage.src = data;
			},function() {
				_gthis.createImage();
				_gthis._src = path;
				_gthis._contextImage.src = path;
			},true)) {
				_gthis._src = path;
				_gthis.createImage();
				_gthis._contextImage.src = path;
			}
		});
		return this._src;
	}
	,get_src: function() {
		return this._src;
	}
});
var haxe_ds_StringMap = function() {
	this.h = Object.create(null);
};
haxe_ds_StringMap.__name__ = true;
var HTMLUtils = function() { };
HTMLUtils.__name__ = true;
HTMLUtils.isArrayBuffer = function(data) {
	return data instanceof ArrayBuffer;
};
HTMLUtils.definePropertySetGet = function(obj,key,set,get) {
	
        Object.defineProperty(obj, key, {
            enumerable: true,
            configurable: true,
            set: set,
            get: get
        });
};
HTMLUtils.isString = function(data) {
	return typeof data === 'string';
};
HTMLUtils.ofPathNoSync = function(path,cb) {
	cb(HTMLUtils.ofPath(path));
};
HTMLUtils.ofPath = function(path) {
	if(path.indexOf("data:image") == 0 || path.indexOf("http") == 0 && !HTMLUtils.isLocalAssets(path) || path.indexOf(HTMLUtils.START) != -1 || path.indexOf("photo://") != -1) {
		return path;
	} else if(window.webPath == null || HTMLUtils.isLocalAssets(path)) {
		if(path.indexOf(window.webPath + "/") == 0) {
			path = StringTools.replace(path,window.webPath + "/","");
		}
		if(path.indexOf(HTMLUtils.START) == -1) {
			path = HTMLUtils.START + path;
		}
		if(path.indexOf("?") != -1) {
			path = HxOverrides.substr(path,0,path.lastIndexOf("?"));
		}
	} else {
		path = window.webPath + "/" + path;
	}
	return path;
};
HTMLUtils.isLocalAssetsNoSync = function(path,cb) {
	if(path.indexOf(window.webPath + "/") == 0) {
		path = StringTools.replace(path,window.webPath + "/","");
	}
	if(path.indexOf("http") == 0) {
		cb(false);
	}
	if(path.indexOf("?") != -1) {
		path = HxOverrides.substr(path,0,path.lastIndexOf("?"));
	}
	wx.getFileSystemManager().access({ path : path, success : function(res) {
		cb(true);
	}, fail : function(res) {
		cb(false);
	}});
};
HTMLUtils.isLocalAssets = function(path) {
	if(path.indexOf(window.webPath + "/") == 0) {
		path = StringTools.replace(path,window.webPath + "/","");
	}
	if(path.indexOf("http") == 0) {
		return false;
	}
	if(path.indexOf("?") != -1) {
		path = HxOverrides.substr(path,0,path.lastIndexOf("?"));
	}
	try {
		wx.getFileSystemManager().accessSync(path);
		return true;
	} catch( _g ) {
		return false;
	}
};
HTMLUtils.ofLocalPath = function(path) {
	var localPath = wx.env.USER_DATA_PATH + "/" + haxe_crypto_Md5.encode(path);
	return localPath;
};
HTMLUtils.cacheAssets = function(path,encoding,success,fail,callLocalPath) {
	if(callLocalPath == null) {
		callLocalPath = false;
	}
	if(path.indexOf(HTMLUtils.START) == 0) {
		path = StringTools.replace(path,HTMLUtils.START,"");
		if(callLocalPath) {
			success(path);
			return true;
		}
		var obj = { filePath : path, success : function(res) {
			success(res);
		}, fail : function() {
			fail();
		}};
		if(encoding == "binary") {
			encoding = null;
		} else {
			obj.encoding = encoding;
		}
		wx.getFileSystemManager().readFile(obj);
		return true;
	}
	if(Object.prototype.hasOwnProperty.call(HTMLUtils.tempFileMaps.h,path)) {
		if(callLocalPath) {
			success(HTMLUtils.tempFileMaps.h[path]);
		} else {
			if(encoding == "binary") {
				encoding = null;
			}
			var tmp = HTMLUtils.tempFileMaps.h[path];
			wx.getFileSystemManager().readFile({ filePath : tmp, encoding : encoding, success : function(res) {
				success(res);
			}, fail : function(res) {
				haxe_Log.trace("临时文件读取失败：",{ fileName : "src/HTMLUtils.hx", lineNumber : 229, className : "HTMLUtils", methodName : "cacheAssets", customParams : [res]});
				fail();
			}});
		}
		return true;
	}
	if(path.indexOf("http") != 0) {
		return false;
	}
	var isCanCache = false;
	var _g = 0;
	var _g1 = HTMLUtils.cacheExt;
	while(_g < _g1.length) {
		var c = _g1[_g];
		++_g;
		if(path.indexOf(c) != -1) {
			isCanCache = true;
			break;
		}
	}
	if(!isCanCache) {
		return false;
	}
	HTMLUtils.downloadTempFile(path,function(res) {
		if(callLocalPath) {
			success(res);
		} else {
			if(encoding == "binary") {
				encoding = null;
			}
			var tmp = HTMLUtils.tempFileMaps.h[path];
			wx.getFileSystemManager().readFile({ filePath : tmp, encoding : encoding, success : function(res) {
				success(res);
			}, fail : function(res) {
				haxe_Log.trace("临时文件读取失败-2：",{ fileName : "src/HTMLUtils.hx", lineNumber : 264, className : "HTMLUtils", methodName : "cacheAssets", customParams : [res]});
				fail();
			}});
		}
	},fail);
	return true;
};
HTMLUtils.arrayBufferToString = function(arrayBuffer) {
	if(HTMLUtils.isArrayBuffer(arrayBuffer)) {
		 var result = "";
		  var i = 0;
		  var c = 0;
		  var c1 = 0;
		  var c2 = 0;
		  var c3 = 0;

		  var data = new Uint8Array(arrayBuffer);

		  // If we have a BOM skip it
		  if (data.length >= 3 && data[0] === 0xef && data[1] === 0xbb && data[2] === 0xbf) {
		    i = 3;
		  }

		  while (i < data.length) {
		    c = data[i];

		    if (c < 128) {
		      result += String.fromCharCode(c);
		      i++;
		    } else if (c > 191 && c < 224) {
		      if( i+1 >= data.length ) {
		        throw "UTF-8 Decode failed. Two byte character was truncated.";
		      }
		      c2 = data[i+1];
		      result += String.fromCharCode( ((c&31)<<6) | (c2&63) );
		      i += 2;
		    } else {
		      if (i+2 >= data.length) {
		        throw "UTF-8 Decode failed. Multi byte character was truncated.";
		      }
		      c2 = data[i+1];
		      c3 = data[i+2];
		      result += String.fromCharCode( ((c&15)<<12) | ((c2&63)<<6) | (c3&63) );
		      i += 3;
		    }
		  }
		  return result;
	}
	return arrayBuffer;
};
HTMLUtils.downloadTempFile = function(path,success,fail) {
	wx.downloadFile({ url : path, timeout : 6000, success : function(res) {
		var value = res.tempFilePath;
		if(value == null || value == "") {
			HTMLUtils.downloadTempFile(path,success,fail);
		} else {
			HTMLUtils.tempFileMaps.h[path] = value;
			success(res.tempFilePath);
		}
	}, fail : function(data) {
		haxe_Log.trace("wx.donwloadFile fail:",{ fileName : "src/HTMLUtils.hx", lineNumber : 346, className : "HTMLUtils", methodName : "downloadTempFile", customParams : [path,data]});
		fail();
	}});
};
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) {
		return undefined;
	}
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(len == null) {
		len = s.length;
	} else if(len < 0) {
		if(pos == 0) {
			len = s.length + len;
		} else {
			return "";
		}
	}
	return s.substr(pos,len);
};
HxOverrides.remove = function(a,obj) {
	var i = a.indexOf(obj);
	if(i == -1) {
		return false;
	}
	a.splice(i,1);
	return true;
};
HxOverrides.now = function() {
	return Date.now();
};
var Image = $hx_exports["Image"] = function() {
	HTMLImageElement.call(this);
};
Image.__name__ = true;
Image.__super__ = HTMLImageElement;
Image.prototype = $extend(HTMLImageElement.prototype,{
});
var LocalStorage = function() {
};
LocalStorage.__name__ = true;
LocalStorage.prototype = {
	key: function(n) {
		var keys = wx.getStorageInfoSync().keys;
		return keys[n];
	}
	,getItem: function(key) {
		if(key == "") {
			return null;
		}
		var value = wx.getStorageSync(key);
		if(value == "") {
			return null;
		} else {
			return value;
		}
	}
	,setItem: function(key,value) {
		return wx.setStorageSync(key,value);
	}
	,removeItem: function(key) {
	}
	,clear: function() {
		wx.clearStorageSync();
	}
};
var Location = function() {
	this.protocol = "";
};
Location.__name__ = true;
Math.__name__ = true;
var Navigator = function() {
	this.appVersion = "wechat";
	this.userAgent = "zygame-dom";
};
Navigator.__name__ = true;
var Performance2 = function() {
};
Performance2.__name__ = true;
Performance2.prototype = {
	now: function() {
		if(Window.platform == "devtools") {
			return wx.getPerformance().now();
		}
		return wx.getPerformance().now() / 1000 | 0;
	}
};
var Reflect = function() { };
Reflect.__name__ = true;
Reflect.getProperty = function(o,field) {
	var tmp;
	if(o == null) {
		return null;
	} else {
		var tmp1;
		if(o.__properties__) {
			tmp = o.__properties__["get_" + field];
			tmp1 = tmp;
		} else {
			tmp1 = false;
		}
		if(tmp1) {
			return o[tmp]();
		} else {
			return o[field];
		}
	}
};
Reflect.setProperty = function(o,field,value) {
	var tmp;
	var tmp1;
	if(o.__properties__) {
		tmp = o.__properties__["set_" + field];
		tmp1 = tmp;
	} else {
		tmp1 = false;
	}
	if(tmp1) {
		o[tmp](value);
	} else {
		o[field] = value;
	}
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) {
			a.push(f);
		}
		}
	}
	return a;
};
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	if(x != null) {
		var _g = 0;
		var _g1 = x.length;
		while(_g < _g1) {
			var i = _g++;
			var c = x.charCodeAt(i);
			if(c <= 8 || c >= 14 && c != 32 && c != 45) {
				var nc = x.charCodeAt(i + 1);
				var v = parseInt(x,nc == 120 || nc == 88 ? 16 : 10);
				if(isNaN(v)) {
					return null;
				} else {
					return v;
				}
			}
		}
	}
	return null;
};
var _$String_String_$Impl_$ = function() { };
_$String_String_$Impl_$.__name__ = true;
_$String_String_$Impl_$.fromCharCode = function(code) {
	return String.fromCodePoint(code);
};
var StringTools = function() { };
StringTools.__name__ = true;
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
};
var UploadElement = function() {
	HTMLElement.call(this,"UPLOAD");
};
UploadElement.__name__ = true;
UploadElement.__super__ = HTMLElement;
UploadElement.prototype = $extend(HTMLElement.prototype,{
});
var WebSocket = $hx_exports["WebSocket"] = function(url,protocols) {
	this.readyState = 3;
	this.onopen = null;
	this.onmessage = null;
	this.onerror = null;
	this.onclose = null;
	this.extensions = "";
	this.bufferedAmount = 0;
	this.binaryType = "";
	var _gthis = this;
	if(typeof(url) != "string" || url == null || url.indexOf("ws") != 0) {
		throw haxe_Exception.thrown("无效的 Scoket URL");
	}
	if(!window.unwss && url.indexOf("ws://") != -1 && url.indexOf("127") == -1 && url.indexOf("192") == -1) {
		url = StringTools.replace(url,"ws://","wss://");
	}
	this._baseSocket = wx.connectSocket({ url : url});
	this._baseSocket.onClose(function(res) {
		if(_gthis.readyState == WebSocket.CLOSED) {
			return;
		}
		_gthis.readyState = WebSocket.CLOSED;
		if(_gthis.onclose != null) {
			_gthis.onclose(res);
		}
	});
	this._baseSocket.onMessage(function(res) {
		if(_gthis.readyState == WebSocket.CLOSED) {
			return;
		}
		if(_gthis.onmessage != null) {
			_gthis.onmessage(res);
		}
	});
	this._baseSocket.onOpen(function() {
		if(_gthis.readyState == WebSocket.CLOSED) {
			return;
		}
		_gthis.readyState = WebSocket.OPEN;
		if(_gthis.onopen != null) {
			_gthis.onopen();
		}
	});
	this._baseSocket.onError(function(res) {
		if(_gthis.readyState == WebSocket.CLOSED) {
			return;
		}
		if(_gthis.onerror != null) {
			_gthis.onerror(res);
		}
	});
	this.readyState = WebSocket.CONNECTING;
};
WebSocket.__name__ = true;
WebSocket.prototype = {
	close: function(code,reason) {
		this.readyState = WebSocket.CLOSING;
		this._baseSocket.close({ code : 1000, reason : reason});
	}
	,send: function(data) {
		this._baseSocket.send({ data : data});
	}
};
var Window = $hx_exports["Window"] = function() {
	this.supported = true;
	this.devicePixelRatio = 1;
	this.document = new HTMLDocument("DOM");
	HTMLElement.call(this,"WINDOW");
	this.innerWidth = wx.getSystemInfoSync().screenWidth;
	this.innerHeight = wx.getSystemInfoSync().screenHeight;
	var scale1 = 1080 / this.innerWidth;
	var scale2 = 1980 / this.innerHeight;
	this.devicePixelRatio = Math.max(scale1,scale2);
	var settingDevicePixelRatio = wx.getStorageSync("wechat_devicePixelRatio");
	if(settingDevicePixelRatio != "" || settingDevicePixelRatio != null) {
		var newdevicePixelRatio = Std.parseInt(Std.string(settingDevicePixelRatio));
		if(newdevicePixelRatio >= 1 && newdevicePixelRatio < this.devicePixelRatio) {
			this.devicePixelRatio = newdevicePixelRatio;
		}
	}
	console.log("分辨率比：",this.devicePixelRatio,wx.getSystemInfoSync().platform);
	window.devicePixelRatio = this.devicePixelRatio;
	this.location = new Location();
	this.navigator = new Navigator();
	this.localStorage = new LocalStorage();
	this.document.location = this.location;
	wx.setPreferredFramesPerSecond(60);
	if(wx.onAccelerometerChange != null) {
		wx.onAccelerometerChange($bind(this,this.onAccelerometerChange));
	}
	wx.onHide($bind(this,this.onHide));
	wx.onShow($bind(this,this.onShow));
	if(wx.setKeepScreenOn != null) {
		wx.setKeepScreenOn({ keepScreenOn : true});
	}
	try {
		wx.onMemoryWarning(function() {
			if(wx.triggerGC != null) {
				wx.triggerGC();
			}
		});
	} catch( _g ) {
		console.log("wx.onMemoryWarning is not support!");
	}
	window.shareApp = Window.share;
};
Window.__name__ = true;
Window.main = function() {
	Window.canvas.id = "mainCanvas";
	Window.platform = wx.getSystemInfoSync().platform;
	Window._window = new Window();
	if(Window.platform == "devtools") {
		
                for(const key in Window._window)
                {
                    const descriptor = Object.getOwnPropertyDescriptor(global, key)
                    if (!descriptor || descriptor.configurable === true) {
                        if(key != 'document' && key != 'location'){
                            Object.defineProperty(window, key, {
                                value: Window._window[key]
                            })
                        }
                    }
                }
                for (const key in  Window._window.document) {
                    const descriptor = Object.getOwnPropertyDescriptor(window.document, key)
                    if (!descriptor || descriptor.configurable === true) {
                        Object.defineProperty(window.document, key, {
                            value:  Window._window.document[key]
                        })
                    }
                }
                window.parent = window;
            ;
	} else {
		for (const key in Window._window) {
                global[key] = Window._window[key]
            }
            global.window = global;
            global.top = global.parent = global;
	}
	if(window.performance == null) {
		Window._window.performance = new Performance2();
		window.performance = Window._window.performance;
	}
	window.platform = Window.platform;
	window.showQuery = { };
	Window.listenerTouchEvent();
};
Window.listenerTouchEvent = function() {
	wx.onTouchStart(Window.eventHandlerFactory("touchstart"));
	wx.onTouchMove(Window.eventHandlerFactory("touchmove"));
	wx.onTouchEnd(Window.eventHandlerFactory("touchend"));
	wx.onTouchCancel(Window.eventHandlerFactory("touchcancel"));
};
Window.eventHandlerFactory = function(type) {
	return function(data) {
		if(type == "touchstart") {
			Window.startTouch.push(data);
		} else if(type == "touchend") {
			if(Window.startTouch.length > 0) {
				Window.startTouch.shift();
			}
		}
		var event = new window_events_TouchEvent(type);
		event.changedTouches = data.changedTouches;
		event.touches = data.touches;
		Window.canvas.dispatchEvent(event);
	};
};
Window.clearTouchStart = function() {
	var _g = 0;
	var _g1 = Window.startTouch;
	while(_g < _g1.length) {
		var data = _g1[_g];
		++_g;
		var event = new window_events_TouchEvent("touchend");
		event.changedTouches = data.changedTouches;
		event.touches = data.touches;
		Window.canvas.dispatchEvent(event);
	}
};
Window.share = function(shareData,icon,callback,extinfo,isWebPath,failCallBack) {
	if(isWebPath == null) {
		isWebPath = true;
	}
	if(icon.indexOf("http") == -1 && isWebPath) {
		icon = window.webPath + "/" + icon;
	}
	Window.shareCallBack = callback;
	var param = "";
	if(typeof(extinfo) != "string") {
		var keys = Reflect.fields(extinfo);
		var _g = 0;
		while(_g < keys.length) {
			var key = keys[_g];
			++_g;
			param += key + "=" + Std.string(Reflect.getProperty(extinfo,key)) + "&";
		}
		param += "end=1";
	} else {
		param = extinfo;
	}
	haxe_Log.trace("share:",{ fileName : "src/Window.hx", lineNumber : 367, className : "Window", methodName : "share", customParams : [param]});
	wx.shareAppMessage({ title : shareData, imageUrl : icon, query : param});
	window.addEventListener("focus",Window.onShareFocus);
};
Window.onShareFocus = function(_) {
	window.removeEventListener("focus",Window.onShareFocus);
	if(Window.shareCallBack != null) {
		Window.shareCallBack();
	}
};
Window.__super__ = HTMLElement;
Window.prototype = $extend(HTMLElement.prototype,{
	matchMedia: function() {
		return { addListener : function(data) {
		}};
	}
	,addEventListener: function(type,listener) {
		var arr = this.events.h[type];
		if(arr == null) {
			arr = [];
			this.events.h[type] = arr;
		}
		arr.push(listener);
	}
	,openAccelerometerChange: function() {
		wx.startAccelerometer({ success : function() {
		}, fail : function() {
		}});
	}
	,closeAccelerometerChange: function() {
		wx.stopAccelerometer({ success : function() {
		}, fail : function() {
		}});
	}
	,onAccelerometerChange: function(data) {
		var deviceEvent = new window_events_DeviceMotionEvent();
		deviceEvent.interval = 20;
		deviceEvent.accelerationIncludingGravity = data;
		Window._window.triggerEvent("devicemotion",deviceEvent);
	}
	,onShow: function(e) {
		haxe_Log.trace("update ShowQuery=",{ fileName : "src/Window.hx", lineNumber : 422, className : "Window", methodName : "onShow", customParams : [e]});
		window.showQuery = e;
		Window._window.triggerEvent("focus");
	}
	,onHide: function() {
		Window._window.triggerEvent("blur");
		Window.clearTouchStart();
	}
});
var XMLHttpRequest = $hx_exports["XMLHttpRequest"] = function() {
	this.responseType = "text";
	this._requestHeader = new haxe_ds_StringMap();
	this.readyState = 0;
	this.onreadystatechange = null;
	this.onloadend = null;
	this.onloadstart = null;
	this.onabort = null;
	EventElement.call(this);
	this.upload = new UploadElement();
	this._requestHeader.h["content-type"] = "application/x-www-from-urlencoded";
};
XMLHttpRequest.__name__ = true;
XMLHttpRequest.__super__ = EventElement;
XMLHttpRequest.prototype = $extend(EventElement.prototype,{
	open: function(method,url,async,username,password) {
		this.method = method;
		this.url = url;
		this.changeReadyState(XMLHttpRequest.OPENED);
	}
	,overrideMimeType: function(type) {
	}
	,setRequestHeader: function(header,value) {
		header = header.toLowerCase();
		this._requestHeader.h[header] = value;
	}
	,send: function(data) {
		var _gthis = this;
		HTMLUtils.ofPathNoSync(this.url,function(path) {
			_gthis.url = path;
			var isCallBackPath = false;
			if(_gthis.url.indexOf("__zygameui.bitmap.path__") != -1) {
				_gthis.url = StringTools.replace(_gthis.url,"__zygameui.bitmap.path__","");
				isCallBackPath = true;
			}
			var isCanCache = HTMLUtils.cacheAssets(_gthis.url,_gthis.responseType == "arraybuffer" ? "binary" : "utf8",function(res) {
				if(isCallBackPath) {
					_gthis.onSuccess({ statusCode : 200, data : res});
				} else {
					res.statusCode = 200;
					_gthis.onSuccess(res);
				}
			},function() {
				_gthis.onFail();
			},isCallBackPath);
			if(!isCanCache) {
				_gthis.sendRequest(data);
			}
		});
	}
	,sendRequest: function(data) {
		var _gthis = this;
		var header = { };
		var h = this._requestHeader.h;
		var keys_h = h;
		var keys_keys = Object.keys(h);
		var keys_length = keys_keys.length;
		var keys_current = 0;
		while(keys_current < keys_length) {
			var key = keys_keys[keys_current++];
			Reflect.setProperty(header,key,this._requestHeader.h[key]);
		}
		if(data != null && typeof(data) != "string") {
			data = HTMLUtils.arrayBufferToString(data);
		}
		var requestData = { url : this.url, method : this.method, header : header, timeout : 6000, responseType : this.responseType, success : $bind(this,this.onSuccess), fail : function(e) {
			haxe_Log.trace("wechat fail:",{ fileName : "src/XMLHttpRequest.hx", lineNumber : 133, className : "XMLHttpRequest", methodName : "sendRequest", customParams : [_gthis.url,e]});
			_gthis.onFail();
		}, dataType : "unjson"};
		if(data != null) {
			requestData.data = data;
		}
		wx.request(requestData);
		this.triggerEvent("loadstart");
		this.changeReadyState(XMLHttpRequest.HEADERS_RECEIVED);
		this.changeReadyState(XMLHttpRequest.LOADING);
	}
	,onSuccess: function(data) {
		this.status = data.statusCode;
		if(!HTMLUtils.isArrayBuffer(data.data)) {
			if(!HTMLUtils.isString(data.data)) {
				this.response = JSON.stringify(data.data);
				this.responseText = this.response;
			} else {
				this.response = data.data;
				this.responseText = data.data;
			}
		} else if(this.responseType == "text") {
			this.response = HTMLUtils.arrayBufferToString(data.data);
			this.responseText = this.response;
		} else {
			this.response = data.data;
			this.responseText = null;
		}
		this.changeReadyState(XMLHttpRequest.DONE);
		this.triggerEvent("load");
		this.triggerEvent("loadend");
	}
	,onFail: function() {
		this.changeReadyState(XMLHttpRequest.DONE);
		this.triggerEvent("error");
	}
	,changeReadyState: function(state,event) {
		if(this.readyState == XMLHttpRequest.DONE) {
			return;
		}
		this.readyState = state;
		if(event == null) {
			event = { };
		}
		event.readyState = this.readyState;
		this.triggerEvent("readystatechange",event);
	}
	,getAllResponseHeaders: function() {
		var arr = [];
		var h = this._requestHeader.h;
		var keys_h = h;
		var keys_keys = Object.keys(h);
		var keys_length = keys_keys.length;
		var keys_current = 0;
		while(keys_current < keys_length) {
			var key = keys_keys[keys_current++];
			arr.push(key + ":" + this._requestHeader.h[key]);
		}
		return arr.join("\n");
	}
});
var haxe_Exception = function(message,previous,native) {
	Error.call(this,message);
	this.message = message;
	this.__previousException = previous;
	this.__nativeException = native != null ? native : this;
};
haxe_Exception.__name__ = true;
haxe_Exception.thrown = function(value) {
	if(((value) instanceof haxe_Exception)) {
		return value.get_native();
	} else if(((value) instanceof Error)) {
		return value;
	} else {
		var e = new haxe_ValueException(value);
		return e;
	}
};
haxe_Exception.__super__ = Error;
haxe_Exception.prototype = $extend(Error.prototype,{
	get_native: function() {
		return this.__nativeException;
	}
	,__properties__: {get_native:"get_native"}
});
var haxe__$Int64__$_$_$Int64 = function(high,low) {
	this.high = high;
	this.low = low;
};
haxe__$Int64__$_$_$Int64.__name__ = true;
var haxe_Log = function() { };
haxe_Log.__name__ = true;
haxe_Log.formatOutput = function(v,infos) {
	var str = Std.string(v);
	if(infos == null) {
		return str;
	}
	var pstr = infos.fileName + ":" + infos.lineNumber;
	if(infos.customParams != null) {
		var _g = 0;
		var _g1 = infos.customParams;
		while(_g < _g1.length) {
			var v = _g1[_g];
			++_g;
			str += ", " + Std.string(v);
		}
	}
	return pstr + ": " + str;
};
haxe_Log.trace = function(v,infos) {
	var str = haxe_Log.formatOutput(v,infos);
	if(typeof(console) != "undefined" && console.log != null) {
		console.log(str);
	}
};
var haxe_ValueException = function(value,previous,native) {
	haxe_Exception.call(this,String(value),previous,native);
	this.value = value;
};
haxe_ValueException.__name__ = true;
haxe_ValueException.__super__ = haxe_Exception;
haxe_ValueException.prototype = $extend(haxe_Exception.prototype,{
});
var haxe_crypto_Md5 = function() {
};
haxe_crypto_Md5.__name__ = true;
haxe_crypto_Md5.encode = function(s) {
	var m = new haxe_crypto_Md5();
	var h = m.doEncode(haxe_crypto_Md5.str2blks(s));
	return m.hex(h);
};
haxe_crypto_Md5.str2blks = function(str) {
	var str1 = haxe_io_Bytes.ofString(str);
	var nblk = (str1.length + 8 >> 6) + 1;
	var blks = [];
	var blksSize = nblk * 16;
	var _g = 0;
	var _g1 = blksSize;
	while(_g < _g1) {
		var i = _g++;
		blks[i] = 0;
	}
	var i = 0;
	var max = str1.length;
	var l = max * 8;
	while(i < max) {
		blks[i >> 2] |= str1.b[i] << (l + i) % 4 * 8;
		++i;
	}
	blks[i >> 2] |= 128 << (l + i) % 4 * 8;
	var k = nblk * 16 - 2;
	blks[k] = l & 255;
	blks[k] |= (l >>> 8 & 255) << 8;
	blks[k] |= (l >>> 16 & 255) << 16;
	blks[k] |= (l >>> 24 & 255) << 24;
	return blks;
};
haxe_crypto_Md5.prototype = {
	bitOR: function(a,b) {
		var lsb = a & 1 | b & 1;
		var msb31 = a >>> 1 | b >>> 1;
		return msb31 << 1 | lsb;
	}
	,bitXOR: function(a,b) {
		var lsb = a & 1 ^ b & 1;
		var msb31 = a >>> 1 ^ b >>> 1;
		return msb31 << 1 | lsb;
	}
	,bitAND: function(a,b) {
		var lsb = a & 1 & (b & 1);
		var msb31 = a >>> 1 & b >>> 1;
		return msb31 << 1 | lsb;
	}
	,addme: function(x,y) {
		var lsw = (x & 65535) + (y & 65535);
		var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
		return msw << 16 | lsw & 65535;
	}
	,hex: function(a) {
		var str = "";
		var hex_chr = "0123456789abcdef";
		var _g = 0;
		while(_g < a.length) {
			var num = a[_g];
			++_g;
			str += hex_chr.charAt(num >> 4 & 15) + hex_chr.charAt(num & 15);
			str += hex_chr.charAt(num >> 12 & 15) + hex_chr.charAt(num >> 8 & 15);
			str += hex_chr.charAt(num >> 20 & 15) + hex_chr.charAt(num >> 16 & 15);
			str += hex_chr.charAt(num >> 28 & 15) + hex_chr.charAt(num >> 24 & 15);
		}
		return str;
	}
	,rol: function(num,cnt) {
		return num << cnt | num >>> 32 - cnt;
	}
	,cmn: function(q,a,b,x,s,t) {
		return this.addme(this.rol(this.addme(this.addme(a,q),this.addme(x,t)),s),b);
	}
	,ff: function(a,b,c,d,x,s,t) {
		return this.cmn(this.bitOR(this.bitAND(b,c),this.bitAND(~b,d)),a,b,x,s,t);
	}
	,gg: function(a,b,c,d,x,s,t) {
		return this.cmn(this.bitOR(this.bitAND(b,d),this.bitAND(c,~d)),a,b,x,s,t);
	}
	,hh: function(a,b,c,d,x,s,t) {
		return this.cmn(this.bitXOR(this.bitXOR(b,c),d),a,b,x,s,t);
	}
	,ii: function(a,b,c,d,x,s,t) {
		return this.cmn(this.bitXOR(c,this.bitOR(b,~d)),a,b,x,s,t);
	}
	,doEncode: function(x) {
		var a = 1732584193;
		var b = -271733879;
		var c = -1732584194;
		var d = 271733878;
		var step;
		var i = 0;
		while(i < x.length) {
			var olda = a;
			var oldb = b;
			var oldc = c;
			var oldd = d;
			step = 0;
			a = this.ff(a,b,c,d,x[i],7,-680876936);
			d = this.ff(d,a,b,c,x[i + 1],12,-389564586);
			c = this.ff(c,d,a,b,x[i + 2],17,606105819);
			b = this.ff(b,c,d,a,x[i + 3],22,-1044525330);
			a = this.ff(a,b,c,d,x[i + 4],7,-176418897);
			d = this.ff(d,a,b,c,x[i + 5],12,1200080426);
			c = this.ff(c,d,a,b,x[i + 6],17,-1473231341);
			b = this.ff(b,c,d,a,x[i + 7],22,-45705983);
			a = this.ff(a,b,c,d,x[i + 8],7,1770035416);
			d = this.ff(d,a,b,c,x[i + 9],12,-1958414417);
			c = this.ff(c,d,a,b,x[i + 10],17,-42063);
			b = this.ff(b,c,d,a,x[i + 11],22,-1990404162);
			a = this.ff(a,b,c,d,x[i + 12],7,1804603682);
			d = this.ff(d,a,b,c,x[i + 13],12,-40341101);
			c = this.ff(c,d,a,b,x[i + 14],17,-1502002290);
			b = this.ff(b,c,d,a,x[i + 15],22,1236535329);
			a = this.gg(a,b,c,d,x[i + 1],5,-165796510);
			d = this.gg(d,a,b,c,x[i + 6],9,-1069501632);
			c = this.gg(c,d,a,b,x[i + 11],14,643717713);
			b = this.gg(b,c,d,a,x[i],20,-373897302);
			a = this.gg(a,b,c,d,x[i + 5],5,-701558691);
			d = this.gg(d,a,b,c,x[i + 10],9,38016083);
			c = this.gg(c,d,a,b,x[i + 15],14,-660478335);
			b = this.gg(b,c,d,a,x[i + 4],20,-405537848);
			a = this.gg(a,b,c,d,x[i + 9],5,568446438);
			d = this.gg(d,a,b,c,x[i + 14],9,-1019803690);
			c = this.gg(c,d,a,b,x[i + 3],14,-187363961);
			b = this.gg(b,c,d,a,x[i + 8],20,1163531501);
			a = this.gg(a,b,c,d,x[i + 13],5,-1444681467);
			d = this.gg(d,a,b,c,x[i + 2],9,-51403784);
			c = this.gg(c,d,a,b,x[i + 7],14,1735328473);
			b = this.gg(b,c,d,a,x[i + 12],20,-1926607734);
			a = this.hh(a,b,c,d,x[i + 5],4,-378558);
			d = this.hh(d,a,b,c,x[i + 8],11,-2022574463);
			c = this.hh(c,d,a,b,x[i + 11],16,1839030562);
			b = this.hh(b,c,d,a,x[i + 14],23,-35309556);
			a = this.hh(a,b,c,d,x[i + 1],4,-1530992060);
			d = this.hh(d,a,b,c,x[i + 4],11,1272893353);
			c = this.hh(c,d,a,b,x[i + 7],16,-155497632);
			b = this.hh(b,c,d,a,x[i + 10],23,-1094730640);
			a = this.hh(a,b,c,d,x[i + 13],4,681279174);
			d = this.hh(d,a,b,c,x[i],11,-358537222);
			c = this.hh(c,d,a,b,x[i + 3],16,-722521979);
			b = this.hh(b,c,d,a,x[i + 6],23,76029189);
			a = this.hh(a,b,c,d,x[i + 9],4,-640364487);
			d = this.hh(d,a,b,c,x[i + 12],11,-421815835);
			c = this.hh(c,d,a,b,x[i + 15],16,530742520);
			b = this.hh(b,c,d,a,x[i + 2],23,-995338651);
			a = this.ii(a,b,c,d,x[i],6,-198630844);
			d = this.ii(d,a,b,c,x[i + 7],10,1126891415);
			c = this.ii(c,d,a,b,x[i + 14],15,-1416354905);
			b = this.ii(b,c,d,a,x[i + 5],21,-57434055);
			a = this.ii(a,b,c,d,x[i + 12],6,1700485571);
			d = this.ii(d,a,b,c,x[i + 3],10,-1894986606);
			c = this.ii(c,d,a,b,x[i + 10],15,-1051523);
			b = this.ii(b,c,d,a,x[i + 1],21,-2054922799);
			a = this.ii(a,b,c,d,x[i + 8],6,1873313359);
			d = this.ii(d,a,b,c,x[i + 15],10,-30611744);
			c = this.ii(c,d,a,b,x[i + 6],15,-1560198380);
			b = this.ii(b,c,d,a,x[i + 13],21,1309151649);
			a = this.ii(a,b,c,d,x[i + 4],6,-145523070);
			d = this.ii(d,a,b,c,x[i + 11],10,-1120210379);
			c = this.ii(c,d,a,b,x[i + 2],15,718787259);
			b = this.ii(b,c,d,a,x[i + 9],21,-343485551);
			a = this.addme(a,olda);
			b = this.addme(b,oldb);
			c = this.addme(c,oldc);
			d = this.addme(d,oldd);
			i += 16;
		}
		return [a,b,c,d];
	}
};
var haxe_io_Bytes = function(data) {
	this.length = data.byteLength;
	this.b = new Uint8Array(data);
	this.b.bufferValue = data;
	data.hxBytes = this;
	data.bytes = this.b;
};
haxe_io_Bytes.__name__ = true;
haxe_io_Bytes.alloc = function(length) {
	return new haxe_io_Bytes(new ArrayBuffer(length));
};
haxe_io_Bytes.ofString = function(s,encoding) {
	var a = [];
	var i = 0;
	while(i < s.length) {
		var c = s.charCodeAt(i++);
		if(55296 <= c && c <= 56319) {
			c = c - 55232 << 10 | s.charCodeAt(i++) & 1023;
		}
		if(c <= 127) {
			a.push(c);
		} else if(c <= 2047) {
			a.push(192 | c >> 6);
			a.push(128 | c & 63);
		} else if(c <= 65535) {
			a.push(224 | c >> 12);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		} else {
			a.push(240 | c >> 18);
			a.push(128 | c >> 12 & 63);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		}
	}
	return new haxe_io_Bytes(new Uint8Array(a).buffer);
};
haxe_io_Bytes.ofData = function(b) {
	var hb = b.hxBytes;
	if(hb != null) {
		return hb;
	}
	return new haxe_io_Bytes(b);
};
haxe_io_Bytes.ofHex = function(s) {
	if((s.length & 1) != 0) {
		throw haxe_Exception.thrown("Not a hex string (odd number of digits)");
	}
	var a = [];
	var i = 0;
	var len = s.length >> 1;
	while(i < len) {
		var high = s.charCodeAt(i * 2);
		var low = s.charCodeAt(i * 2 + 1);
		high = (high & 15) + ((high & 64) >> 6) * 9;
		low = (low & 15) + ((low & 64) >> 6) * 9;
		a.push((high << 4 | low) & 255);
		++i;
	}
	return new haxe_io_Bytes(new Uint8Array(a).buffer);
};
haxe_io_Bytes.fastGet = function(b,pos) {
	return b.bytes[pos];
};
haxe_io_Bytes.prototype = {
	get: function(pos) {
		return this.b[pos];
	}
	,set: function(pos,v) {
		this.b[pos] = v & 255;
	}
	,blit: function(pos,src,srcpos,len) {
		if(pos < 0 || srcpos < 0 || len < 0 || pos + len > this.length || srcpos + len > src.length) {
			throw haxe_Exception.thrown(haxe_io_Error.OutsideBounds);
		}
		if(srcpos == 0 && len == src.b.byteLength) {
			this.b.set(src.b,pos);
		} else {
			this.b.set(src.b.subarray(srcpos,srcpos + len),pos);
		}
	}
	,fill: function(pos,len,value) {
		var _g = 0;
		var _g1 = len;
		while(_g < _g1) {
			var i = _g++;
			this.b[pos++] = value & 255;
		}
	}
	,sub: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) {
			throw haxe_Exception.thrown(haxe_io_Error.OutsideBounds);
		}
		return new haxe_io_Bytes(this.b.buffer.slice(pos + this.b.byteOffset,pos + this.b.byteOffset + len));
	}
	,compare: function(other) {
		var b1 = this.b;
		var b2 = other.b;
		var len = this.length < other.length ? this.length : other.length;
		var _g = 0;
		var _g1 = len;
		while(_g < _g1) {
			var i = _g++;
			if(b1[i] != b2[i]) {
				return b1[i] - b2[i];
			}
		}
		return this.length - other.length;
	}
	,initData: function() {
		if(this.data == null) {
			this.data = new DataView(this.b.buffer,this.b.byteOffset,this.b.byteLength);
		}
	}
	,getDouble: function(pos) {
		if(this.data == null) {
			this.data = new DataView(this.b.buffer,this.b.byteOffset,this.b.byteLength);
		}
		return this.data.getFloat64(pos,true);
	}
	,getFloat: function(pos) {
		if(this.data == null) {
			this.data = new DataView(this.b.buffer,this.b.byteOffset,this.b.byteLength);
		}
		return this.data.getFloat32(pos,true);
	}
	,setDouble: function(pos,v) {
		if(this.data == null) {
			this.data = new DataView(this.b.buffer,this.b.byteOffset,this.b.byteLength);
		}
		this.data.setFloat64(pos,v,true);
	}
	,setFloat: function(pos,v) {
		if(this.data == null) {
			this.data = new DataView(this.b.buffer,this.b.byteOffset,this.b.byteLength);
		}
		this.data.setFloat32(pos,v,true);
	}
	,getUInt16: function(pos) {
		if(this.data == null) {
			this.data = new DataView(this.b.buffer,this.b.byteOffset,this.b.byteLength);
		}
		return this.data.getUint16(pos,true);
	}
	,setUInt16: function(pos,v) {
		if(this.data == null) {
			this.data = new DataView(this.b.buffer,this.b.byteOffset,this.b.byteLength);
		}
		this.data.setUint16(pos,v,true);
	}
	,getInt32: function(pos) {
		if(this.data == null) {
			this.data = new DataView(this.b.buffer,this.b.byteOffset,this.b.byteLength);
		}
		return this.data.getInt32(pos,true);
	}
	,setInt32: function(pos,v) {
		if(this.data == null) {
			this.data = new DataView(this.b.buffer,this.b.byteOffset,this.b.byteLength);
		}
		this.data.setInt32(pos,v,true);
	}
	,getInt64: function(pos) {
		var this1 = new haxe__$Int64__$_$_$Int64(this.getInt32(pos + 4),this.getInt32(pos));
		return this1;
	}
	,setInt64: function(pos,v) {
		this.setInt32(pos,v.low);
		this.setInt32(pos + 4,v.high);
	}
	,getString: function(pos,len,encoding) {
		if(pos < 0 || len < 0 || pos + len > this.length) {
			throw haxe_Exception.thrown(haxe_io_Error.OutsideBounds);
		}
		var s = "";
		var b = this.b;
		var fcc = _$String_String_$Impl_$.fromCharCode;
		var i = pos;
		var max = pos + len;
		while(i < max) {
			var c = b[i++];
			if(c < 128) {
				if(c == 0) {
					break;
				}
				s += fcc(c);
			} else if(c < 224) {
				s += fcc((c & 63) << 6 | b[i++] & 127);
			} else if(c < 240) {
				var c2 = b[i++];
				s += fcc((c & 31) << 12 | (c2 & 127) << 6 | b[i++] & 127);
			} else {
				var c21 = b[i++];
				var c3 = b[i++];
				var u = (c & 15) << 18 | (c21 & 127) << 12 | (c3 & 127) << 6 | b[i++] & 127;
				s += fcc((u >> 10) + 55232);
				s += fcc(u & 1023 | 56320);
			}
		}
		return s;
	}
	,readString: function(pos,len) {
		return this.getString(pos,len);
	}
	,toString: function() {
		return this.getString(0,this.length);
	}
	,toHex: function() {
		var s_b = "";
		var chars = [];
		var str = "0123456789abcdef";
		var _g = 0;
		var _g1 = str.length;
		while(_g < _g1) {
			var i = _g++;
			chars.push(HxOverrides.cca(str,i));
		}
		var _g = 0;
		var _g1 = this.length;
		while(_g < _g1) {
			var i = _g++;
			var c = this.b[i];
			s_b += String.fromCodePoint(chars[c >> 4]);
			s_b += String.fromCodePoint(chars[c & 15]);
		}
		return s_b;
	}
	,getData: function() {
		return this.b.bufferValue;
	}
};
var haxe_io_Encoding = $hxEnums["haxe.io.Encoding"] = { __ename__:true,__constructs__:null
	,UTF8: {_hx_name:"UTF8",_hx_index:0,__enum__:"haxe.io.Encoding",toString:$estr}
	,RawNative: {_hx_name:"RawNative",_hx_index:1,__enum__:"haxe.io.Encoding",toString:$estr}
};
haxe_io_Encoding.__constructs__ = [haxe_io_Encoding.UTF8,haxe_io_Encoding.RawNative];
var haxe_io_Error = $hxEnums["haxe.io.Error"] = { __ename__:true,__constructs__:null
	,Blocked: {_hx_name:"Blocked",_hx_index:0,__enum__:"haxe.io.Error",toString:$estr}
	,Overflow: {_hx_name:"Overflow",_hx_index:1,__enum__:"haxe.io.Error",toString:$estr}
	,OutsideBounds: {_hx_name:"OutsideBounds",_hx_index:2,__enum__:"haxe.io.Error",toString:$estr}
	,Custom: ($_=function(e) { return {_hx_index:3,e:e,__enum__:"haxe.io.Error",toString:$estr}; },$_._hx_name="Custom",$_.__params__ = ["e"],$_)
};
haxe_io_Error.__constructs__ = [haxe_io_Error.Blocked,haxe_io_Error.Overflow,haxe_io_Error.OutsideBounds,haxe_io_Error.Custom];
var haxe_iterators_ArrayIterator = function(array) {
	this.current = 0;
	this.array = array;
};
haxe_iterators_ArrayIterator.__name__ = true;
haxe_iterators_ArrayIterator.prototype = {
	hasNext: function() {
		return this.current < this.array.length;
	}
	,next: function() {
		return this.array[this.current++];
	}
};
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(o.__enum__) {
			var e = $hxEnums[o.__enum__];
			var con = e.__constructs__[o._hx_index];
			var n = con._hx_name;
			if(con.__params__) {
				s = s + "\t";
				return n + "(" + ((function($this) {
					var $r;
					var _g = [];
					{
						var _g1 = 0;
						var _g2 = con.__params__;
						while(true) {
							if(!(_g1 < _g2.length)) {
								break;
							}
							var p = _g2[_g1];
							_g1 = _g1 + 1;
							_g.push(js_Boot.__string_rec(o[p],s));
						}
					}
					$r = _g;
					return $r;
				}(this))).join(",") + ")";
			} else {
				return n;
			}
		}
		if(((o) instanceof Array)) {
			var str = "[";
			s += "\t";
			var _g = 0;
			var _g1 = o.length;
			while(_g < _g1) {
				var i = _g++;
				str += (i > 0 ? "," : "") + js_Boot.__string_rec(o[i],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( _g ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		var k = null;
		for( k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) {
			str += ", \n";
		}
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "string":
		return o;
	default:
		return String(o);
	}
};
var js_lib__$ArrayBuffer_ArrayBufferCompat = function() { };
js_lib__$ArrayBuffer_ArrayBufferCompat.__name__ = true;
js_lib__$ArrayBuffer_ArrayBufferCompat.sliceImpl = function(begin,end) {
	var u = new Uint8Array(this,begin,end == null ? null : end - begin);
	var resultArray = new Uint8Array(u.byteLength);
	resultArray.set(u);
	return resultArray.buffer;
};
var window_events_Event = function(type) {
	this.currentTarget = null;
	this.target = null;
	this.cancelable = false;
	this.cancelBubble = false;
	this.type = type;
};
window_events_Event.__name__ = true;
var window_events_DeviceMotionEvent = function() {
	window_events_Event.call(this,"devicemotion");
};
window_events_DeviceMotionEvent.__name__ = true;
window_events_DeviceMotionEvent.__super__ = window_events_Event;
window_events_DeviceMotionEvent.prototype = $extend(window_events_Event.prototype,{
});
var window_events_TouchEvent = function(type) {
	this.changedTouches = [];
	this.targetTouches = [];
	this.touches = [];
	window_events_Event.call(this,type);
	this.target = window.canvas;
	this.currentTarget = window.canvas;
};
window_events_TouchEvent.__name__ = true;
window_events_TouchEvent.__super__ = window_events_Event;
window_events_TouchEvent.prototype = $extend(window_events_Event.prototype,{
	preventDefault: function() {
	}
});
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $global.$haxeUID++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = m.bind(o); o.hx__closures__[m.__id__] = f; } return f; }
$global.$haxeUID |= 0;
if(typeof(performance) != "undefined" ? typeof(performance.now) == "function" : false) {
	HxOverrides.now = performance.now.bind(performance);
}
if( String.fromCodePoint == null ) String.fromCodePoint = function(c) { return c < 0x10000 ? String.fromCharCode(c) : String.fromCharCode((c>>10)+0xD7C0)+String.fromCharCode((c&0x3FF)+0xDC00); }
String.__name__ = true;
Array.__name__ = true;
js_Boot.__toStr = ({ }).toString;
if(ArrayBuffer.prototype.slice == null) {
	ArrayBuffer.prototype.slice = js_lib__$ArrayBuffer_ArrayBufferCompat.sliceImpl;
}
Context2d.CONTEXT2D_COUNT = 0;
HTMLImageElement.IMAGE_COUNT = 0;
HTMLUtils.START = "wxfile://";
HTMLUtils.cacheExt = ["png","json","mp3","xml","jpg"];
HTMLUtils._isCanCache = true;
HTMLUtils.tempFileMaps = new haxe_ds_StringMap();
WebSocket.CONNECTING = 0;
WebSocket.OPEN = 1;
WebSocket.CLOSING = 2;
WebSocket.CLOSED = 3;
Window.canvas = new Canvas();
Window.startTouch = [];
XMLHttpRequest.UNSEND = 0;
XMLHttpRequest.OPENED = 1;
XMLHttpRequest.HEADERS_RECEIVED = 2;
XMLHttpRequest.LOADING = 3;
XMLHttpRequest.DONE = 4;
Window.main();
})(typeof exports != "undefined" ? exports : typeof window != "undefined" ? window : typeof self != "undefined" ? self : this, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);
