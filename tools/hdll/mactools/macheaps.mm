#import <Cocoa/Cocoa.h>

#define HL_NAME(n) iostools_##n

#include <hl.h>

HL_PRIM float HL_NAME(get_pixel_ratio)()
{
    return [NSScreen mainScreen].backingScaleFactor;
}

NSOpenPanel* _panel;

int state = -1;

HL_PRIM void HL_NAME(open_select_dir)()
{   
    state = -1;
    _panel = [NSOpenPanel openPanel];
    [_panel setAllowsMultipleSelection:FALSE];//是否允许多选file
    [_panel beginWithCompletionHandler:^(NSModalResponse result) {
        // 构造一个Dynamic数组，传参只有1，所以这里只需要长度1
        if(result == NSModalResponseOK){
            state = 0;
            // 获取路径
            // path = [panel.URLs[0].path UTF8String];
            // char *b = new char((strlen(c) + 1) * sizeof(char));
            // strcpy(b,c);
            // path = b;
        }else{
            state = 1;
        }
    }];
}

HL_PRIM int HL_NAME(read_open_select_dir_state)()
{   
    return state;
}

HL_PRIM vbyte* HL_NAME(read_open_select_file_path)()
{   
    // return (vbyte*)path;
    if(_panel == nil)
        return nil;
    const char* path = [_panel.URLs[0].path UTF8String];
    printf("%s\n",path);
    _panel = nil;
    return (vbyte*)path;
}

DEFINE_PRIM(_F32, get_pixel_ratio, _NO_ARG);
DEFINE_PRIM(_VOID, open_select_dir, _NO_ARG);
DEFINE_PRIM(_I32, read_open_select_dir_state, _NO_ARG);
DEFINE_PRIM(_BYTES, read_open_select_file_path, _NO_ARG);
