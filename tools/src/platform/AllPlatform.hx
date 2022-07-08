package platform;

class AllPlatform {

	/**
	 * 支持的平台
	 */
	public static var platforms:Array<Class<BasePlatform>> = [Wechat, Android, Html5, Ios, Mac, Window];

	/** 开始构造 **/
	public static function build(c:Class<BasePlatform>):Void {}
}
