# C Libraries

Much of this code comes from other sources.
- [hashlink](https://github.com/HaxeFoundation/hashlink)
- [heaps](https://github.com/HeapsIO/heaps)
- [libjpeg-turbo](https://github.com/openstf/android-libjpeg-turbo.git)
- [openal-soft](https://github.com/kcat/openal-soft.git)
- [sdl](https://github.com/spurious/SDL-mirror.git)

Are all submodules from their various repos.  They should be all on commits that work, and you can update them with newer code at your own discretion.  It will probably break things.

`openal-nativetools` I copied directly from https://github.com/HeapsIO/heaps-android.

`jni.c` contains the `startHL()` function that the Java class `io.heaps.android.HeapsActivity` calls.

The `out/` directory contains the haxe project compiled to C.  There's some more info about that [there](../haxe).