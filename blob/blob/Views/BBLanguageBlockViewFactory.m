//
//  BBLanguageBlockViewFactory.m
//  blob
//
//  Created by Sam Yang on 8/16/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBLanguageBlockViewFactory.h"
#import "BBLanguageBlock+Configure.h"
#import "BBLanguageBlockView.h"

@implementation BBLanguageBlockViewFactory

+ (BBLanguageBlockView *)viewForBlock:(BBLanguageBlock *)languageBlock
{
    BBLanguageBlockView *blockView;
    if ([languageBlock isIfThenBlock])
    {
        blockView = [self viewFromNibName:IF_THEN_BLOCK_NIB_NAME];
    }
    else if ([languageBlock isIfThenElseBlock])
    {
        blockView = [self viewFromNibName:IF_THEN_ELSE_BLOCK_NIB_NAME];
    }
    else if ([languageBlock isWaitBlock])
    {
        blockView = [self viewFromNibName:WAIT_BLOCK_NIB_NAME];
    }
    else if ([languageBlock isRepeatBlock])
    {
        blockView = [self viewFromNibName:REPEAT_BLOCK_NIB_NAME];
    }
    else if ([languageBlock isAccessoryBlock])
    {
        blockView = [self viewFromNibName:ACCESSORY_BLOCK_NIB_NAME];
    }
    else if ([languageBlock isNotBlock])
    {
        blockView = [self viewFromNibName:NOT_BLOCK_NIB_NAME];
    }
    else if ([languageBlock isOperatorBlock])
    {
        blockView = [self viewFromNibName:OPERATOR_BLOCK_NIB_NAME];
    }
    else if ([languageBlock isReactionBlock])
    {
        blockView = [self viewFromNibName:REACTION_BLOCK_NIB_NAME];
    }
    blockView.languageBlock = languageBlock;
    return blockView;
}


+ (BBLanguageBlockView *)viewFromNibName:(NSString *)nibName {
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:nibName
                                                   owner:nil
                                                 options:nil];
    BBLanguageBlockView *view = (BBLanguageBlockView *)array[0];
    return view;
}

@end
