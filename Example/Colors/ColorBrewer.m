//
//  ColorBrewer.m
//  Trianglify
//
//  Created by Alex Art on 08.05.2015.
//  Copyright (c) 2015 Alex Art. All rights reserved.
//

#import "ColorBrewer.h"

@interface UIColor (HexCreation)
@end

@implementation UIColor (HexCreation)

+ (instancetype)colorWithHexWithoutAlpha:(uint32_t)hex {
    return [[[self class] alloc] initWithRed:((hex >> 16) & 0xFF) / 255.0
                                       green:((hex >> 8) & 0xFF) / 255.0
                                        blue:(hex & 0xFF) / 255.0
                                       alpha:1.0];
}

@end


@implementation ColorBrewer

typedef struct _ColorBrewerPalette {
    __unsafe_unretained NSString *name;
    const uint32_t *colors;
    NSUInteger colorsCount;
} ColorBrewerPalette;

// Colors by Cindy Brewer (taken: https://github.com/qrohlf/trianglify/blob/master/lib/colorbrewer.js)
static const uint32_t
YlGn[] = {0xffffe5, 0xf7fcb9, 0xd9f0a3, 0xaddd8e, 0x78c679, 0x41ab5d, 0x238443, 0x006837, 0x004529},
YlGnBu[] = {0xffffd9, 0xedf8b1, 0xc7e9b4, 0x7fcdbb, 0x41b6c4, 0x1d91c0, 0x225ea8, 0x253494, 0x081d58},
GnBu[] = {0xf7fcf0, 0xe0f3db, 0xccebc5, 0xa8ddb5, 0x7bccc4, 0x4eb3d3, 0x2b8cbe, 0x0868ac, 0x084081},
BuGn[] = {0xf7fcfd, 0xe5f5f9, 0xccece6, 0x99d8c9, 0x66c2a4, 0x41ae76, 0x238b45, 0x006d2c, 0x00441b},
PuBuGn[] = {0xfff7fb, 0xece2f0, 0xd0d1e6, 0xa6bddb, 0x67a9cf, 0x3690c0, 0x02818a, 0x016c59, 0x014636},
PuBu[] = {0xfff7fb, 0xece7f2, 0xd0d1e6, 0xa6bddb, 0x74a9cf, 0x3690c0, 0x0570b0, 0x045a8d, 0x023858},
BuPu[] = {0xf7fcfd, 0xe0ecf4, 0xbfd3e6, 0x9ebcda, 0x8c96c6, 0x8c6bb1, 0x88419d, 0x810f7c, 0x4d004b},
RdPu[] = {0xfff7f3, 0xfde0dd, 0xfcc5c0, 0xfa9fb5, 0xf768a1, 0xdd3497, 0xae017e, 0x7a0177, 0x49006a},
PuRd[] = {0xf7f4f9, 0xe7e1ef, 0xd4b9da, 0xc994c7, 0xdf65b0, 0xe7298a, 0xce1256, 0x980043, 0x67001f},
OrRd[] = {0xfff7ec, 0xfee8c8, 0xfdd49e, 0xfdbb84, 0xfc8d59, 0xef6548, 0xd7301f, 0xb30000, 0x7f0000},
YlOrRd[] = {0xffffcc, 0xffeda0, 0xfed976, 0xfeb24c, 0xfd8d3c, 0xfc4e2a, 0xe31a1c, 0xbd0026, 0x800026},
YlOrBr[] = {0xffffe5, 0xfff7bc, 0xfee391, 0xfec44f, 0xfe9929, 0xec7014, 0xcc4c02, 0x993404, 0x662506},
Purples[] = {0xfcfbfd, 0xefedf5, 0xdadaeb, 0xbcbddc, 0x9e9ac8, 0x807dba, 0x6a51a3, 0x54278f, 0x3f007d},
Blues[] = {0xf7fbff, 0xdeebf7, 0xc6dbef, 0x9ecae1, 0x6baed6, 0x4292c6, 0x2171b5, 0x08519c, 0x08306b},
Greens[] = {0xf7fcf5, 0xe5f5e0, 0xc7e9c0, 0xa1d99b, 0x74c476, 0x41ab5d, 0x238b45, 0x006d2c, 0x00441b},
Oranges[] = {0xfff5eb, 0xfee6ce, 0xfdd0a2, 0xfdae6b, 0xfd8d3c, 0xf16913, 0xd94801, 0xa63603, 0x7f2704},
Reds[] = {0xfff5f0, 0xfee0d2, 0xfcbba1, 0xfc9272, 0xfb6a4a, 0xef3b2c, 0xcb181d, 0xa50f15, 0x67000d},
Greys[] = {0xffffff, 0xf0f0f0, 0xd9d9d9, 0xbdbdbd, 0x969696, 0x737373, 0x525252, 0x252525, 0x000000},
PuOr[] = {0x7f3b08, 0xb35806, 0xe08214, 0xfdb863, 0xfee0b6, 0xf7f7f7, 0xd8daeb, 0xb2abd2, 0x8073ac, 0x542788, 0x2d004b},
BrBG[] = {0x543005, 0x8c510a, 0xbf812d, 0xdfc27d, 0xf6e8c3, 0xf5f5f5, 0xc7eae5, 0x80cdc1, 0x35978f, 0x01665e, 0x003c30},
PRGn[] = {0x40004b, 0x762a83, 0x9970ab, 0xc2a5cf, 0xe7d4e8, 0xf7f7f7, 0xd9f0d3, 0xa6dba0, 0x5aae61, 0x1b7837, 0x00441b},
PiYG[] = {0x8e0152, 0xc51b7d, 0xde77ae, 0xf1b6da, 0xfde0ef, 0xf7f7f7, 0xe6f5d0, 0xb8e186, 0x7fbc41, 0x4d9221, 0x276419},
RdBu[] = {0x67001f, 0xb2182b, 0xd6604d, 0xf4a582, 0xfddbc7, 0xf7f7f7, 0xd1e5f0, 0x92c5de, 0x4393c3, 0x2166ac, 0x053061},
RdGy[] = {0x67001f, 0xb2182b, 0xd6604d, 0xf4a582, 0xfddbc7, 0xffffff, 0xe0e0e0, 0xbababa, 0x878787, 0x4d4d4d, 0x1a1a1a},
RdYlBu[] = {0xa50026, 0xd73027, 0xf46d43, 0xfdae61, 0xfee090, 0xffffbf, 0xe0f3f8, 0xabd9e9, 0x74add1, 0x4575b4, 0x313695},
Spectral[] = {0x9e0142, 0xd53e4f, 0xf46d43, 0xfdae61, 0xfee08b, 0xffffbf, 0xe6f598, 0xabdda4, 0x66c2a5, 0x3288bd, 0x5e4fa2},
RdYlGn[] = {0xa50026, 0xd73027, 0xf46d43, 0xfdae61, 0xfee08b, 0xffffbf, 0xd9ef8b, 0xa6d96a, 0x66bd63, 0x1a9850, 0x006837};

