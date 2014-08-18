//
//  BBBlockSlotParameterView.m
//  blob
//
//  Created by Sam Yang on 8/16/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBBlockSlotParameterView.h"
#import "BBLanguageBlockView.h"
#import "BBLanguageBlock+Configure.h"

@implementation BBBlockSlotParameterView

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
    self.layer.cornerRadius = BLOB_BLOCK_SLOT_CORNER_RADIUS;
}

- (BOOL)acceptsBlockView:(BBLanguageBlockView *)blockView
{
    return ([blockView.languageBlock isAccessoryBlock] ||
            [blockView.languageBlock isReactionBlock] ||
            [blockView.languageBlock isLogicOperatorBlock] ||
            [blockView.languageBlock isNotBlock] ||
            [blockView.languageBlock isComparisonOperatorBlock]) ? YES : NO;
}

@end
