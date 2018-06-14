//
//  Gradient.m
//  Trianglify
//
//  Created by Alex Art on 12.05.2015.
//  Copyright (c) 2015 Alex Art. All rights reserved.
//

#import "ColorPalette.h"

@implementation ColorPalette

- (instancetype)initWithColors:(NSArray *)aColors {
    NSParameterAssert(aColors.count > 0);
    if (!aColors.count)
        return nil;
    self = [super init];
    if (self) {
        _colors = [aColors copy];
    }
    return self;
}

@end
