//
//  UIColor+Interpolation.m
//  Trianglify
//
//  Created by Alexey Berbasov on 14/06/2018.
//  Copyright © 2018 Alex Art. All rights reserved.
//

#import "UIColor+Interpolation.h"

@implementation UIColor (Interpolation)

+ (UIColor *)interpolatedWithColors:(NSArray<UIColor *> *)colors offset:(CGFloat)offset {
    if (colors.count == 0) {
        return UIColor.blackColor;
    }
    if (colors.count == 1 || offset <= 0.0) {
        return colors.firstObject;
    }
    if (offset >= 1.0) {
        return colors.lastObject;
    }
    CGFloat colorStep = 1.0 / (colors.count - 1);
    NSUInteger colorIndex = floorf(offset / colorStep);
    CGFloat colorStartOffset = colorStep * colorIndex;
    CGFloat colorOffset = (offset - colorStartOffset) / colorStep;

    UIColor *startColor = colors[colorIndex];
    UIColor *endColor = colors[colorIndex + 1];
    return [startColor interpolateWithColor:endColor rate:colorOffset];
}

- (UIColor *)interpolateWithColor:(UIColor *)color rate:(CGFloat)rate {
    // Clamping to range 0..1
    rate = MAX(0.0, MIN(rate, 1.0));

    CGFloat rgb1[4], rgb2[4];
    [self getRed:&rgb1[0] green:&rgb1[1] blue:&rgb1[2] alpha:&rgb1[3]];
    [color getRed:&rgb2[0] green:&rgb2[1] blue:&rgb2[2] alpha:&rgb2[3]];
    rgb1[0] += (rgb2[0] - rgb1[0]) * rate;
    rgb1[1] += (rgb2[1] - rgb1[1]) * rate;
    rgb1[2] += (rgb2[2] - rgb1[2]) * rate;
    rgb1[3] += (rgb2[3] - rgb1[3]) * rate;
    return [UIColor colorWithRed:rgb1[0] green:rgb1[1] blue:rgb1[2] alpha:rgb1[3]];
}

@end
