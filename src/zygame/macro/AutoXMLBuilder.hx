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

	public static function build(xmlid:String):Array<Field> {
		var fields = Context.getBuildFields();
		var xml:Xml = Xml.parse(File.getContent(firstProjectData.assetsPath.get(xmlid + ".xml")));
		var ids:Map<String, String> = [];
		parserIds(xml, ids);
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
		} else {
			// 普通对象
			var onInit = fields.filter((f) -> f.name == "onInit")[0];
			if (onInit != null) {
				// 当存在onInit时，则在onInit的第一行添加构造函数
				switch onInit.kind {
					case FFun(f):
						switch f.expr.expr {
							case EBlock(exprs):
								exprs.insert(0, macro zygame.res.XMLBuilder.parserFromId($v{xmlid}, this));
							default:
						}
					default:
						// 其他忽略，不会出现非方法的状态
				}
			} else {
				var on_init:Function = {
					expr: macro zygame.res.XMLBuilder.parserFromId($v{xmlid}, this),
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
			var t = TPath({
				pack: ["zygame", "display"],
				name: value
			});
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

	/**
	 * 解析IDS
	 * @param xml 
	 * @param ids 
	 */
	public static function parserIds(xml:Xml, ids:Map<String, String>):Void {
		xml = xml.nodeType == Document ? xml.firstElement() : xml;
		if (xml.get("id") != null) {
			ids.set(xml.get("id"), xml.nodeName);
		}
		for (item in xml.elements()) {
			parserIds(item, ids);
		}
	}
}
#end
