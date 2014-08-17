//
//  BBNotBlockView.m
//  blob
//
//  Created by Sam Yang on 8/17/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBNotBlockView.h"

@interface BBNotBlockView ()
@property (weak, nonatomic) IBOutlet UILabel *notLabel;
@property (weak, nonatomic) IBOutlet BBNotBlockView *rightSlot;

@end

@implementation BBNotBlockView

- (void)setLanguageBlock:(BBLanguageBlock *)languageBlock
{
    [super setLanguageBlock:languageBlock];
    [self updateUI];
}

- (void)updateUI
{
    self.layer.cornerRadius = BLOB_BLOCK_SLOT_CORNER_RADIUS;
    self.rightSlot.layer.cornerRadius = BLOB_BLOCK_SLOT_CORNER_RADIUS;
}

@end
