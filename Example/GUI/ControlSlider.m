//
//  ControlSlider.m
//  Trianglify
//
//  Created by Alex Art on 14.05.2015.
//  Copyright (c) 2015 Alex Art. All rights reserved.
//

#import "ControlSlider.h"

@interface ControlSlider ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, assign) CGFloat tempValue;

@end

@implementation ControlSlider

#pragma mark - Public

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        self.titleLabel = [self displayTitleLabel];
        self.valueLabel = [self displayValueLabel];
        self.slider = [self displaySlider];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setValue:(float)val {
    _value = val;
    self.slider.value = val;
    [self updateVarianceValueLabel:val];
}

- (void)setMinimumValue:(float)val {
    self.slider.minimumValue = val;
}

- (float)minimumValue {
    return self.slider.minimumValue;
}

- (void)setMaximumValue:(float)val {
    self.slider.maximumValue = val;
}

- (float)maximumValue {
    return self.slider.maximumValue;
}

#pragma mark - Private

- (UILabel *)displayTitleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:label];
    // left
    [self addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1 constant:0]];
    // top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1 constant:0]];
    return label;
}

- (UILabel *)displayValueLabel {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"-";
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:label];
    // right
    [self addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1 constant:0]];
    // top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1 constant:0]];
    return label;
}

- (UISlider *)displaySlider {
    UISlider *slider = [[UISlider alloc] init];
    slider.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:slider];

    [slider addTarget:self action:@selector(actionVarianceSlider:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(actionVarianceSliderBegin:) forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self action:@selector(actionVarianceSliderEnd:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel)];

    // top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:slider
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.titleLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1 constant:0]];
    // left
    [self addConstraint:[NSLayoutConstraint constraintWithItem:slider
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1 constant:0]];
    // right
    [self addConstraint:[NSLayoutConstraint constraintWithItem:slider
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1 constant:0]];
    // bottom
    [self addConstraint:[NSLayoutConstraint constraintWithItem:slider
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1 constant:0]];
    return slider;
}

- (void)updateVarianceValueLabel:(float)value {
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f", value];
}


- (void)actionVarianceSlider:(UISlider *)slider {
    [self updateVarianceValueLabel:slider.value];
}

- (void)actionVarianceSliderBegin:(UISlider *)slider {
    self.tempValue = self.value;
}

- (void)actionVarianceSliderEnd:(UISlider *)slider {
    self.value = slider.value;
    if (self.value != self.tempValue && self.didChangeHandler) {
        self.didChangeHandler(self, self.value);
    }
}

@end
