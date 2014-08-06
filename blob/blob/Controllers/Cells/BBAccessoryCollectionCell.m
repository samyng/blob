//
//  BBAccessoryCollectionCell.m
//  blob
//
//  Created by Sam Yang on 8/5/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBAccessoryCollectionCell.h"

@interface BBAccessoryCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@end

@implementation BBAccessoryCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    self.backgroundColor = [UIColor darkGrayColor];
    self.layer.borderWidth = 5.0f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)configureWithAccessory:(BBAccessory *)accessory
{
    self.thumbnailImageView.image = accessory.thumbnailImage;
}

@end
