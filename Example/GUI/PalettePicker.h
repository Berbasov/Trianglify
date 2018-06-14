//
//  PalettePicker.h
//  Trianglify
//
//  Created by Alex Art on 14.05.2015.
//  Copyright (c) 2015 Alex Art. All rights reserved.
//

@import UIKit;
@class ColorPalette;
@protocol PalettePickerDelegate;

@interface PalettePicker : UITableViewController

@property (nonatomic, copy) NSArray *palettes;

@property (nonatomic, weak) id <PalettePickerDelegate> delegate;

@end


@protocol PalettePickerDelegate <NSObject>

- (void)palettePicker:(PalettePicker *)picker didPickPalette:(ColorPalette *)palette;

@end