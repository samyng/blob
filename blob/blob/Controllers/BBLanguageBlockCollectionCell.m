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

- (void)configureWithLanguageBlock:(BBLanguageBlock *)block
{
    self.nameLabel.text = block.name;
    NSString *groupName = block.group.name;
    self.contentView.backgroundColor = [BBConstants colorForCellWithLanguageGroupName:groupName];
    self.nameLabel.textColor = [BBConstants textColorForCellWithLanguageGroupName:groupName];
}

@end
