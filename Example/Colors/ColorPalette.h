//
//  Gradient.h
//  Trianglify
//
//  Created by Alex Art on 12.05.2015.
//  Copyright (c) 2015 Alex Art. All rights reserved.
//

@import UIKit;

@interface ColorPalette : NSObject

- (instancetype)initWithColors:(NSArray *)aColors;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *colors;

@end
