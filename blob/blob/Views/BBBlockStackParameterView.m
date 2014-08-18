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

- (BOOL)acceptsBlockView:(BBLanguageBlockView *)blockView
{
    return [blockView.languageBlock isReactionBlock] ? YES : NO;
}

@end
