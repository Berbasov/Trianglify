//
//  Triangle.h
//  Trianglify
//
//  Created by Alex Art on 08.05.2015.
//  Copyright (c) 2015 Alex Art. All rights reserved.
//

@import UIKit;

@interface Triangle : NSObject

@property (nonatomic, assign) CGPoint point1, point2, point3;
@property (nonatomic, strong) UIColor *color;

- (CGPoint)centroid;
- (UIBezierPath *)bezierPath;

@end
