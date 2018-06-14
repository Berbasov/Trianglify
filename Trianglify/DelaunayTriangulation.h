//
//  DelaunayTriangulation.h
//  Trianglify
//
//  Created by Alex Art on 08.05.2015.
//  Copyright (c) 2015 Alex Art. All rights reserved.
//

@import UIKit;

@interface DelaunayTriangulation : NSObject

// Возвращаем массив индексов точек во входящем массиве (points). Массив NSNumber-ов. Размер выходного массива равен points.count*3.
/// Returns an array of indices (NSNumber) of points in the input array.
/// Size of resulting array equal to triple size of input array (points.count * 3).
+ (NSArray *)triangularFacesWithPoints:(NSArray *)points;

@end
