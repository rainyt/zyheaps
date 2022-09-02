package zygame.macro;

import haxe.macro.ExprTools;
#if macro
import haxe.macro.Expr.Function;
import haxe.macro.Expr.FieldType;
import sys.io.File;
import haxe.macro.Context;
import haxe.macro.Expr;

class AutoXMLBuilder {
	@:persistent public static var firstProjectData(get, never):AssetsProject;
	@:persistent private static var _firstProjectData:AssetsProject;

	static function get_firstProjectData():AssetsProject {
		if (_firstProjectData == null) {
			_firstProjectData = new AssetsProject();
		}
		return _firstProjectData;
	}

	public static function build(xmlid:String, parent:String = null):Array<Field> {
		trace("parent=", parent);
		var fields = Context.getBuildFields();
		var xml:Xml = Xml.parse(File.getContent(firstProjectData.assetsPath.get(xmlid + ".xml")));
		var ids:Map<String, String> = [];
		var assets:Array<FileType> = [];
		parserIds(xml, ids, assets);
		var parentId = parent != null ? parent : null;
		var className = Context.getLocalClass().get().superClass.t.toString();
		if (className == "zygame.display.LoaderXMLScene") {
			// 支持载入的场景
			var new_func = fields.filter((f) -> f.name == "new")[0];
			if (new_func != null) {
				// 如果new已经存在，则要重写super
				switch new_func.kind {
					case FFun(f):
						switch f.expr.expr {
							case EBlock(exprs):
								for (index => e in exprs) {
									var code = ExprTools.toString(e);
									if (code.indexOf("super(") != -1) {
										switch e.expr {
											case ECall(e, params):
												var path = firstProjectData.assetsRenamePath.get(xmlid + ".xml");
												params[0] = macro $v{path};
											default:
										}
										break;
									}
								}
							default:
						}
					default:
						// 其他忽略，不会出现非方法的状态
				}
			} else {
				var path = firstProjectData.assetsRenamePath.get(xmlid + ".xml");
				var on_new:Function = {
					expr: macro super($v{path}, null),
					ret: macro:Void,
					args: []
				}
				new_func = {
					name: "new",
					access: [APublic],
					kind: FieldType.FFun(on_new),
					pos: Context.currentPos()
				}
				fields.push(new_func);
			}
			// todo 这里要实现资源载入支持
			var textures:Array<{png:String, xml:String}> = [];
			var files:Array<String> = [];
			for (type in assets) {
				switch type {
					case FILE(file):
						// 普通文件
						var p = firstProjectData.assetsRenamePath.get(file);
						if (files.indexOf(p) == -1)
							files.push(p);
					case ATLAS(png, xml):
						// 精灵图
						var f = textures.filter((data) -> data.png == png && data.xml == xml);
						if (f.length == 0)
							textures.push({
								png: firstProjectData.assetsRenamePath.get(png),
								xml: firstProjectData.assetsRenamePath.get(xml)
							});
				}
			}
			// var spines:Array<
			var on_load:Function = {
				expr: macro {
					var textures:Array<{png:String, xml:String}> = $v{textures};
					var files:Array<String> = $v{files};
					// var spines:Array<{png:String, atlas:String}> = $v{spines};
					for (f in files) {
						if (zygame.res.AssetsBuilder.getBitmapDataTile(zygame.utils.StringUtils.getName(f)) == null)
							this.assets.loadFile(f);
					}
					// for (s in spines) {
					// 	if (zygame.components.ZBuilder.getBaseTextureAtlas(zygame.utils.StringUtils.getName(s.png)) == null) {
					// 		this.$bindBuilder.loadSpine([s.png], s.atlas);
					// 		// this.$bindBuilder.loadFiles([s.json]);
					// 	}
					// }
					for (item in textures) {
						if (zygame.res.AssetsBuilder.getAtlas(zygame.utils.StringUtils.getName(item.png)) == null)
							this.assets.loadAtlas(item.png, item.xml);
					}
				},
				ret: macro:Void,
				args: []
			}
			var load_func = {
				name: "_onLoad",
				access: [AOverride],
				kind: FieldType.FFun(on_load),
				pos: Context.currentPos()
			}
			fields.push(load_func);
		} else {
			// 普通对象
			var onInit = fields.filter((f) -> f.name == "onInit")[0];
			if (onInit != null) {
				// 当存在onInit时，则在onInit的第一行添加构造函数
				switch onInit.kind {
					case FFun(f):
						switch f.expr.expr {
							case EBlock(exprs):
								if (parentId != null) {
									exprs.insert(0, macro {
										if (this.ids == null)
											this.ids = [];
										zygame.res.XMLBuilder.parserFromId($v{xmlid}, this.$parentId, this.ids);
									});
								} else {
									exprs.insert(0, macro zygame.res.XMLBuilder.parserFromId($v{xmlid}, this));
								}
							default:
						}
					default:
						// 其他忽略，不会出现非方法的状态
				}
			} else {
				var on_init:Function = {
					expr: if (parentId != null) {
						macro {
							super.onInit();
							if (this.ids == null)
								this.ids = [];
							zygame.res.XMLBuilder.parserFromId($v{xmlid}, this.$parentId, this.ids);
						}
					} else {
						macro {
							super.onInit();
							zygame.res.XMLBuilder.parserFromId($v{xmlid}, this);
						}
					},
					ret: macro:Void,
					args: []
				}
				// 不存在时，则自定义一个
				fields.push({
					name: "onInit",
					access: [AOverride],
					kind: FieldType.FFun(on_init),
					pos: Context.currentPos()
				});
			}
		}
		// 绑定ids映射
		for (key => value in ids) {
			var t = value.indexOf(".") == -1 ? TPath({
				pack: ["zygame", "display"],
				name: value
			}) : toTPath(value);
			fields.push({
				name: key,
				access: [APublic],
				kind: FieldType.FProp("get", "null", t),
				pos: Context.currentPos()
			});
			var get_func:Function = {
				expr: macro return cast ids.get($v{key}),
				ret: t,
				args: []
			}
			fields.push({
				name: "get_" + key,
				access: [APrivate, AInline],
				kind: FieldType.FFun(get_func),
				pos: Context.currentPos()
			});
		}
		return fields;
	}

	private static function toTPath(value:String):Dynamic {
		var array = value.split(".");
		var valueName = array.pop();
		return TPath({
			pack: array,
			name: valueName
		});
	}

	/**
	 * 解析IDS
	 * @param xml 
	 * @param ids 
	 */
	public static function parserIds(xml:Xml, ids:Map<String, String>, array:Array<FileType>):Void {
		xml = xml.nodeType == Document ? xml.firstElement() : xml;
		var id:String = xml.get("id");
		var src:String = xml.get("src");
		if (id != null) {
			ids.set(id, xml.nodeName);
		}
		if (src != null) {
			switch (xml.nodeName) {
				default:
					if (src.indexOf(":") != -1) {
						// 精灵图
						var arr = src.split(":");
						array.push(ATLAS(arr[0] + ".png", arr[0] + ".xml"));
					} else {
						// 单个图片
						if (firstProjectData.assetsRenamePath.exists(src + ".png"))
							array.push(FILE(src + ".png"));
						else {
							array.push(FILE(src + ".jpg"));
						}
					}
			}
		}
		for (item in xml.elements()) {
			parserIds(item, ids, array);
		}
	}
}

enum FileType {
	FILE(file:String);
	ATLAS(png:String, xml:String);
}
#end
