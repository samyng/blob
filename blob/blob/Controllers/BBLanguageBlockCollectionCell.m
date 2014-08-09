//
//  BBLanguageBlockCollectionCell.m
//  blob
//
//  Created by Sam Yang on 8/7/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBLanguageBlockCollectionCell.h"
#import "BBLanguageBlock.h"

@interface BBLanguageBlockCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation BBLanguageBlockCollectionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.contentView.backgroundColor = [BBConstants pinkDefaultColor];
}

- (void)configureWithBlock:(BBLanguageBlock *)block
{
    self.nameLabel.text = block.name;
}

@end
