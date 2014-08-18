//
//  BBQuantityParameterView.m
//  blob
//
//  Created by Sam Yang on 8/16/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBQuantityParameterView.h"
#import "BBLanguageBlock+Configure.h"
#import "BBLanguageBlockView.h"

@implementation BBQuantityParameterView

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
    self.layer.cornerRadius = BLOB_QUANTITY_CORNER_RADIUS;
}

- (BOOL)acceptsBlockView:(BBLanguageBlockView *)blockView
{
    return [blockView.languageBlock isMathOperatorBlock] ? YES : NO;
}

@end
