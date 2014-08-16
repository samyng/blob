//
//  BBLanguageBlock+Configure.h
//  blob
//
//  Created by Sam Yang on 8/16/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBLanguageBlock.h"

@interface BBLanguageBlock (Configure)
- (BOOL)isIfThenBlock;
- (BOOL)isIfThenElseBlock;
- (BOOL)isWaitBlock;
- (BOOL)isRepeatBlock;
- (BOOL)isAccessoryBlock;
- (BOOL)isOperatorBlock;
- (BOOL)isNotBlock;
- (BOOL)isReactionBlock;
@end
