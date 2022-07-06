package platform;

class AllPlatform {
	public static var platforms:Array<Class<BasePlatform>> = [Wechat, Android, Html5, Ios, Mac];

	/** 开始构造 **/
	public static function build(c:Class<BasePlatform>):Void {}
}
