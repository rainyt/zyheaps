
#define STB_TRUETYPE_IMPLEMENTATION
#include "stb_truetype.h"

#define HL_NAME(n) glyphme_##n
#include <hl.h>

HL_PRIM int HL_NAME(get_kerning)(const stbtt_fontinfo *font_info, int g1, int g2)
{
    return stbtt_GetGlyphKernAdvance(font_info, g1, g2);
}

HL_PRIM vdynamic *HL_NAME(get_glyph)(int code_point, const stbtt_fontinfo *font_info, float scale, int padding, int onedge_value, float pixel_dist_scale)
{
    auto glyph_index = stbtt_FindGlyphIndex(font_info, code_point);
    if (!glyph_index)
        return NULL;

    int advance_width = 0, left_side_bearing = 0;
    stbtt_GetGlyphHMetrics(font_info, glyph_index, &advance_width, &left_side_bearing); // not in pixel dimensions
    advance_width *= scale;
    left_side_bearing *= scale; // HELP: i don't know what to do with this

    int width = 0, height = 0, offset_x = 0, offset_y = 0;
    auto sdf = stbtt_GetGlyphSDF(font_info, scale, glyph_index, padding, onedge_value, pixel_dist_scale, &width, &height, &offset_x, &offset_y);

    unsigned char *rgba = NULL;
    if (width != 0 && height != 0)
    {
        rgba = (unsigned char *)hl_gc_alloc_noptr(width * height * 4);

        // for debugging purposes, we only use the red channel anyway
        auto g = 100 + rand() % 155;
        auto b = 100 + rand() % 155;

        for (int y = 0; y < height; ++y)
        {
            for (int x = 0; x < width; ++x)
            {
                int sdf_index = y * width + x;
                int sdf_value = sdf[sdf_index];

                int rgba_index = 4 * sdf_index;
                rgba[rgba_index++] = sdf_value;
                rgba[rgba_index++] = g;
                rgba[rgba_index++] = b;
                rgba[rgba_index++] = 255;
            }
        }
    }

    stbtt_FreeSDF(sdf, NULL);

    vdynamic *glyph_info = (vdynamic *)hl_alloc_dynobj();
    hl_dyn_seti(glyph_info, hl_hash_utf8("index"), &hlt_i32, glyph_index);
    hl_dyn_seti(glyph_info, hl_hash_utf8("codePoint"), &hlt_i32, code_point);
    hl_dyn_setp(glyph_info, hl_hash_utf8("rgba"), &hlt_bytes, rgba);
    hl_dyn_seti(glyph_info, hl_hash_utf8("width"), &hlt_i32, width);
    hl_dyn_seti(glyph_info, hl_hash_utf8("height"), &hlt_i32, height);
    hl_dyn_seti(glyph_info, hl_hash_utf8("offsetX"), &hlt_i32, offset_x);
    hl_dyn_seti(glyph_info, hl_hash_utf8("offsetY"), &hlt_i32, offset_y);
    hl_dyn_seti(glyph_info, hl_hash_utf8("advanceX"), &hlt_i32, advance_width);

    return glyph_info;
}

HL_PRIM int HL_NAME(get_number_of_fonts)(const vbyte *font_file_bytes)
{
    return stbtt_GetNumberOfFonts(font_file_bytes);
}

HL_PRIM vdynamic *HL_NAME(get_true_type_font_info)(const vbyte *font_file_bytes, int font_index)
{
    auto stbtt_info = (stbtt_fontinfo *)hl_gc_alloc_noptr(sizeof(stbtt_fontinfo));
    auto font_offset = stbtt_GetFontOffsetForIndex(font_file_bytes, font_index);
    if (font_offset == -1)
        return NULL;

    auto success = stbtt_InitFont(stbtt_info, font_file_bytes, font_offset);
    if (!success)
    {
        // free(stbtt_info); //HELP: i don't know how to free this, or if the gc will do it for me?
        return NULL;
    }

    int ascent = 0, descent = 0, line_gap = 0;
    stbtt_GetFontVMetrics(stbtt_info, &ascent, &descent, &line_gap);

    auto font_info = (vdynamic *)hl_alloc_dynobj();
    hl_dyn_setp(font_info, hl_hash_utf8("stbttFontInfo"), &hlt_bytes, stbtt_info);
    hl_dyn_seti(font_info, hl_hash_utf8("ascent"), &hlt_i32, ascent);
    hl_dyn_seti(font_info, hl_hash_utf8("descent"), &hlt_i32, descent);
    hl_dyn_seti(font_info, hl_hash_utf8("lineGap"), &hlt_i32, line_gap);

    return font_info;
}
DEFINE_PRIM(_I32, get_kerning, _BYTES _I32 _I32);
DEFINE_PRIM(_DYN, get_glyph, _I32 _BYTES _F32 _I32 _I32 _F32);
DEFINE_PRIM(_I32, get_number_of_fonts, _BYTES);
DEFINE_PRIM(_DYN, get_true_type_font_info, _BYTES _I32);