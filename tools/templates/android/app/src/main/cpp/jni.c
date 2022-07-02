#include <jni.h>
#include <android/asset_manager_jni.h>
#include <android/asset_manager.h>
#include <android/log.h>
#include <stdlib.h>
#include <hl.h>
#include "out/_std/String.h"

#define JNI_TAG "JNI"

extern int main(int argc, char *argv[]); // assuming that haxe->hl/c entry point is included (which includes hlc_main.c which includes the main function)

AAssetManager * _assetsManager;

int _tmpSize;

char* _JString2CStr(JNIEnv* env, jstring jstr) {
    char* rtn = NULL;
    jclass clsstring = (*env)->FindClass(env, "java/lang/String");
    jstring strencode = (*env)->NewStringUTF(env,"GB2312");
    jmethodID mid = (*env)->GetMethodID(env, clsstring, "getBytes", "(Ljava/lang/String;)[B");
    jbyteArray barr = (jbyteArray)(*env)->CallObjectMethod(env, jstr, mid, strencode); // String .getByte("GB2312");
    jsize alen = (*env)->GetArrayLength(env, barr);
    jbyte* ba = (*env)->GetByteArrayElements(env, barr, JNI_FALSE);
    if(alen > 0) {
        rtn = (char*)malloc(alen+1); //"\0"
        memcpy(rtn, ba, alen);
        rtn[alen]=0;
    }
    (*env)->ReleaseByteArrayElements(env, barr, ba,0);
    return rtn;
}

JNIEXPORT int JNICALL Java_org_haxe_HashLinkActivity_startHL(JNIEnv* env, jclass cls) {
    return main(0, NULL);
}

/** 初始Assets */
JNIEXPORT void JNICALL Java_org_haxe_HashLinkActivity_initAssets(JNIEnv *env, jclass type, jobject assetManager, jstring strDir_) {
    __android_log_print(ANDROID_LOG_VERBOSE, JNI_TAG,"initAssets");
    _assetsManager = AAssetManager_fromJava(env, assetManager);
}

/** 获取创建的副本大小 */
JNIEXPORT jint JNICALL Java_org_haxe_HashLinkActivity_tmpSize() {
    return _tmpSize;
}

/** 通过路径读取assets资源 */
JNIEXPORT jbyteArray JNICALL Java_org_haxe_HashLinkActivity_getAssetBytes(String path){
    char* utf8path = hl_to_utf8(path->bytes);
    AAsset* asset = AAssetManager_open(_assetsManager, utf8path, AASSET_MODE_UNKNOWN);
    if (NULL != asset)
    {
        off_t bufSize = AAsset_getLength(asset);
        // vbyte *pBuf = (vbyte *) malloc(bufSize + 1);
        vbyte *pBuf = (vbyte *) hl_gc_alloc_noptr(bufSize + 1);
//        memset(pBuf, 0, bufSize + 1);
        _tmpSize = AAsset_read(asset, pBuf, bufSize);
//        free(pBuf);
        AAsset_close(asset);
        return pBuf;
    }
    else
    {
        __android_log_print(ANDROID_LOG_ERROR, JNI_TAG, "Assets load fail:%s", utf8path);
        return NULL;
    }
}
