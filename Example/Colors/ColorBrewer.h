//
//  ColorBrewer.h
//  Trianglify
//
//  Created by Alex Art on 08.05.2015.
//  Copyright (c) 2015 Alex Art. All rights reserved.
//
// Colorbrewer colors, by Cindy Brewer
//

@import UIKit;
#import "ColorPalette.h"

@interface ColorBrewer : NSObject

+ (NSArray *)allNames;

+ (NSArray *)colorsNamed:(NSString *)name;
+ (NSArray *)anyColors;

@end

@interface ColorBrewer (GradiendAddition)

+ (ColorPalette *)paletteNamed:(NSString *)name;
+ (ColorPalette *)anyPalette;
+ (NSArray *)allPalettes;

@end
