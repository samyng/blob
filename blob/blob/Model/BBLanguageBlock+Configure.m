//
//  BBLanguageBlock+Configure.m
//  blob
//
//  Created by Sam Yang on 8/16/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBLanguageBlock+Configure.h"
#import "BBLanguageGroup.h"

@implementation BBLanguageBlock (Configure)

- (BOOL)isIfThenBlock
{
    return ([self isControlBlock] &&
            [self.name isEqualToString:IF_THEN_BLOCK_NAME]) ? YES : NO;
}

- (BOOL)isIfThenElseBlock
{
    return ([self isControlBlock] &&
            [self.name isEqualToString:IF_THEN_ELSE_BLOCK_NAME]) ? YES : NO;
}

- (BOOL)isWaitBlock
{
    return ([self isControlBlock] &&
            [self.name isEqualToString:WAIT_BLOCK_NAME]) ? YES : NO;
}

- (BOOL)isRepeatBlock
{
    return ([self isControlBlock] &&
            [self.name isEqualToString:REPEAT_BLOCK_NAME]) ? YES : NO;
}

- (BOOL)isAccessoryBlock
{
    return ([self.group.name isEqualToString:FROM_CLOSET_GROUP]) ? YES : NO;
}

- (BOOL)isOperatorBlock
{
    return ([self.group.name isEqualToString:OPERATORS_GROUP]) ? YES : NO;
}

- (BOOL)isNotBlock
{
    return ([self.group.name isEqualToString:OPERATORS_GROUP] &&
            [self.name isEqualToString:NOT_BLOCK_NAME]) ? YES : NO;
}

- (BOOL)isReactionBlock
{
    return [self.group.name isEqualToString:REACTIONS_GROUP] ? YES : NO;
}

- (BOOL)isControlBlock
{
    return [self.group.name isEqualToString:CONTROL_GROUP] ? YES : NO;
}

@end
