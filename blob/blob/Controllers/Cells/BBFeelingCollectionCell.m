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

@end

@implementation BBFeelingCollectionCell

- (void)configureWithFeeling:(BBFeeling *)feeling
{
    self.feelingLabel.text = feeling.name;
    self.feeling = feeling;
}

- (UIImage *)getRasterizedImageCopy
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0f);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
