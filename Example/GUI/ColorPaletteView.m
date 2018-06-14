//
//  ColorPaletteView.m
//  Trianglify
//
//  Created by Alex Art on 14.05.2015.
//  Copyright (c) 2015 Alex Art. All rights reserved.
//

#import "ColorPaletteView.h"

@implementation ColorPaletteView

- (void)setColors:(NSArray *)colorsArray {
    _colors = colorsArray.copy;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGFloat cellWidth = roundf(rect.size.width / self.colors.count);
    CGRect colorFrame = rect;
    colorFrame.size.width = cellWidth;
    for (NSUInteger i = 0; i < self.colors.count; i ++) {
        if (i == self.colors.count - 1) {
            colorFrame.size.width = rect.size.width - colorFrame.origin.x;
        }
        UIColor *color = self.colors[i];
        [color setFill];
        UIRectFill(colorFrame);
        colorFrame.origin.x += colorFrame.size.width;
    }

    // Draw stroke
    [[UIColor lightGrayColor] setStroke];
    UIRectFrame(rect);
}

@end
