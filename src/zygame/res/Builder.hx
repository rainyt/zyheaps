package zygame.res;

/**
 * 一个UI构造器，内置一些构造的基础配置
 */
class Builder<T> {
	/**
	 * UI类型定义
	 */
	public var classDefine:Map<String, Class<Dynamic>> = [];

	/**
	 * 构造时的自定义实现
	 */
	public var createFunc:Map<String, T->Dynamic> = [];

	public function new() {}

	/**
	 * 追加一个类型绑定
	 * @param c 
	 */
	public function addClass(c:Class<Dynamic>, create:T->Dynamic = null):Void {
		var name = Type.getClassName(c);
		var array = name.split(".");
		var cname = array[array.length - 1];
		classDefine.set(cname, c);
		if (create != null)
			createFunc.set(cname, create);
	}

	/**
	 * 创建类型的单例，可以通过Box这种简写获取正确的类型对象
	 * @param type 
	 * @param array 
	 * @return Dynamic
	 */
	public function createInstance(type:String, data:Dynamic, array:Array<Dynamic> = null):Dynamic {
		if (createFunc.exists(type)) {
			return createFunc.get(type)(data);
		}
		var c = classDefine.get(type);
		if (c == null) {
			c = Type.resolveClass(type);
		}
		return Type.createInstance(c, array == null ? [] : array);
	}
}
