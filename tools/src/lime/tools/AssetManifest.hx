package lime.tools;

import haxe.Serializer;
#if !macro
import haxe.Json;
#end

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class AssetManifest
{
	public var assets:Array<Dynamic>;
	public var libraryArgs:Array<String>;
	public var libraryType:String;
	public var name:String;
	public var rootPath:String;
	public var version:Int;

	public function new()
	{
		assets = [];
		libraryArgs = [];
		version = 2;
	}

	public function serialize():String
	{
		#if !macro
		var manifestData:Dynamic = {};
		manifestData.version = version;
		manifestData.libraryType = libraryType;
		manifestData.libraryArgs = libraryArgs;
		manifestData.name = name;
		manifestData.assets = Serializer.run(assets);
		manifestData.rootPath = rootPath;

		return Json.stringify(manifestData);
		#else
		return null;
		#end
	}
}
