//
//  BBAccessoryCollectionCell.m
//  blob
//
//  Created by Sam Yang on 8/5/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBAccessoryCollectionCell.h"
#import "BBAccessory+Configure.h"

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
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [BBConstants tealColor].CGColor;
    self.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)configureWithAccessory:(BBAccessory *)accessory
{
    self.thumbnailImageView.image = accessory.thumbnailImage;
}

@end
