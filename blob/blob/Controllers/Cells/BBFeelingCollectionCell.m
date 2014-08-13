//
//  BBFeelingCollectionCell.m
//  blob
//
//  Created by Sam Yang on 8/6/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBFeelingCollectionCell.h"
#import "BBFeeling.h"

@interface BBFeelingCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *feelingLabel;
@end

@implementation BBFeelingCollectionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self resetDefaultUI];
}

- (void)configureWithFeeling:(BBFeeling *)feeling
{
    self.feelingLabel.text = [feeling.name lowercaseString];
    self.feeling = feeling;
}

- (UIImage *)rasterizedImageCopy
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0f);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setToBlankState
{
    self.feelingLabel.alpha = 0.0f;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)resetDefaultUI
{
    self.feelingLabel.alpha = 1.0f;
    self.feelingLabel.textColor = [BBConstants yellowTextColor];
    self.contentView.backgroundColor = [BBConstants yellowColor];
}


@end
