//
//  ControlSlider.h
//  Trianglify
//
//  Created by Alex Art on 14.05.2015.
//  Copyright (c) 2015 Alex Art. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControlSlider : UIView

@property (nonatomic, copy) NSString *title;        // default is nil
@property (nonatomic, assign) float value;          // 0..1
@property (nonatomic, assign) float minimumValue;   // default 0.0
@property (nonatomic, assign) float maximumValue;   // default 1.0
@property (nonatomic, copy) void(^didChangeHandler)(ControlSlider *slider, float value);

@end
