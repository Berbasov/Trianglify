//
//  PalettePicker.m
//  Trianglify
//
//  Created by Alex Art on 14.05.2015.
//  Copyright (c) 2015 Alex Art. All rights reserved.
//

#import "PalettePicker.h"
#import "ColorPalette.h"
#import "ColorPaletteView.h"

static const CGFloat PalettePickerCellHeight = 40;
static const UIEdgeInsets PalettePickerCellInsets = {4, 10, 4, 10};

@interface PalettePicker ()

@end

@implementation PalettePicker

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Colors";

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = PalettePickerCellHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissColorPalettePicker)];
}

- (void)dismissColorPalettePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.palettes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    static const NSInteger paletteViewTag = 777;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UIView *view = [[ColorPaletteView alloc] initWithFrame:(CGRect){10, 4, 300, 32}];
        view.contentMode = UIViewContentModeRedraw;
        view.tag = paletteViewTag;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:view];
        // left
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:cell.contentView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1 constant:PalettePickerCellInsets.left]];
        // right
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:cell.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1 constant:-PalettePickerCellInsets.right]];
        // top
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:cell.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1 constant:PalettePickerCellInsets.top]];
        // bottom
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:cell.contentView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1 constant:-PalettePickerCellInsets.bottom]];
    }
    ColorPaletteView *paletteView = (ColorPaletteView *)[cell viewWithTag:paletteViewTag];
    ColorPalette *palette = self.palettes[indexPath.row];
    paletteView.colors = palette.colors;
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ColorPalette *palette = self.palettes[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(palettePicker:didPickPalette:)])
        [self.delegate palettePicker:self didPickPalette:palette];
}

@end
