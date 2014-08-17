//
//  BBOperatorBlockView.m
//  blob
//
//  Created by Sam Yang on 8/17/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBOperatorBlockView.h"
#import "BBLanguageBlock+Configure.h"
#import "BBQuantityParameterView.h"

@interface BBOperatorBlockView ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet BBQuantityParameterView *leftQuantityParameter;
@property (weak, nonatomic) IBOutlet BBQuantityParameterView *rightQuantityParameter;

@end

@implementation BBOperatorBlockView

- (void)setLanguageBlock:(BBLanguageBlock *)languageBlock
{
    [super setLanguageBlock:languageBlock];
    if ([languageBlock isMathOperatorBlock])
    {
        [self updateUIForMathOperator];
    }
    else if ([languageBlock isComparisonOperatorBlock])
    {
        [self updateUIForComparisonOperator];
    }
}

- (void)updateUIForMathOperator
{
    self.layer.cornerRadius = BLOB_QUANTITY_CORNER_RADIUS;
    [self updateUI];
}

- (void)updateUIForComparisonOperator
{
    self.layer.cornerRadius = BLOB_BLOCK_SLOT_CORNER_RADIUS;
    [self updateUI];
}

- (void)updateUI
{
    self.leftQuantityParameter.layer.cornerRadius = BLOB_QUANTITY_CORNER_RADIUS;
    self.rightQuantityParameter.layer.cornerRadius = BLOB_QUANTITY_CORNER_RADIUS;
    
    self.nameLabel.text = self.languageBlock.abbreviation ? self.languageBlock.abbreviation : self.languageBlock.name;
    
    CGSize labelStringSize = [self.nameLabel.text sizeWithAttributes: @{NSFontAttributeName:[UIFont fontWithName:BLOB_FONT_REGULAR size:BLOB_FONT_21PT]}];
    CGPoint originalOrigin = self.nameLabel.frame.origin;
    self.nameLabel.frame = CGRectMake(originalOrigin.x, originalOrigin.y, labelStringSize.width, labelStringSize.height);
    
    const CGFloat xOffset = 18.0f;
    const CGFloat xPadding = 8.0f;
    
    CGFloat calculatedWidth = labelStringSize.width + xOffset * 2 + xPadding * 2 + CGRectGetWidth(self.leftQuantityParameter.frame) + CGRectGetWidth(self.rightQuantityParameter.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGRect calculatedFrame = CGRectMake(CGPointZero.x, CGPointZero.y, calculatedWidth, height);
    self.frame = calculatedFrame;
}

@end
