package org.haxe;

import org.libsdl.app.SDLActivity;
import android.app.Activity;
import android.content.Context;
import android.content.res.AssetManager;
import android.os.Bundle;
import android.util.Log;

public class HashLinkActivity extends SDLActivity {
    private static HashLinkActivity instance;
    public static native int startHL();
    public native static void initAssets(AssetManager assetManager, String strDir);

    @Override
    protected String getMainFunction() {
        return "main";
    }

    @Override
    protected void onCreate(Bundle state) {
        super.onCreate(state);
        instance = this;
        // 初始化Assets对象
        initAssets(getAssets(),"");
    }

    @Override
    protected String[] getLibraries() {
        return new String[]{
                "openal",
                "SDL2",
                "heapsapp"
        };
    }

    protected void run() {
        super.run();
        Log.i("HL", "Hashlink startHL");
        // this.startHL();
    }

    public static Context getContext() {
        return instance.getApplicationContext();
    }
}
