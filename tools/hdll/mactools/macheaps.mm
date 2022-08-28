#import <Cocoa/Cocoa.h>

#define HL_NAME(n) iostools_##n

#include <hl.h>

HL_PRIM float HL_NAME(get_pixel_ratio)()
{
    return [NSScreen mainScreen].backingScaleFactor;
}

const char* path;

int state = -1;

HL_PRIM void HL_NAME(open_select_dir)()
{   
    state = -1;
    path = nil;
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setAllowsMultipleSelection:FALSE];//是否允许多选file
    [panel beginWithCompletionHandler:^(NSModalResponse result) {
        // 构造一个Dynamic数组，传参只有1，所以这里只需要长度1
        if(result == NSModalResponseOK){
            state = 0;
            // 获取路径
            const char * c = [panel.URLs[0].path UTF8String];
            char *b = new char((strlen(c) + 1) * sizeof(char));
            strcpy(b,c);
            path = b;
        }else{
            state = 1;
        }
    }];
}

HL_PRIM vdynamic* HL_NAME(read_open_select_dir_state)()
{   
    vdynamic *obj = (vdynamic*) hl_alloc_dynobj();
    hl_dyn_seti(obj, hl_hash_utf8("state"), &hlt_i32, state);
    hl_dyn_setp(obj, hl_hash_utf8("path"), &hlt_bytes,(vbyte*) path);
    hl_remove_root(&path);
    return obj;
}

DEFINE_PRIM(_F32, get_pixel_ratio, _NO_ARG);
DEFINE_PRIM(_VOID, open_select_dir, _NO_ARG);
DEFINE_PRIM(_DYN, read_open_select_dir_state, _NO_ARG);
