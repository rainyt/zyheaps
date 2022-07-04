package project;

import hxp.Haxelib;
import sys.io.File;
import hxp.HXML;
import lime.tools.HXProject;

using StringTools;

class ProjectHXMLParser extends HXProject {
	public function new(path:String) {
		super();
		var hxml:HXML = File.getContent(path);
		var hxmlStr:String = hxml;
		var hxmlArray:Array<String> = hxmlStr.split("\n");
		for (data in hxmlArray) {
			trace(data);
			if (data.indexOf("-D") == 0 || data.indexOf("--define") == 0) {
				var d = parserDefine(data);
				this.defines.set(d.name, d.value);
			} else if (data.indexOf("--library") == 0 || data.indexOf("-lib") == 0) {
				var lib = parserLibray(data);
				var hlib = new Haxelib(lib.name, lib.version == null ? "" : lib.version);
				this.haxelibs.push(hlib);
				var includeProject = HXProject.fromHaxelib(hlib, defines);
				if (includeProject != null) {
					for (ndll in includeProject.ndlls) {
						if (ndll.haxelib == null) {
							ndll.haxelib = hlib;
						}
					}
					merge(includeProject);
				}
			} else if (data.indexOf("--class-path") == 0 || data.indexOf("-cp") == 0) {
				this.sources.push(this.parserRootString(data));
			} else if (data.indexOf("-main") == 0 || data.indexOf("--main") == 0) {
				hxml.main = parserRootString(data);
				this.app.main = hxml.main;
				this.app.file = hxml.main;
				this.meta.title = hxml.main;
			}
		}
	}

	private function parserRootString(data:String):String {
		return data.substr(data.indexOf(" ") + 1);
	}

	private function parserLibray(data:String):HxmlLib {
		data = data.substr(data.indexOf(" ") + 1);
		if (data.indexOf(":") != -1) {
			var args = data.split(":");
			return {
				name: args[0],
				version: args[1]
			};
		} else {
			return {
				name: data
			};
		}
	}

	private function parserDefine(data:String):HxmlDefine {
		data = data.substr(data.indexOf(" ") + 1);
		if (data.indexOf("=") != -1) {
			var args = data.split("=");
			return {
				name: args[0],
				value: args[1]
			};
		} else {
			return {
				name: data
			};
		}
	}
}

typedef HxmlLib = {
	name:String,
	?version:String
}

typedef HxmlDefine = {
	name:String,
	?value:String
}
