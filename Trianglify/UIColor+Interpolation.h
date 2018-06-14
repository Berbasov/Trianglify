//
//  UIColor+Interpolation.h
//  Trianglify
//
//  Created by Alexey Berbasov on 14/06/2018.
//  Copyright © 2018 Alex Art. All rights reserved.
//

@import UIKit;

@interface UIColor (Interpolation)

/// offset is value in range 0..1.
/// colors array should not be empty.
+ (nonnull UIColor *)interpolatedWithColors:(nonnull NSArray <UIColor *>*)colors offset:(CGFloat)offset;

/// receiver - start color, color - end color. Rate should be 0..1.
- (nonnull UIColor *)interpolateWithColor:(nonnull UIColor *)color rate:(CGFloat)rate;

@end
