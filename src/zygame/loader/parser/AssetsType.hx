package zygame.loader.parser;

enum abstract AssetsType(Int) to Int from Int {
	public var BITMAP; // 位图：png/jpg/jpeg
	public var BITMAP_TILE; // 位图tile，一般由BITMAP自动生成
	public var BYTES;
	public var ATLAS; // 精灵图表：xml/png
	public var JSON; // JSON动态数据：json
	public var XML; // XML动态数据：xml
	public var SOUND; // 音频：ogg/mp3
	// public var CUSTOM = 1; // 自定义：一般用于扩展解析器功能使用
	// public var DYNAMICTEXTUREATLAS = 4; // 动态精灵图表：xml/png
	// public var ZIP = 5; // 压缩资源载入：zip
	// public var CDB = 7; // CDBData动态数据：cdb
	// public var MUSIC = 9; // 背景音乐：ogg/mp3
	// public var SWF = 10; // SWFLITE：zip/bundle
	// public var TEXT = 11; // 字符串数据：txt
	// public var FNT = 12; // 纹理文本：png/fnt
	// public var PROGRESS = 14; // 不是资源，一般只用来传递进度
	// public var SPINE = 15; // Spine纹理资源
	// public var OBJ3D = 16; // 3DLoader资源
	// public var SPARTICLE = 17; // Sprticle3D粒子特效
	// public var LDTK = 18; // LDTK编辑器的地图数据
}
