//
//  BBCodeBlockCollectionCell.m
//  blob
//
//  Created by Sam Yang on 8/7/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBCodeBlockCollectionCell.h"
#import "BBLanguageBlock.h"

@interface BBCodeBlockCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation BBCodeBlockCollectionCell

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
