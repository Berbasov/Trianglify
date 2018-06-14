//
//  TrianglifyView.h
//  Trianglify
//
//  Created by Alex Art on 13.05.2015.
//  Copyright (c) 2015 Alex Art. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrianglifyView : UIView

@property (nonatomic, assign) CGFloat cellSize;
@property (nonatomic, assign) CGFloat variance;
@property (nonatomic, copy) NSArray *colorPalette;

@end
