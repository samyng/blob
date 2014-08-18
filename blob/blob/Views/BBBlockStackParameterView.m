//
//  BBBlockStackParameterView.m
//  blob
//
//  Created by Sam Yang on 8/16/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBBlockStackParameterView.h"
#import "BBLanguageBlockView.h"
#import "BBLanguageBlock+Configure.h"

@implementation BBBlockStackParameterView

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
    NSLog(@"setup stack view");
}

+ (BOOL)acceptsBlockView:(BBLanguageBlockView *)blockView
{
    return [blockView.languageBlock isReactionBlock] ? YES : NO;
}

@end
