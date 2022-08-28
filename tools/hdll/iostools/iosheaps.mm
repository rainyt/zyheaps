// #include <UIKit/UIKit.h>
#import <Cocoa/Cocoa.h>

#define HL_NAME(n) iostools_##n

#include <hl.h>
#include <stdlib.h>
#include <_std/String.h>
#include <string.h>
HL_PRIM float HL_NAME(get_pixel_ratio)()
{
    return [UIScreen mainScreen].nativeScale;
}

DEFINE_PRIM(_F32, get_pixel_ratio,_NO_ARG);
