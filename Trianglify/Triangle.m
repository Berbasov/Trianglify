//
//  Triangle.m
//  Trianglify
//
//  Created by Alex Art on 08.05.2015.
//  Copyright (c) 2015 Alex Art. All rights reserved.
//

#import "Triangle.h"

@implementation Triangle

- (instancetype)init {
    self = [super init];
    if (self) {
        _point1 = _point2 = _point3 = CGPointZero;
    }
    return self;
}

- (CGPoint)centroid {
    CGPoint p;
    p.x = (self.point1.x + self.point2.x + self.point3.x) / 3;
    p.y = (self.point1.y + self.point2.y + self.point3.y) / 3;
    return p;
}

- (UIBezierPath *)bezierPath {
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:self.point1];
    [bezier addLineToPoint:self.point2];
    [bezier addLineToPoint:self.point3];
    [bezier closePath];
    return bezier;
}

@end
