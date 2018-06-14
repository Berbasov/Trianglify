//
//  ConrtrolPanel.m
//  Trianglify
//
//  Created by Alex Art on 13.05.2015.
//  Copyright (c) 2015 Alex Art. All rights reserved.
//

#import "ControlPanel.h"
#import "ControlSlider.h"

static const CGFloat ControlPanelMainIndent = 8.0;

@interface ControlPanel ()

@property (nonatomic, strong, readonly) ControlSlider *cellSizeSlider;
@property (nonatomic, strong, readonly) ControlSlider *varianceSlider;
@property (nonatomic, strong, readonly) UISegmentedControl *segmentedControl;

@end

@implementation ControlPanel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        self.translatesAutoresizingMaskIntoConstraints = NO;

        _visible = !self.hidden;

        _cellSizeSlider = [self displayCellSizeSlider];
        _varianceSlider = [self displayVarianceSlider];
        _segmentedControl = [self displaySegmentedControl];
    }
    return self;
}


- (void)setCellSize:(CGFloat)size {
    self.cellSizeSlider.value = size;
}

- (void)setMinimumCellSize:(CGFloat)size {
    self.cellSizeSlider.minimumValue = size;
}

- (CGFloat)minimumCellSize {
    return self.cellSizeSlider.minimumValue;
}

- (void)setMaximumCellSize:(CGFloat)size {
    self.cellSizeSlider.maximumValue = size;
}

- (CGFloat)maximumCellSize {
    return self.cellSizeSlider.maximumValue;
}

- (void)setVariance:(CGFloat)value {
    self.varianceSlider.value = value;
}

- (void)setVisible:(BOOL)flag {
    [self setVisible:flag animated:NO];
}

- (void)setVisible:(BOOL)flag animated:(BOOL)animated {
    _visible = flag;
    self.hidden = !flag;
}

#pragma mark - Private

- (ControlSlider *)displayCellSizeSlider {
    ControlSlider *slider = [[ControlSlider alloc] init];
    slider.title = @"Cell size";
    slider.didChangeHandler = ^(ControlSlider *slider, float value){
        if ([self.delegate respondsToSelector:@selector(controlPanel:didChangeCellSize:)])
            [self.delegate controlPanel:self didChangeCellSize:value];
    };
    slider.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:slider];

    // top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:slider
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1 constant:ControlPanelMainIndent]];
    // left
    [self addConstraint:[NSLayoutConstraint constraintWithItem:slider
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1 constant:ControlPanelMainIndent]];
    // right
    [self addConstraint:[NSLayoutConstraint constraintWithItem:slider
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1 constant:-ControlPanelMainIndent]];
    return slider;
}

- (ControlSlider *)displayVarianceSlider {
    ControlSlider *slider = [[ControlSlider alloc] init];
    slider.title = @"Variance";
    slider.didChangeHandler = ^(ControlSlider *slider, float value){
        if ([self.delegate respondsToSelector:@selector(controlPanel:didChangeVariance:)])
            [self.delegate controlPanel:self didChangeVariance:value];
    };
    slider.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:slider];

    // top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:slider
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.cellSizeSlider
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1 constant:ControlPanelMainIndent]];
    // left
    [self addConstraint:[NSLayoutConstraint constraintWithItem:slider
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1 constant:ControlPanelMainIndent]];
    // right
    [self addConstraint:[NSLayoutConstraint constraintWithItem:slider
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1 constant:-ControlPanelMainIndent]];
    return slider;
}

- (UISegmentedControl *)displaySegmentedControl {
    UISegmentedControl *buttons = [[UISegmentedControl alloc] initWithItems:@[@"Random colors", @"Colors ▷"]];
    buttons.momentary = YES;
    buttons.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:buttons];
    [buttons addTarget:self action:@selector(actionSegment:) forControlEvents:UIControlEventValueChanged];
    // center X
    [self addConstraint:[NSLayoutConstraint constraintWithItem:buttons
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1 constant:0]];
    // top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:buttons
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.varianceSlider
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1 constant:ControlPanelMainIndent]];
    // bottom
    [self addConstraint:[NSLayoutConstraint constraintWithItem:buttons
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1 constant:-ControlPanelMainIndent]];
    return buttons;
}

- (void)actionSegment:(UISegmentedControl *)segmentedControl {
    if ([self.delegate respondsToSelector:@selector(controlPanel:didTapSegment:)])
        [self.delegate controlPanel:self didTapSegment:segmentedControl.selectedSegmentIndex];
}

@end
