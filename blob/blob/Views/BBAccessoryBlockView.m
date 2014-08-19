//
//  BBAccessoryBlockView.m
//  blob
//
//  Created by Sam Yang on 8/17/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBAccessoryBlockView.h"
#import "BBLanguageBlock.h"
#import "BBAccessory+Configure.h"

@interface BBAccessoryBlockView ()
@property (weak, nonatomic) IBOutlet UILabel *nearAccessoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@end

@implementation BBAccessoryBlockView

- (void)updateUI
{
    self.layer.cornerRadius = BLOB_BLOCK_SLOT_CORNER_RADIUS;
    const CGFloat xPadding = 12.0f;
    const CGFloat yPadding = 15.0f;
    
    self.thumbnailImageView.image = [UIImage imageNamed:[NSString stringWithFormat:ACCESSORY_THUMBNAIL_FORMAT, self.languageBlock.name]];
    self.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSString *labelText = [NSString stringWithFormat:@"near %@", [self.languageBlock.name lowercaseString]];
    self.nearAccessoryLabel.text = labelText;
    
    CGSize labelStringSize = [self.nearAccessoryLabel.text sizeWithAttributes: @{NSFontAttributeName:[UIFont fontWithName:BLOB_FONT_REGULAR size:BLOB_FONT_21PT]}];
    self.nearAccessoryLabel.frame = CGRectMake(xPadding, yPadding, labelStringSize.width, labelStringSize.height);
    
    CGFloat calculatedWidth = labelStringSize.width + xPadding * 3 + CGRectGetWidth(self.thumbnailImageView.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGRect calculatedFrame = CGRectMake(CGPointZero.x, CGPointZero.y, calculatedWidth, height);
    self.frame = calculatedFrame;
}

- (void)setLanguageBlock:(BBLanguageBlock *)languageBlock
{
    [super setLanguageBlock:languageBlock];
    [self updateUI];
}

- (CGSize)originalSize
{
    return CGSizeMake(250.0f, 55.0f);
}

@end
