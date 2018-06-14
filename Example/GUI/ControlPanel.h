//
//  ConrtrolPanel.h
//  Trianglify
//
//  Created by Alex Art on 13.05.2015.
//  Copyright (c) 2015 Alex Art. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ControlPanelDelegate;

@interface ControlPanel : UIView

@property (nonatomic, assign) CGFloat cellSize;
@property (nonatomic, assign) CGFloat minimumCellSize;
@property (nonatomic, assign) CGFloat maximumCellSize;

@property (nonatomic, assign) CGFloat variance;     // 0..1

@property (nonatomic, weak) id <ControlPanelDelegate> delegate;

@property (nonatomic, assign) BOOL visible;
- (void)setVisible:(BOOL)visible animated:(BOOL)animated;

@end


@protocol ControlPanelDelegate <NSObject>

@optional
- (void)controlPanel:(ControlPanel *)panel didChangeCellSize:(CGFloat)size;
- (void)controlPanel:(ControlPanel *)panel didChangeVariance:(CGFloat)value;
- (void)controlPanel:(ControlPanel *)panel didTapSegment:(NSInteger)index;

@end
