//
//  BBOperatorBlockView.m
//  blob
//
//  Created by Sam Yang on 8/17/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBOperatorBlockView.h"
#import "BBLanguageBlock.h"
#import "BBQuantityParameterView.h"

@interface BBOperatorBlockView ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet BBQuantityParameterView *leftSlot;
@property (weak, nonatomic) IBOutlet BBQuantityParameterView *rightSlot;

@end

@implementation BBOperatorBlockView

- (void)setLanguageBlock:(BBLanguageBlock *)languageBlock
{
    [super setLanguageBlock:languageBlock];
    [self updateUI];
}

- (void)updateUI
{
    self.layer.cornerRadius = 7.0f;
    
    self.nameLabel.text = self.languageBlock.abbreviation ? self.languageBlock.abbreviation : self.languageBlock.name;
    
    CGSize labelStringSize = [self.nameLabel.text sizeWithAttributes: @{NSFontAttributeName:[UIFont fontWithName:BLOB_FONT_REGULAR size:BLOB_FONT_21PT]}];
    CGPoint originalOrigin = self.nameLabel.frame.origin;
    self.nameLabel.frame = CGRectMake(originalOrigin.x, originalOrigin.y, labelStringSize.width, labelStringSize.height);
    
    const CGFloat xOffset = 18.0f;
    const CGFloat xPadding = 8.0f;
    
    CGFloat calculatedWidth = labelStringSize.width + xOffset * 2 + xPadding * 2 + CGRectGetWidth(self.leftSlot.frame) + CGRectGetWidth(self.rightSlot.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGRect calculatedFrame = CGRectMake(CGPointZero.x, CGPointZero.y, calculatedWidth, height);
    self.frame = calculatedFrame;

}

@end