static const ColorBrewerPalette ColorBrewerPalettes[] = {
    {@"YlGn", YlGn, sizeof(YlGn)/sizeof(YlGn[0])},
    {@"YlGnBu", YlGnBu, sizeof(YlGnBu)/sizeof(YlGnBu[0])},
    {@"GnBu", GnBu, sizeof(GnBu)/sizeof(GnBu[0])},
    {@"BuGn", BuGn, sizeof(BuGn)/sizeof(BuGn[0])},
    {@"PuBuGn", PuBuGn, sizeof(PuBuGn)/sizeof(PuBuGn[0])},
    {@"PuBu", PuBu, sizeof(PuBu)/sizeof(PuBu[0])},
    {@"BuPu", BuPu, sizeof(BuPu)/sizeof(BuPu[0])},
    {@"RdPu", RdPu, sizeof(RdPu)/sizeof(RdPu[0])},
    {@"PuRd", PuRd, sizeof(PuRd)/sizeof(PuRd[0])},
    {@"OrRd", OrRd, sizeof(OrRd)/sizeof(OrRd[0])},
    {@"YlOrRd", YlOrRd, sizeof(YlOrRd)/sizeof(YlOrRd[0])},
    {@"YlOrBr", YlOrBr, sizeof(YlOrBr)/sizeof(YlOrBr[0])},
    {@"Purples", Purples, sizeof(Purples)/sizeof(Purples[0])},
    {@"Blues", Blues, sizeof(Blues)/sizeof(Blues[0])},
    {@"Greens", Greens, sizeof(Greens)/sizeof(Greens[0])},
    {@"Oranges", Oranges, sizeof(Oranges)/sizeof(Oranges[0])},
    {@"Reds", Reds, sizeof(Reds)/sizeof(Reds[0])},
    {@"Greys", Greys, sizeof(Greys)/sizeof(Greys[0])},
    {@"PuOr", PuOr, sizeof(PuOr)/sizeof(PuOr[0])},
    {@"BrBG", BrBG, sizeof(BrBG)/sizeof(BrBG[0])},
    {@"PRGn", PRGn, sizeof(PRGn)/sizeof(PRGn[0])},
    {@"PiYG", PiYG, sizeof(PiYG)/sizeof(PiYG[0])},
    {@"RdBu", RdBu, sizeof(RdBu)/sizeof(RdBu[0])},
    {@"RdGy", RdGy, sizeof(RdGy)/sizeof(RdGy[0])},
    {@"RdYlBu", RdYlBu, sizeof(RdYlBu)/sizeof(RdYlBu[0])},
    {@"Spectral", Spectral, sizeof(Spectral)/sizeof(Spectral[0])},
    {@"RdYlGn", RdYlGn, sizeof(RdYlGn)/sizeof(RdYlGn[0])}
};

