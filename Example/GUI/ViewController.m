//
//  ViewController.m
//  Trianglify
//
//  Created by Alex Art on 07.05.2015.
//  Based on http://qrohlf.com/trianglify-generator/
//  Copyright (c) 2015 Alex Art. All rights reserved.
//

#import "ViewController.h"
#import "TrianglifyView.h"
#import "ControlPanel.h"
#import "Colorbrewer.h"
#import "PalettePicker.h"

@interface ViewController () <ControlPanelDelegate, PalettePickerDelegate>

@property (nonatomic, strong) TrianglifyView *trianglifyView;
@property (nonatomic, strong) ControlPanel *controlPanel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.trianglifyView = [self displayTrianglifyView];
    self.controlPanel = [self displayControlPanel];

    [self.trianglifyView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchControlsVisibility)]];

    // default settings
    CGFloat minCellSize = 10;
    CGFloat maxCellSize = roundf(MIN(self.view.frame.size.width, self.view.frame.size.height) / 3);
    CGFloat cellSize = roundf((maxCellSize - minCellSize) / 2);
    CGFloat variance = 0.75;
    ColorPalette *palette = [ColorBrewer anyPalette];

    self.trianglifyView.cellSize = cellSize;
    self.trianglifyView.variance = variance;
    self.trianglifyView.colorPalette = palette.colors;
    self.trianglifyView.contentMode = UIViewContentModeRedraw;      // redraw on bounds change

    self.controlPanel.minimumCellSize = minCellSize;
    self.controlPanel.maximumCellSize = maxCellSize;
    self.controlPanel.cellSize = cellSize;
    self.controlPanel.variance = variance;
}

#pragma mark - Private

- (TrianglifyView *)displayTrianglifyView {
    UIView *superview = self.view;

    TrianglifyView *view = [[TrianglifyView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [superview addSubview:view];
    // left
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1 constant:0]];
    // right
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1 constant:0]];
    // top
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1 constant:0]];
    // bottom
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1 constant:0]];
    return view;
}

- (ControlPanel *)displayControlPanel {
    UIView *superview = self.view;

    ControlPanel *panel = [[ControlPanel alloc] init];
    panel.delegate = self;
    [superview addSubview:panel];
    // left
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:panel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1 constant:0]];
    // bottom
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:panel
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.bottomLayoutGuide
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1 constant:0]];
    // width
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:panel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1 constant:320]];
    return panel;
}

- (void)switchControlsVisibility {
    self.controlPanel.visible = !self.controlPanel.visible;
}

- (void)presentColorPalettePicker {
    PalettePicker *picker = [[PalettePicker alloc] initWithStyle:UITableViewStylePlain];
    picker.palettes = [ColorBrewer allPalettes];
    picker.delegate = self;

    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark ControlPanelDelegate

- (void)controlPanel:(ControlPanel *)panel didChangeCellSize:(CGFloat)size {
    self.trianglifyView.cellSize = size;
    [self.trianglifyView setNeedsDisplay];
}

- (void)controlPanel:(ControlPanel *)panel didChangeVariance:(CGFloat)variance {
    self.trianglifyView.variance = variance;
    [self.trianglifyView setNeedsDisplay];
}

- (void)controlPanel:(ControlPanel *)panel didTapSegment:(NSInteger)segmentIndex {
    if (segmentIndex == 0) {
        // Random color
        self.trianglifyView.colorPalette = ColorBrewer.anyPalette.colors;
    } else if (segmentIndex == 1) {
        [self presentColorPalettePicker];
    }
}

#pragma mark PalettePickerDelegate

- (void)palettePicker:(PalettePicker *)picker didPickPalette:(ColorPalette *)palette {
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.trianglifyView.colorPalette = palette.colors;
}

@end
