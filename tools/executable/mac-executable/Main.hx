class Main {
	static function main() {
		// BASEDIR=$(dirname "$0")
		// cd "$BASEDIR"
		// export DYLD_LIBRARY_PATH=../Frameworks
		// ./hl
		var path = Sys.programPath();
		path = path.substr(0, path.lastIndexOf("/") + 1);
		trace("Run", path);
		var DYLD_LIBRARY_PATH = "../Frameworks";
		Sys.putEnv("DYLD_LIBRARY_PATH", DYLD_LIBRARY_PATH);
		trace("DYLD_LIBRARY_PATH=", DYLD_LIBRARY_PATH);
		Sys.setCwd(path);
		Sys.command("export DYLD_LIBRARY_PATH=" + DYLD_LIBRARY_PATH + "\n" + "./hl");
	}
}