+ (NSArray *)allNames {
    static NSUInteger count = sizeof(ColorBrewerPalettes) / sizeof(ColorBrewerPalettes[0]);
    NSMutableArray *names = [NSMutableArray array];
    for (NSUInteger i = 0; i < count; i ++) {
        [names addObject:ColorBrewerPalettes[i].name];
    }

    // dev-helper
//    for (NSString *name in names) {
//        const char *cName = name.UTF8String;
//        printf("{@\"%s\", %s, sizeof(%s)/sizeof(%s[0])},\n", cName, cName, cName, cName);
//    }

    return [names copy];
}

+ (NSArray *)colorsNamed:(NSString *)searchName {
    static NSUInteger count = sizeof(ColorBrewerPalettes) / sizeof(ColorBrewerPalettes[0]);
    NSUInteger index;
    for (index = 0; index < count; index ++) {
        if ([ColorBrewerPalettes[index].name isEqualToString:searchName])
            break;
    }
    if (index >= count)
        return nil;

    NSMutableArray *colors = [NSMutableArray array];
    for (NSUInteger i = 0; i < ColorBrewerPalettes[index].colorsCount; i ++) {
        const uint32_t *colorsArray = ColorBrewerPalettes[index].colors;
        [colors addObject:[UIColor colorWithHexWithoutAlpha:colorsArray[i]]];
    }
    return colors.copy;
}

+ (NSArray *)anyColors {
    NSArray *names = [self allNames];
    NSString *randomName = names[arc4random_uniform((uint32_t)names.count)];
    return [self colorsNamed:randomName];
}

@end

@implementation ColorBrewer (GradiendAddition)

+ (ColorPalette *)paletteNamed:(NSString *)name {
    NSArray *colors = [self colorsNamed:name];
    if (!colors)
        return nil;
    ColorPalette *palette = [[ColorPalette alloc] initWithColors:colors];
    palette.name = name;
    return palette;
}

+ (ColorPalette *)anyPalette {
    return [[ColorPalette alloc] initWithColors:[self anyColors]];
}

+ (NSArray *)allPalettes {
    NSArray *names = [self allNames];
    NSMutableArray *palettes = [NSMutableArray array];
    for (NSString *name in names) {
        ColorPalette *palette = [self paletteNamed:name];
        if (palette)
            [palettes addObject:palette];
    }
    return palettes.count ? palettes.copy : nil;
}

@end
