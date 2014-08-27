//
//  BBLanguageBlock+Configure.h
//  blob
//
//  Created by Sam Yang on 8/16/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBLanguageBlock.h"

@interface BBLanguageBlock (Configure)
- (BOOL)isSwitchToBlock;
- (BOOL)isIfThenBlock;
- (BOOL)isIfThenElseBlock;
- (BOOL)isWaitBlock;
- (BOOL)isRepeatBlock;
- (BOOL)isAccessoryBlock;
- (BOOL)isOperatorBlock;
- (BOOL)isMathOperatorBlock;
- (BOOL)isComparisonOperatorBlock;
- (BOOL)isLogicOperatorBlock;
- (BOOL)isNotBlock;
- (BOOL)isReactionBlock;
@end
