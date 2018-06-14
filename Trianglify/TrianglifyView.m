//
//  TrianglifyView.m
//  Trianglify
//
//  Created by Alex Art on 13.05.2015.
//  Copyright (c) 2015 Alex Art. All rights reserved.
//

#import "TrianglifyView.h"
#import "DelaunayTriangulation.h"
#import "Triangle.h"
#import "UIColor+Interpolation.h"

@interface TrianglifyView ()

@property (nonatomic, assign) CGFloat varianceInternal;
@property (nonatomic, assign) CGPoint bleed;

@end

@implementation TrianglifyView

- (void)setColorPalette:(NSArray *)colors {
    _colorPalette = colors.copy;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // How many cells we're going to have on each axis (pad by 2 cells on each edge)
    NSUInteger cellsX = floor((rect.size.width + 4 * self.cellSize) / self.cellSize);
    NSUInteger cellsY = floor((rect.size.height + 4 * self.cellSize) / self.cellSize);

    // Figure out the bleed widths to center the grid
    self.bleed = (CGPoint){
        (cellsX * self.cellSize - rect.size.width) / 2,
        (cellsY * self.cellSize - rect.size.height) / 2
    };

    // How much can out points wiggle (+/-) given the cell padding?
    self.varianceInternal = self.cellSize * self.variance / 2;

    // Generate a point mesh
    NSArray *points = [self generatePointsWithSize:rect.size cellSize:self.cellSize];

    // Sort points in increasing X values
    NSArray *sortedPoints = [points sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CGPoint p1 = [(NSValue *)obj1 CGPointValue];
        CGPoint p2 = [(NSValue *)obj2 CGPointValue];
        if (p1.x > p2.x)
            return NSOrderedDescending;
        if (p1.x < p2.x)
            return NSOrderedAscending;
        return NSOrderedSame;
    }];

    // delaunay.triangulate gives us indices into the original coordinate array
    NSArray *geomIndices = [DelaunayTriangulation triangularFacesWithPoints:sortedPoints];

    // iterate over the indices in groups of three to flatten them into polygons, with color lookup
    NSMutableArray *triangles = [NSMutableArray array];
    for (NSUInteger i = 0; i < geomIndices.count; i += 3) {
        Triangle *triangle = [[Triangle alloc] init];

        NSUInteger v1 = [geomIndices[i] integerValue];
        NSUInteger v2 = [geomIndices[i+1] integerValue];
        NSUInteger v3 = [geomIndices[i+2] integerValue];
        triangle.point1 = [sortedPoints[v1] CGPointValue];
        triangle.point2 = [sortedPoints[v2] CGPointValue];
        triangle.point3 = [sortedPoints[v3] CGPointValue];
        CGPoint centroid = [triangle centroid];
        CGPoint gradientPosition = [self normalize:centroid toSize:rect.size];
        UIColor *xColor = [UIColor interpolatedWithColors:self.colorPalette offset:gradientPosition.x];
        UIColor *yColor = [UIColor interpolatedWithColors:self.colorPalette offset:gradientPosition.y];
        triangle.color = [xColor interpolateWithColor:yColor rate:0.5];
        [triangles addObject:triangle];
    }

    // Draw triangles
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Fill with stroke to fix an issue with canvas antialiasing.
    const CGFloat strokeWidth = ([UIScreen mainScreen].scale == 1.0) ? 1.5 : 1.0;
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetLineJoin(context, kCGLineJoinRound);

    for (Triangle *triangle in triangles) {
        CGContextSetFillColorWithColor(context, triangle.color.CGColor);

        CGContextAddPath(context, triangle.bezierPath.CGPath);
        CGContextFillPath(context);

        CGContextSetStrokeColorWithColor(context, triangle.color.CGColor);
        CGContextAddPath(context, triangle.bezierPath.CGPath);
        CGContextStrokePath(context);
    }
}

#pragma mark - Private

- (CGPoint)normalize:(CGPoint)point toSize:(CGSize)size {
    CGPoint p;
    p.x = [self mapNum:point.x
              inRange0:-self.bleed.x inRange1:(size.width + self.bleed.x)
             outRange0:0 outRange1:1];
    p.y = [self mapNum:point.y
              inRange0:-self.bleed.y inRange1:(size.height + self.bleed.y)
             outRange0:0 outRange1:1];
    return p;
}

/// Generate points on a randomized grid
- (NSArray *)generatePointsWithSize:(CGSize)size cellSize:(CGFloat)cellSize {
    NSMutableArray *points = [NSMutableArray array];
    CGPoint point;
    for (CGFloat i = -self.bleed.x; i < size.width + self.bleed.x; i += cellSize) {
        for (CGFloat j = -self.bleed.y; j < size.height + self.bleed.y; j += cellSize) {
            point.x = i + cellSize/2 + [self mapNum:[self randomFrom0to1] inRange0:0 inRange1:1 outRange0:-self.varianceInternal outRange1:self.varianceInternal];
            point.y = j + cellSize/2 + [self mapNum:[self randomFrom0to1] inRange0:0 inRange1:1 outRange0:-self.varianceInternal outRange1:self.varianceInternal];
            [points addObject:[NSValue valueWithCGPoint:point]];    //points.push([x, y].map(Math.floor));
        }
    }
    return points;
}

/// Generate random number in range 0..1
- (float)randomFrom0to1 {
    float v = (float)arc4random() / (float)0xffffffffu;
    return v;
}

/// Translate value from inRange to outRange
- (CGFloat)mapNum:(CGFloat)num
         inRange0:(CGFloat)inr0 inRange1:(CGFloat)inr1
        outRange0:(CGFloat)outr0 outRange1:(CGFloat)outr1 {
    return (num - inr0) * (outr1 - outr0) / (inr1 - inr0) + outr0;
}

@end
