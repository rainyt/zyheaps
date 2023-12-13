cmake_minimum_required(VERSION 3.1)

project(heapsapp)

add_definitions(-DANDROID_PLATFORM=android-24)

include_directories(hashlink/src)
include_directories(hashlink/pcre)

# LibHL

file(GLOB libhl
		hashlink/src/std/*.c
		hashlink/src/alloc.c
		hashlink/src/gc.c
		)
list(REMOVE_ITEM libhl ${CMAKE_CURRENT_SOURCE_DIR}/hashlink/src/std/debug.c)

file(GLOB pcre
    include hashlink/include/pcre/pcre2_auto_possess.c
    include hashlink/include/pcre/pcre2_chartables.c
    include hashlink/include/pcre/pcre2_compile.c
    include hashlink/include/pcre/pcre2_config.c
    include hashlink/include/pcre/pcre2_context.c
    include hashlink/include/pcre/pcre2_convert.c
    include hashlink/include/pcre/pcre2_dfa_match.c
    include hashlink/include/pcre/pcre2_error.c
    include hashlink/include/pcre/pcre2_extuni.c
    include hashlink/include/pcre/pcre2_find_bracket.c
    include hashlink/include/pcre/pcre2_jit_compile.c
    include hashlink/include/pcre/pcre2_maketables.c
    include hashlink/include/pcre/pcre2_match_data.c
    include hashlink/include/pcre/pcre2_match.c
    include hashlink/include/pcre/pcre2_newline.c
    include hashlink/include/pcre/pcre2_ord2utf.c
    include hashlink/include/pcre/pcre2_pattern_info.c
    include hashlink/include/pcre/pcre2_script_run.c
    include hashlink/include/pcre/pcre2_serialize.c
    include hashlink/include/pcre/pcre2_string_utils.c
    include hashlink/include/pcre/pcre2_study.c
    include hashlink/include/pcre/pcre2_substitute.c
    include hashlink/include/pcre/pcre2_substring.c
    include hashlink/include/pcre/pcre2_tables.c
    include hashlink/include/pcre/pcre2_ucd.c
    include hashlink/include/pcre/pcre2_valid_utf.c
    include hashlink/include/pcre/pcre2_xclass.c
)

file(GLOB mbedtls hashlink/include/mbedtls/library/*.c)

add_library(hl STATIC
		${pcre}
		${libhl}
		${mbedtls}
		hashlink/src/std/sys_android.c
		hashlink/libs/ssl/ssl.c
		)

target_include_directories(hl PRIVATE hashlink/include/pcre)
target_include_directories(hl PRIVATE hashlink/include/mbedtls/include)
target_link_libraries(hl log)
target_compile_definitions(hl PRIVATE _USRDLL LIBHL_EXPORTS HAVE_CONFIG_H PCRE2_CODE_UNIT_WIDTH=16)

# FMT

set(TJ_LIB ${CMAKE_CURRENT_SOURCE_DIR}/libjpeg-turbo/obj/local/${ANDROID_ABI}/libjpeg-turbo.a)
add_custom_target(turbojpeg
		${ANDROID_NDK}/ndk-build APP_ABI=${ANDROID_ABI} APP_PLATFORM=${ANDROID_PLATFORM}
		NDK_PROJECT_PATH=./libjpeg-turbo
		WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
		BYPRODUCTS ${TJ_LIB}
		)

file(GLOB fmt hashlink/libs/fmt/*.c)
file(GLOB png hashlink/include/png/*.c)
file(GLOB zlib hashlink/include/zlib/*.c)
file(GLOB vorbis hashlink/include/vorbis/*.c)
file(GLOB mikkt hashlink/include/mikktspace/*.c)
file(GLOB minimp3 hashlink/include/minimp3/*.c)

add_library(fmt.hdll STATIC
		${fmt}
		${png}
		${zlib}
		${vorbis}
		${mikkt}
		)

add_dependencies(fmt.hdll turbojpeg)
file(GLOB tj_include libjpeg-turbo/jni/vendor/libjpeg-turbo/libjpeg-turbo-*)
target_link_libraries(fmt.hdll ${TJ_LIB})
target_compile_definitions(fmt.hdll PRIVATE PNG_ARM_NEON_OPT=0) #disable Neon support for now

target_include_directories(fmt.hdll PRIVATE
		hashlink/include/png
		hashlink/include/mikktspace
		hashlink/include/minimp3
		hashlink/include/vorbis
		hashlink/include/zlib
		${tj_include}
		)

# SDL

add_subdirectory(sdl2)
file(GLOB sdl hashlink/libs/sdl/*.c)
add_library(sdl.hdll STATIC ${sdl})
target_include_directories(sdl.hdll PUBLIC sdl2/include)
target_link_libraries(sdl.hdll SDL2 SDL2main EGL GLESv3)

# OpenAL

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/openal-nativetools/CMakeLists.txt ${CMAKE_CURRENT_SOURCE_DIR}/openal-soft COPYONLY)
add_subdirectory(openal-soft)
file(GLOB openal hashlink/libs/openal/*.c)
add_library(openal.hdll STATIC ${openal})
target_include_directories(openal.hdll PUBLIC openal-soft/include)
target_link_libraries(openal.hdll OpenAL)

# UI

file(GLOB ui hashlink/libs/ui/ui_stub.c)
add_library(ui.hdll STATIC ${ui})

# UV
# file(GLOB uvlibs hashlink/libs/uv/uv.c)
# add_library(uv.hdll STATIC ${uvlibs})
# add_subdirectory(libuv-android)
# include_directories(libuv-android/libuv/include)
# target_link_libraries(uv.hdll uv)

add_subdirectory(libuv)
file(GLOB libuv hashlink/libs/uv/*.c)
add_library(uv.hdll STATIC ${libuv})
target_include_directories(uv.hdll PUBLIC libuv/include)
target_link_libraries(uv.hdll uv)

# Heaps Application

add_library(heapsapp SHARED out/main.c jni.c stb/glyphme.cpp ${pcre})
target_include_directories(heapsapp PRIVATE out)
target_include_directories(heapsapp PRIVATE stb)
target_link_libraries(heapsapp hl sdl.hdll fmt.hdll openal.hdll ui.hdll uv.hdll android)
target_compile_definitions(heapsapp PRIVATE _USRDLL LIBHL_EXPORTS HAVE_CONFIG_H PCRE2_CODE_UNIT_WIDTH=16)
