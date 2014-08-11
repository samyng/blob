//
//  BBLanguageBlockCollectionCell.m
//  blob
//
//  Created by Sam Yang on 8/7/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBLanguageBlockCollectionCell.h"
#import "BBLanguageBlock.h"
#import "BBLanguageGroup.h"

@interface BBLanguageBlockCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation BBLanguageBlockCollectionCell

- (void)updateColorsForBlock:(BBLanguageBlock *)block
{
    UIColor *backgroundColor;
    NSString *groupName = block.group.name;
    
    if ([groupName isEqualToString:REACTIONS_GROUP])
    {
        backgroundColor = [BBConstants blueDefaultColor];
    }
    else if ([groupName isEqualToString:CONTROL_GROUP])
    {
        backgroundColor = [BBConstants pinkDefaultColor];
    }
    else
    {
        backgroundColor = [UIColor whiteColor];
    }
    
    self.contentView.backgroundColor = backgroundColor;
}

- (void)configureWithBlock:(BBLanguageBlock *)block
{
    self.nameLabel.text = block.name;
    [self updateColorsForBlock:block];
}

@end
