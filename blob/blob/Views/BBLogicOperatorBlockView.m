//
//  BBLogicOperatorBlockView.m
//  blob
//
//  Created by Sam Yang on 8/17/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBLogicOperatorBlockView.h"
#import "BBLanguageBlock+Configure.h"
#import "BBBlockSlotParameterView.h"

const CGFloat xOffset = 18.0f;
const CGFloat xPadding = 8.0f;

@interface BBLogicOperatorBlockView ()
@property (weak, nonatomic) IBOutlet BBBlockSlotParameterView *leftSlot;
@property (weak, nonatomic) IBOutlet BBBlockSlotParameterView *rightSlot;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation BBLogicOperatorBlockView

- (void)setLanguageBlock:(BBLanguageBlock *)languageBlock
{
    [super setLanguageBlock:languageBlock];
    [self updateUI];
}

- (void)updateUI
{
    self.leftSlot.frame = CGRectMake(self.leftSlot.frame.origin.x, self.leftSlot.frame.origin.y, 48.0f, self.leftSlot.frame.size.height);
    
    self.layer.cornerRadius = BLOB_BLOCK_SLOT_CORNER_RADIUS;
    self.leftSlot.layer.cornerRadius = BLOB_BLOCK_SLOT_CORNER_RADIUS;
    self.rightSlot.layer.cornerRadius = BLOB_BLOCK_SLOT_CORNER_RADIUS;
    
    self.nameLabel.text = self.languageBlock.abbreviation ? self.languageBlock.abbreviation : self.languageBlock.name;
    
    CGSize labelStringSize = [self.nameLabel.text sizeWithAttributes: @{NSFontAttributeName:[UIFont fontWithName:BLOB_FONT_REGULAR size:BLOB_FONT_21PT]}];
    CGPoint originalOrigin = self.nameLabel.frame.origin;
    self.nameLabel.frame = CGRectMake(originalOrigin.x, originalOrigin.y, labelStringSize.width, labelStringSize.height);
    
    CGFloat calculatedWidth = CGRectGetWidth(self.nameLabel.frame) + xOffset * 2 + xPadding * 2 + CGRectGetWidth(self.rightSlot.frame) + CGRectGetWidth(self.leftSlot.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGRect calculatedFrame = CGRectMake(CGPointZero.x, CGPointZero.y, calculatedWidth, height);
    self.frame = calculatedFrame;
}

@end
