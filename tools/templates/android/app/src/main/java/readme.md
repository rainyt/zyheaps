# Java files

The entrypoint to this Android App is [io/heaps/android/HeapsActivity.java](io/heaps/android/HeapsActivity.java). It extends [org/libsdl/app/SDLActivity.java](org/libsdl/app/SDLActivity.java) and basically just runs the `runHL()` JNI function.

[org/libsdl/app/SDLActivity.java](org/libsdl/app/SDLActivity.java) deals with a bunch of the SDL stuff.  

Add your own classes as necessary.