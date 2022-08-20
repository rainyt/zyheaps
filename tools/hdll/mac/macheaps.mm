#import <Cocoa/Cocoa.h>

#define HL_NAME(n) iostools_##n

#include <hl.h>

HL_PRIM float HL_NAME(get_pixel_ratio)()
{
    return [NSScreen mainScreen].backingScaleFactor;
}

HL_PRIM void HL_NAME(open_select_dir)(vclosure* render_fn)
{   
    // 由于回调是异步的，先标记
    hl_add_root(&render_fn);
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setAllowsMultipleSelection:FALSE];//是否允许多选file
    [panel beginWithCompletionHandler:^(NSModalResponse result) {
        if(result == NSModalResponseOK){
            // 构造一个Dynamic数组，传参只有1，所以这里只需要长度1
            vdynamic* args[1];
            vdynamic* param = (vdynamic*)hl_alloc_dynobj();
            // 获取路径
            const char* str = [panel.URLs[0].path UTF8String];
            // 转回haxe认识的字符编码
            hl_dyn_setp(param, hl_hash_utf8("path"), &hlt_bytes, (vdynamic*)(str));
            args[0] = param;
            // 回调
            hl_dyn_call(render_fn, args, 1);
            // 回调使用完毕，可以移除
            hl_remove_root(render_fn);
        }
    }];
}

DEFINE_PRIM(_F32, get_pixel_ratio,_NO_ARG);
DEFINE_PRIM(_VOID, open_select_dir, _FUN(_VOID, _DYN));
